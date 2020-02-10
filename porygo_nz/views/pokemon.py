from pyramid.view import view_config
import sqlalchemy as sa

import porydex.db
import porygo_nz.db
import porygo_nz.resources


class PokemonView:
    """Views related to Pokémon."""

    def __init__(self, request):
        self.request = request

    @view_config(context=porygo_nz.resources.PokemonIndex,
                 renderer='/pokemon_index.mako')
    def index(self):
        """The Pokémon index."""

        pokemon = (
            self.request.db.query(porydex.db.PokemonForm)
                .filter(porydex.db.PokemonForm.in_current_gen())
                .order_by(porydex.db.PokemonForm.order)
                .all()
        )

        return {'pokemon': pokemon}

    @view_config(context=porydex.db.PokemonForm, renderer='/pokemon.mako')
    def view(self):
        """A Pokémon's page."""

        return {'pokemon': self.request.context}
