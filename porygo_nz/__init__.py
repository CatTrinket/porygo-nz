from pyramid.config import Configurator

from .resources import get_root


def main(global_config, **settings):
    """Return a Pyramid WSGI application."""

    settings.setdefault('mako.directories', 'porygo_nz:templates')

    config = Configurator(settings=settings, root_factory=get_root)
    config.include('pyramid_mako')
    config.scan()

    return config.make_wsgi_app()
