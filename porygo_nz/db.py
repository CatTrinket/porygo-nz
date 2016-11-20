import sqlalchemy as sa
import sqlalchemy.orm

import porydex.db.core


DBSession = sa.orm.scoped_session(
    sa.orm.sessionmaker(class_=porydex.db.core.PorydexSession))


def request_session(request):
    """Get a session for a request.

    This gets added as a request property in __init__.py.
    """

    session = DBSession()

    if request.generation is None:
        session.generation_id = None
    else:
        session.generation_id = request.generation.id

    return session
