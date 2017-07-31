import sqlalchemy as sa

import porydex.db
import porygo_nz.db


class Root:
    """A root resource."""

    __name__ = None
    __parent__ = None

    generation = None

    def __init__(self, request):
        self.indices = {}
        self.generation_index = None
        self.request = request

    def __getitem__(self, key):
        """Return the corresponding Index or GenerationIndex."""

        if key in self.indices:
            return self.indices[key]

        try:
            generation = (
                porygo_nz.db.DBSession.query(porydex.db.Generation)
                .filter_by(identifier=key)
                .one()
            )
        except sa.orm.exc.NoResultFound:
            raise KeyError

        self.request.session.generation_id = generation.id
        self.generation_index = GenerationIndex(generation, self)

        return self.generation_index

    def add_index(self, index_class):
        """Add a child resource of the given class."""

        index = index_class(self)
        self.indices[index.__name__] = index

class GenerationIndex:
    """A generation-specific version of the root."""

    def __init__(self, generation, root_instance):
        self.__name__ = generation.identifier
        self.__parent__ = root_instance

        self.generation = generation

    def __getitem__(self, key):
        return self.__parent__.indices[key]

class Index:
    """A resource representing an index page for some table, e.g. all the
    Pokémon or all the moves.

    The table must have an identifier column to look up children.
    """

    def __init__(self, root):
        self.root_instance = root
        self.table.__getattr__ = identifier_getattr
        self.table.__parent__ = self

    def __getitem__(self, key):
        """Look up the given key in the associated table."""

        query = (
            self.root_instance.request.session.query(self.table)
            .filter_by(identifier=key)
        )

        if self.__parent__.generation is not None:
            generation_id = self.__parent__.generation.id
            query = query.filter(
                self.table._by_generation.any(generation_id=generation_id))

        try:
            return query.one()
        except sa.orm.exc.NoResultFound:
            raise KeyError

    @property
    def __parent__(self):
        """Return the current generation index, if applicable, or else the root
        resource.
        """

        return self.root_instance.generation_index or self.root_instance

class TypeIndex(Index):
    __name__ = 'types'
    table = porydex.db.Type


def identifier_getattr(self, name):
    """A method to add to a table class as __getattr__.  Return the object's
    identifier as its name for Pyramid traversal.
    """

    if name == '__name__':
        return self.identifier
    else:
        raise AttributeError

def request_generation(request):
    """Get the generation for a request.

    This gets added as a request property in __init__.py.
    """

    index = request.root.generation_index or request.root

    return index.generation

def get_root(request):
    """Get a root resource."""

    root = Root(request)
    root.add_index(TypeIndex)

    return root
