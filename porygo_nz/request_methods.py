from porydex import db


def game(request):
    """Return the selected game for the current request.

    This attribute should not be accessed in instances where the request's
    context isn't done being set up yet; if it is, it will raise
    AttributeError.
    """

    return request.context.game

def show_abilities(request):
    """Return whether abilities exist in the current request's game."""

    if request.game is None:
        return True

    query = (
        request.db.query(db.AbilityInstance)
        .filter_by(game_id=request.game.id)
    )

    return request.db.query(query.exists()).scalar()

def show_hidden_abilities(request):
    """Return whether hidden abilities exist in the current request's game."""

    if request.game is None:
        return True
 
    query = (
        request.db.query(db.PokemonAbility)
        .filter_by(
            game_id=request.game.id,
            slot=db.AbilitySlot.hidden_ability
        )
    )

    return request.db.query(query.exists()).scalar()
