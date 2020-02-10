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
            self.request.db.query(porydex.db.Type)
                .filter(porydex.db.Type.in_current_gen())
                .order_by(porydex.db.Type.id)
                .all()
        )

        return {'types': types}

    @view_config(context=porydex.db.Type, renderer='/type.mako')
    def view(self):
        """A type's page."""

        return {'type': self.request.context, 'pokemon': self.pokemon()}

    def pokemon(self):
        return (
            self.request.db.query(porydex.db.PokemonForm)
            .join(porydex.db.PokemonForm._current_gpf)
            .filter(porydex.db.GenerationPokemonForm.types.any(
                porydex.db.Type.id == self.request.context.id
            ))
            .order_by(porydex.db.PokemonForm.order)
            .all()
        )
