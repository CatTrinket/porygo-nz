import pyramid.config
import sqlalchemy

import porygo_nz.db
import porygo_nz.resources


def main(global_config, **settings):
    """Return a Pyramid WSGI application."""

    settings.setdefault('mako.directories', 'porygo_nz:templates')

    engine = sqlalchemy.engine_from_config(settings, 'sqlalchemy.')
    porygo_nz.db.DBSession.configure(bind=engine)

    config = pyramid.config.Configurator(
        settings=settings, root_factory=porygo_nz.resources.get_root)
    config.include('pyramid_mako')
    config.add_request_method(
        porygo_nz.resources.request_generation, name='generation', reify=True)
    config.add_request_method(
        porygo_nz.db.request_session, name='session', reify=True)
    config.scan()

    return config.make_wsgi_app()
