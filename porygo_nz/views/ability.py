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
            self.request.db.query(porydex.db.Ability)
                .filter(porydex.db.Ability.in_current_gen())
                .order_by(porydex.db.Ability.id)
                .all()
        )

        return {'abilities': abilities}

    @view_config(context=porydex.db.Ability, renderer='/ability.mako')
    def view(self):
        """An ability's page."""

        return {
            'ability': self.request.context,
            'pokemon_regular': self.pokemon_regular(),
            'pokemon_hidden': self.pokemon_hidden(),
            'pokemon_unique': self.pokemon_unique()
        }

    def pokemon_base(self):
        return (
            self.request.db.query(porydex.db.PokemonForm)
            .join(porydex.db.PokemonForm._current_gpf)
            .join(porydex.db.GenerationPokemonForm.pokemon_abilities)
            .filter_by(ability_id=self.request.context.id)
            .order_by(porydex.db.PokemonForm.order)
        )

    def pokemon_regular(self):
        return (
            self.pokemon_base()
            .filter(porydex.db.PokemonAbility.slot.in_((
                porydex.db.AbilitySlot.ability_1,
                porydex.db.AbilitySlot.ability_2
            )))
            .all()
        )

    def pokemon_hidden(self):
        return (
            self.pokemon_base()
            .filter_by(slot=porydex.db.AbilitySlot.hidden_ability)
            .all()
        )

    def pokemon_unique(self):
        return (
            self.pokemon_base()
            .filter_by(slot=porydex.db.AbilitySlot.unique_ability)
            .all()
        )
