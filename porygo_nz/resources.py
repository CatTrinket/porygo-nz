from porydex import db


class ResourceMeta(type):
    """The metaclass for porygo_nz's resources.

    This adds a couple of internal-use class properties used to keep track of
    child resources.  See `Resource` for more details.
    """

    def __new__(cls, name, bases, dct):
        new_class = super().__new__(cls, name, bases, dct)
        new_class._named_children = {}
        new_class._lookup_children = []

        return new_class


class Resource(metaclass=ResourceMeta):
    """The base class for porygo_nz's resources, using Pyramid traversal.

    Each resource class keeps track of classes for child resources.  Children
    can be added with the `child_resource` decorator method; the parent class
    will then be able to find the child by its `__name__` during traversal.
    Resources may also have a `lookup` method instead of a static `__name__`;
    see `LookupResource`.

    Constructor parameters:
    - `request`: The current request.
    - `game`: The Pokémon game (a db `Game` object) for this resource.  Use
      `None` for no game, or `Ellipsis` to get the game from the request.
      `Ellipsis` is the default; this makes creating resources inside templates
      to generate URLs nice and concise.  (However, this relies on the
      request's context already being set up, so any resource methods which
      create other resources should pass the game along explicitly.)
    - `_parent`: During traversal, the parent resource should pass itself in
      using this parameter.  Otherwise, this can be left blank.
    """

    def __init__(self, request, game=Ellipsis, _parent=None):
        if game is Ellipsis:
            game = request.game

        self.request = request
        self.game = game
        self._parent = _parent

    @classmethod
    def child_resource(cls, priority=0):
        """Return a decorator function to add a resource class as a child of
        this one.

        The `priority` parameter determines the order in which child classes'
        `lookup` methods are called; children with higher priorities are tried
        first, and the first one to return a match is used.  It is not used for
        children with a static `__name__` instead of a `lookup` method; named
        children always have priority over lookup children.

        Example usage:

        @ParentResource.child_resource()
        class ChildResource(Resource):
            __name__ = 'child'
            ...

        @ParentResource.child_resource(priority=1)
        class ChildResource2(LookupResource):
            @classmethod
            def lookup(cls, key):
                ...
        """

        def _add_child(child_class):
            # child_class.__name__ is the class name, so we need to go through
            # __dict__ to get the traversal __name__ defined in the class body
            name = child_class.__dict__.get('__name__')

            if isinstance(name, str):
                cls._named_children[name] = child_class
            elif hasattr(child_class, 'lookup'):
                cls._lookup_children.append((child_class, priority))
                cls._lookup_children.sort(key=lambda cls_pri: cls_pri[1])
            else:
                raise ValueError(
                    'Child resource must either have a lookup method, or have '
                    '__name__ defined on the class as a static string'
                )

            child_class._parent_class = cls

            return child_class

        return _add_child

    @property
    def __parent__(self):
        if self._parent is None and self._parent_class is not None:
            self._parent = self._parent_class(
                request=self.request, game=self.game)

        return self._parent

    def __getitem__(self, key):
        child_class = self._named_children.get(key)

        if child_class is not None:
            return child_class(
                request=self.request, game=self.game, _parent=self)

        # Priority can be ignored here; child_resource already keeps the list
        # sorted
        for (child_class, _) in self._lookup_children:
            context = child_class.lookup(self.request, key)

            if context is not None:
                return child_class(
                    context, request=self.request, game=self.game, _parent=self)

        raise KeyError


class LookupResource(Resource):
    """A base class for a resource that wraps a context item, such as a
    database object.

    Lookup resources have a `lookup` class method to return the corresponding
    item.  Whereas `__getitem__` looks up a child resource, `lookup` returns an
    item to be wrapped by *this* resource.  The parent's `__getitem__` will
    call this class's `lookup` method, then pass the item back into this
    class's constructor.

    The context item is assigned to the `item` attribute.  (It's `item` rather
    than `context` to avoid typing `request.context.context`.  This is a little
    awkward, since "item" is also a term in the Pokémon games, but there aren't
    really any less-awkward options.)
    """

    def __init__(self, item, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.item = item

    @classmethod
    def lookup(cls, request, key):
        """Look up the given key and return the corresponding item."""

        raise NotImplementedError


class HomeResource(Resource):
    """The home page.

    The root resource is one of these, and it also has further children of the
    same class for each game's version of the front page.
    """

    @property
    def __name__(self):
        if self.game is not None:
            return self.game.identifier
        else:
            return None

    @property
    def __parent__(self):
        if self._parent is None and self.game is not None:
            self._parent = HomeResource(request=self.request, game=None)

        return self._parent

    def __getitem__(self, key):
        if self.game is None:
            game = (
                self.request.db.query(db.Game)
                .filter_by(identifier=key)
                .one_or_none()
            )

            if game is not None:
                return HomeResource(
                    request=self.request, game=game, _parent=self)

        return super().__getitem__(key)


def get_root(request):
    """Return a root resource for the given request."""

    return HomeResource(request=request, game=None)
