import porydex.db
from porygo_nz.db import DBSession


def show_abilities(request):
    """Return whether abilities exist in the current request's generation."""

    if request.generation is None:
        return True

    query = (
        DBSession.query(porydex.db.GenerationAbility)
        .filter_by(generation_id=request.generation.id)
    )

    return DBSession.query(query.exists()).scalar()

def show_hidden_abilities(request):
    """Return whether hidden abilities exist in the current request's
    generation.
    """

    if request.generation is None:
        return True
 
    query = (
        DBSession.query(porydex.db.PokemonAbility)
        .filter_by(
            generation_id=request.generation.id,
            slot=porydex.db.AbilitySlot.hidden_ability
        )
    )

    return DBSession.query(query.exists()).scalar()
