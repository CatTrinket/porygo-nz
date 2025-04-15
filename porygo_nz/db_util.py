import functools

import sqlalchemy as sa
import sqlalchemy.orm

import porydex.db as db


DBSession = sa.orm.scoped_session(sa.orm.sessionmaker())


def pokemon_table_options():
    """Return a list of loader options for a `PokemonInstance` query, to load
    all the relationships used in rendering a standard Pokémon table.

    See `pokemon_table` in templates/helpers/tables.mako.
    """

    return [
        sa.orm.joinedload(db.PokemonInstance.pokemon_form)
        .options(
            sa.orm.joinedload(db.PokemonForm.pokemon)
            .selectinload(db.Pokemon._names),

            sa.orm.selectinload(db.PokemonForm._names),
        ),

        sa.orm.selectinload(db.PokemonInstance.types)
        .selectinload(db.Type._names),

        sa.orm.selectinload(db.PokemonInstance.stats),

        sa.orm.selectinload(db.PokemonInstance.pokemon_abilities)
        .selectinload(db.PokemonAbility.ability)
        .selectinload(db.Ability._names),
    ]
