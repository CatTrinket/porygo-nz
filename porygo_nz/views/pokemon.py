from pyramid.view import view_config

from porydex import db
import porygo_nz.db_util
from porygo_nz.resources import HomeResource, LookupResource, Resource


@HomeResource.child_resource()
class PokemonIndexResource(Resource):
    __name__ = 'pokemon'


@PokemonIndexResource.child_resource()
class PokemonResource(LookupResource):
    @classmethod
    def lookup(cls, request, key):
        return (
            request.db.query(db.PokemonForm)
            .filter_by(identifier=key)
            .one_or_none()
        )

    @property
    def __name__(self):
        return self.item.identifier


@view_config(
    context=PokemonIndexResource, renderer='/pokemon_index.mako')
class PokemonIndexView:
    def __init__(self, request):
        self.request = request

    def __call__(self):
        return {'pokemon': self.pokemon()}

    def pokemon(self):
        pokemon = (
            self.request.db.query(db.PokemonInstance)
            .join(db.PokemonForm)
            .order_by(db.PokemonForm.order)
            .options(*porygo_nz.db_util.pokemon_table_options())
        )

        if self.request.game is not None:
            pokemon = pokemon.filter(
                db.PokemonInstance.game_id == self.request.game.id)
        else:
            pokemon = pokemon.filter(db.PokemonInstance.is_current)

        return pokemon.all()

@view_config(context=PokemonResource, renderer='/pokemon.mako')
class PokemonView:
    def __init__(self, request):
        self.request = request
        self.pokemon_form = request.context.item

    def __call__(self):
        instance = self.pokemon_instance()

        return {
            'pokemon_instance': instance,
            'pokemon_form': instance.pokemon_form,
            'pokemon_species': instance.pokemon_form.pokemon,
        }

    def pokemon_instance(self):
        pokemon = (
            self.request.db.query(db.PokemonInstance)
            .filter_by(
                pokemon_id=self.pokemon_form.pokemon_id,
                form_id=self.pokemon_form.form_id
            )
        )

        if self.request.game is not None:
            pokemon = pokemon.filter_by(game_id=self.request.game.id)
        else:
            pokemon = pokemon.filter_by(is_current=True)

        return pokemon.one()
