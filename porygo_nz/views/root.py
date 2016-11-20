from pyramid.view import view_config

from ..resources import Root


@view_config(context=Root, renderer='/root.mako')
def root(context, request):
    return {}
