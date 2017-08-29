from pyramid.view import view_config

import porydex.db
import porygo_nz.db
import porygo_nz.resources


class MoveView:
    """Views related to moves."""

    def __init__(self, request):
        self.request = request

    @view_config(context=porygo_nz.resources.MoveIndex,
                 renderer='/move_index.mako')
    def index(self):
        """The move index."""

        moves = (
            self.request.session.query(porydex.db.Move)
                .filter(porydex.db.Move.in_current_gen())
                .order_by(porydex.db.Move.id)
                .all()
        )

        return {'moves': moves}

    @view_config(context=porydex.db.Move, renderer='/move.mako')
    def view(self):
        """An move's page."""

        return {'move': self.request.context}
