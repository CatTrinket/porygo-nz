import pyramid.decorator
import pyramid.view
import sqlalchemy as sa
import sqlalchemy.orm

import porydex.db
from porygo_nz.db_util import pokemon_table_options
from porygo_nz.resources import HomeResource, LookupResource, Resource


@HomeResource.child_resource()
class TypeIndexResource(Resource):
    __name__ = 'types'


@TypeIndexResource.child_resource()
class TypeResource(LookupResource):
    @classmethod
    def lookup(cls, request, key):
        return (
            request.db.query(porydex.db.Type)
            .filter_by(identifier=key)
            .one_or_none()
        )

    @property
    def __name__(self):
        return self.item.identifier


@pyramid.view.view_config(
    context=TypeIndexResource, renderer='/type_index.mako')
class TypeIndexView:
    def __init__(self, request):
        self.request = request
        self.context = request.context

    def __call__(self):
        return {'types': self.types()}

    def types(self):
        types = (
            self.request.db.query(porydex.db.Type)
            .order_by(porydex.db.Type.id)
            .options(sa.orm.selectinload(porydex.db.Type._names))
        )

        if self.context.game is not None:
            types = (
                types.join(porydex.db.TypeInstance)
                .filter_by(game_id=self.context.game.id)
            )

        return types.all()


@pyramid.view.view_config(context=TypeResource, renderer='/type.mako')
class TypeView:
    def __init__(self, request):
        self.request = request
        self.context = request.context

    def __call__(self):
        return {
            'type': self.context.item,
            'pokemon': self.pokemon(),
        }

    def pokemon(self):
        query = (
            self.request.db.query(porydex.db.PokemonInstance)
            .join(porydex.db.PokemonType)
            .join(porydex.db.PokemonInstance.pokemon_form)
            .filter(porydex.db.PokemonType.type_id == self.context.item.id)
            .order_by(porydex.db.PokemonForm.order)
            .options(*pokemon_table_options())
        )

        if self.context.game is not None:
            query = query.filter(
                porydex.db.PokemonInstance.game_id == self.context.game.id)
        else:
            query = query.filter(porydex.db.PokemonInstance.is_current)

        return query.all()
