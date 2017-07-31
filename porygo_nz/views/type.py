from pyramid.view import view_config

import porydex.db
import porygo_nz.db
import porygo_nz.resources


class TypeView:
    """Views related to types."""

    def __init__(self, request):
        self.request = request

    @view_config(context=porygo_nz.resources.TypeIndex,
                 renderer='/type_index.mako')
    def index(self):
        """The type index."""

        types = (
            self.request.session.query(porydex.db.Type)
                .filter(porydex.db.Type.in_current_gen())
                .order_by(porydex.db.Type.id)
                .all()
        )

        return {'types': types}

    @view_config(context=porydex.db.Type, renderer='/type.mako')
    def view(self):
        """A type's page."""

        type = self.request.context
        generation_id = None

        if self.request.root.generation_index is not None:
            generation_id = self.request.root.generation_index.generation.id

        return {'type': self.request.context,
                'pokemon': type.pokemon[generation_id or max(type.pokemon)]}
