class Root:
    """A root resource."""

    __name__ = None
    __parent__ = None

    def __getitem__(self, key):
        raise KeyError


def get_root(request):
    """Get a root resource."""

    return Root()
