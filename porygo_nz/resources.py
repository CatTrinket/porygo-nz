import sqlalchemy as sa

import porydex.db
import porygo_nz.db


class Root:
    """A root resource."""

    __name__ = None
    __parent__ = None

    # This indicates *this* object's generation; it is None even if we have a
    # generation index as a child
    generation = None

    def __init__(self, request):
        self.indices = {}
        self.generation_index = None
        self.request = request

    def __getitem__(self, key):
        """Return the corresponding Index or GenerationIndex."""

        if key in self.indices:
            # XXX This could be called for reasons other than the initial
            # traversal; generation should be determined some other way
            self.request.generation = None
            return self.indices[key]

        try:
            generation = (
                porygo_nz.db.DBSession.query(porydex.db.Generation)
                .filter_by(identifier=key)
                .one()
            )
        except sa.orm.exc.NoResultFound:
            raise KeyError

        # XXX See previous "XXX" comment
        self.request.generation = generation
        # XXX Same thing
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
        """Get an item from the root, but don't return it if it's specific to
        later generations.
        """

        item = self.__parent__.indices[key]

        if (item.min_generation_id is not None and
                item.min_generation_id > self.generation.id):
            raise KeyError

        return item

class Index:
    """A resource representing an index page for some table, e.g. all the
    Pokémon or all the moves.

    The table must have an identifier column to look up children.
    """

    table = None
    min_generation_id = None

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

class PokemonIndex(Index):
    __name__ = 'pokemon'
    table = porydex.db.PokemonForm
    # XXX Should redirect e.g. shaymin to shaymin-land

class MoveIndex(Index):
    __name__ = 'moves'
    table = porydex.db.Move

class AbilityIndex(Index):
    __name__ = 'abilities'
    table = porydex.db.Ability
    min_generation_id = 3

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

def get_root(request):
    """Get a root resource."""

    root = Root(request)
    root.add_index(PokemonIndex)
    root.add_index(MoveIndex)
    root.add_index(AbilityIndex)
    root.add_index(TypeIndex)

    return root
