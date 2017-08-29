from pyramid.view import view_config

import porydex.db
import porygo_nz.db
import porygo_nz.resources


class AbilityView:
    """Views related to abilities."""

    def __init__(self, request):
        self.request = request

    @view_config(context=porygo_nz.resources.AbilityIndex,
                 renderer='/ability_index.mako')
    def index(self):
        """The ability index."""

        abilities = (
            self.request.session.query(porydex.db.Ability)
                .filter(porydex.db.Ability.in_current_gen())
                .order_by(porydex.db.Ability.id)
                .all()
        )

        return {'abilities': abilities}

    @view_config(context=porydex.db.Ability, renderer='/ability.mako')
    def view(self):
        """An ability's page."""

        return {'ability': self.request.context}
