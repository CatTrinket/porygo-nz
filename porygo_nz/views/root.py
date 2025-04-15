from pyramid.view import view_config

from ..resources import HomeResource


@view_config(context=HomeResource, renderer='/root.mako')
def root(request):
    return {}
