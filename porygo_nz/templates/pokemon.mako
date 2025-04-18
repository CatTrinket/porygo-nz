<%!
    import decimal

    from porydex.db import AbilitySlot
    from porygo_nz.views.ability import AbilityResource
%>

<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />
<%namespace name="type_matchups" file="helpers/type_matchups.mako" />

<%block name="title">${pokemon_form.full_name} - Pokémon - porygo.nz</%block>

<%block name="breadcrumbs">
    <li>${h.link(request.context.__parent__, text='Pokémon')}</li>
    <li>
        ${pokemon_species.name}
        % if pokemon_form.name:
            <span class="pokemon-form-name">(${pokemon_form.name})</span>
        % endif
    </li>
</%block>

<div id="pokemon-basics">
    <div id="pokemon-portrait">
        <img src="/static/pokemon/${pokemon_form.identifier}.png" alt="">
        ${h.type_list(pokemon_instance.types)}
    </div>

    <div id="pokemon-misc">
        <h2>General info</h2>
        <dl>
            <dt>Number</dt>
            <dd>${pokemon_species.id}</dd>

            <dt>Title</dt>
            <dd><span class="data-pending">[data pending]</span> Pokémon</dd>

            <dt>Height</dt>
            <dd>
                % if pokemon_form.identifier.endswith('-gigantamax'):
                    ${pokemon_form.height_m // 1} m +
                % else:
                    ${pokemon_form.height_m} m
                % endif
            </dd>

            <dd>
                <%
                    inches = pokemon_form.height_m / decimal.Decimal('0.0254')
                    inches = round(inches)
                    (feet, inches) = divmod(inches, 12)
                %>
                % if pokemon_form.identifier.endswith('-gigantamax'):
                    ${feet}' ${inches}" +
                % else:
                    ${feet}' ${inches}"
                % endif
            </dd>

            <dt>Weight</dt>
            <dd>
                % if pokemon_form.weight_kg is None:
                    ???.? kg
                % else:
                    ${pokemon_form.weight_kg} kg
                % endif
            </dd>
            <dd>
                % if pokemon_form.weight_kg is None:
                    ???.? lbs
                % else:
                    <%
                        lbs = pokemon_form.weight_kg / (
                            decimal.Decimal('0.45359237'))
                        lbs = lbs.quantize(pokemon_form.weight_kg)
                    %>
                    ${lbs} lbs
                % endif
            </dd>

            <dt>Level-up rate</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Initial friendship</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Effort yield</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Base exp. yield</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Catch rate</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Gender ratio</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Egg groups</dt>
            <dd class="data-pending">[data pending]</dd>

            <dt>Hatch time</dt>
            <dd class="data-pending">[data pending]</dd>
        </dl>
    </div>

    <div id="pokemon-stats">
        <h2>Stats</h2>
        <dl>
            <!-- We use SVGs here b/c Chrome doesn't support paint-order on
            HTML text; see comments in the CSS -->
            % for stat in pokemon_instance.stats:
                <dt>${stat.stat.name}</dt>
                <dd
                    class="pokemon-stat-bar"
                    style="--pokemon-stat: ${stat.base_stat};"
                >
                    <svg
                        width="48" height="24" viewBox="-4 -4 48 24"
                        class="pokemon-stat-number"
                    >
                        <text x="40" y="16" text-anchor="end">
                            ${stat.base_stat}
                        </text>
                    </svg>
                </dd>
            % endfor
        </dl>
    </div>

    <div id="pokemon-matchups">
        <h2>Type matchups</h2>
        ${type_matchups.body(pokemon_instance.types, defending=True)}
    </div>

    % if pokemon_instance.pokemon_abilities:
        <div id="pokemon-abilities">
            <h2>Abilities</h2>
            <dl>
                % for pokemon_ability in pokemon_instance.pokemon_abilities:
                    <dt
                        % if pokemon_ability.slot is AbilitySlot.hidden_ability:
                            class="hidden-ability"
                        % endif
                    >
                        ${h.link(AbilityResource(pokemon_ability.ability, request))}
                    </dt>
                    <dd>
                        % if pokemon_ability.slot is AbilitySlot.hidden_ability:
                            <span class="hidden-ability">(Hidden ability.)</span>
                        % endif
                        Lorem ipsum dolor sit amet, consectetur adipiscing
                        elit, sed do eiusmod tempor incididunt ut labore et
                        dolore magna aliqua.
                    </dd>
                % endfor
            </dl>
        </div>
    % endif
</div>


<h1>Evolution</h1>
<p class="data-pending">[data pending]</p>


<h1>Moves</h1>
<p class="data-pending">[data pending]</p>
