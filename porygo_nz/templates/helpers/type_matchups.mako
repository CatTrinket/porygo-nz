<%page args="types, defending=False" />
<%namespace name="h" file="/helpers/helpers.mako" />

<%!
    import fractions

    import sqlalchemy as sa

    import porydex.db


    QUADRUPLE = fractions.Fraction(4)
    DOUBLE = fractions.Fraction(2)
    NEUTRAL = fractions.Fraction(1)
    HALF = fractions.Fraction(1, 2)
    QUARTER = fractions.Fraction(1, 4)
    ZERO = fractions.Fraction(0)


    def type_chart_id(request):
        if request.context.game is not None:
            return request.context.game.type_chart_id
        else:
            return (
                request.db.query(sa.func.max(porydex.db.TypeChart.id))
                .subquery()
            )

    def matchups_by_type(request, types, defending):
        if defending:
            type_col = porydex.db.TypeMatchup.defending_type_id
        else:
            type_col = porydex.db.TypeMatchup.attacking_type_id

        by_type = {}

        for type_ in types:
            matchups = (
                request.db.query(porydex.db.TypeMatchup)
                .filter(
                    porydex.db.TypeMatchup.type_chart_id
                        == type_chart_id(request),
                    type_col == type_.id
                )
                .options(
                    sa.orm.joinedload(
                        porydex.db.TypeMatchup.attacking_type
                        if defending
                        else porydex.db.TypeMatchup.defending_type
                    ).selectinload(porydex.db.Type._names)
                )
                .all()
            )

            for matchup in matchups:
                if defending:
                    other_type = matchup.attacking_type
                else:
                    other_type = matchup.defending_type

                by_type.setdefault(other_type, NEUTRAL)
                by_type[other_type] *= matchup.result.damage_multiplier

        return by_type

    def matchups_by_multiplier(request, types, defending):
        by_type = matchups_by_type(request, types, defending)
        by_multiplier = {}

        for (type_, multiplier) in by_type.items():
            by_multiplier.setdefault(multiplier, []).append(type_)

        for type_list in by_multiplier.values():
            type_list.sort(key=lambda type_: type_.id)

        return by_multiplier
%>

<% matchups = matchups_by_multiplier(request, types, defending) %>

<%def name="matchup_dd(multiplier)">
    % if multiplier in matchups:
        <dd>${h.type_list(matchups[multiplier])}</dd>
    % else:
        <dd class="not-applicable">n/a</dd>
    % endif
</%def>

<dl class="two-tier type-matchups">
    % if defending:
        <dt>Weak to</dt>
    % else:
        <dt>Super effective vs.</dt>
    % endif
    <dd>
        <dl>
            % if len(types) > 1:
                <dt>4×</dt>
                ${matchup_dd(QUADRUPLE)}
            % endif

            <dt>2×</dt>
            ${matchup_dd(DOUBLE)}
        </dl>
    </dd>

    % if defending:
        <dt>Resistant to</dt>
    % else:
        <dt>Not very effective vs.</dt>
    % endif
    <dd>
        <dl>
            <dt>½×</dt>
            ${matchup_dd(HALF)}

            % if len(types) > 1:
                <dt>¼×</dt>
                ${matchup_dd(QUARTER)}
            % endif
        </dl>
    </dd>

    % if defending:
        <dt>Immune to</dt>
    % else:
        <dt>No effect vs.</dt>
    % endif
    <dd>
        <dl>
            <dt>0×</dt>
            ${matchup_dd(ZERO)}
        </dl>
    </dd>
</dl>
