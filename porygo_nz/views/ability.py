from pyramid.view import view_config
import sqlalchemy as sa

from porydex import db
import porygo_nz.db_util
from porygo_nz.resources import HomeResource, LookupResource, Resource


@HomeResource.child_resource()
class AbilityIndexResource(Resource):
    __name__ = 'abilities'


@AbilityIndexResource.child_resource()
class AbilityResource(LookupResource):
    @classmethod
    def lookup(cls, request, key):
        return (
            request.db.query(db.Ability)
            .filter_by(identifier=key)
            .one_or_none()
        )

    @property
    def __name__(self):
        return self.item.identifier


@view_config(
    context=AbilityIndexResource, renderer='/ability_index.mako')
class AbilityIndexView:
    def __init__(self, request):
        self.request = request

    def __call__(self):
        return {'abilities': self.abilities()}

    def abilities(self):
        abilities = (
            self.request.db.query(db.Ability)
            .order_by(db.Ability.id)
            .options(sa.orm.selectinload(db.Ability._names))
        )

        if self.request.game is not None:
            abilities = (
                abilities.join(db.AbilityInstance)
                .filter_by(game_id=self.request.game.id)
            )

        return abilities.all()


@view_config(context=AbilityResource, renderer='/ability.mako')
class AbilityView:
    def __init__(self, request):
        self.request = request
        self.ability = request.context.item

    def __call__(self):
        return {
            'ability': self.ability,
            'pokemon_regular': self.pokemon_regular(),
            'pokemon_hidden': self.pokemon_hidden(),
            'pokemon_unique': self.pokemon_unique(),
        }

    def _pokemon_base(self):
        query = (
            self.request.db.query(db.PokemonInstance)
            .join(db.PokemonAbility)
            .filter_by(ability_id=self.ability.id)
            .join(db.PokemonForm)
            .order_by(db.PokemonForm.order)
            .options(*porygo_nz.db_util.pokemon_table_options())
        )

        if self.request.game is not None:
            query = query.filter(
                db.PokemonInstance.game_id == self.request.game.id)
        else:
            query = query.filter(db.PokemonInstance.is_current)

        return query

    def pokemon_regular(self):
        return (
            self._pokemon_base()
            .filter(db.PokemonAbility.slot.in_(
                (db.AbilitySlot.ability_1, db.AbilitySlot.ability_2)
            ))
            .all()
        )

    def pokemon_hidden(self):
        return (
            self._pokemon_base()
            .filter(db.PokemonAbility.slot == db.AbilitySlot.hidden_ability)
            .all()
        )

    def pokemon_unique(self):
        return (
            self._pokemon_base()
            .filter(db.PokemonAbility.slot == db.AbilitySlot.unique_ability)
            .all()
        )
