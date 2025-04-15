from pyramid.view import view_config
import sqlalchemy as sa
import sqlalchemy.orm

from porydex import db
import porygo_nz.db_util
from porygo_nz.resources import HomeResource, LookupResource, Resource


@HomeResource.child_resource()
class MoveIndexResource(Resource):
    __name__ = 'moves'


@MoveIndexResource.child_resource()
class MoveResource(LookupResource):
    @classmethod
    def lookup(cls, request, key):
        return (
            request.db.query(db.Move)
            .filter_by(identifier=key)
            .one_or_none()
        )

    @property
    def __name__(self):
        return self.item.identifier


@view_config(
    context=MoveIndexResource, renderer='/move_index.mako')
class MoveIndexView:
    def __init__(self, request):
        self.request = request

    def __call__(self):
        return {'moves': self.moves()}

    def moves(self):
        moves = (
            self.request.db.query(db.Move)
            .order_by(db.Move.id)
            .options(sa.orm.selectinload(db.Move._names))
        )

        if self.request.game is not None:
            moves = (
                moves.join(db.MoveInstance)
                .filter_by(game_id=self.request.game.id)
            )

        return moves.all()


@view_config(context=MoveResource, renderer='/move.mako')
class MoveView:
    def __init__(self, request):
        self.request = request
        self.move = request.context.item

    def __call__(self):
        return {'move': self.move}
