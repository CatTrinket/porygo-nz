<%namespace name="h" file="helpers.mako" />
<%!
    import itertools

    from porydex.db import AbilitySlot, DamageCategory
    from porygo_nz.views.ability import AbilityResource
    from porygo_nz.views.move import MoveResource
    from porygo_nz.views.pokemon import PokemonResource
%>

<%def name="pokemon_table(pokemon_instances)">
<%
    pokemon = itertools.groupby(pokemon_instances, lambda p: p.pokemon_form.pokemon)
    pokemon = [(key, list(group)) for (key, group) in pokemon]
%>

<table class="pokemon-table">
<thead>
    <tr>
        <th class="pokemon-icon-cell"></th>
        <th class="pokemon-cell">Pokémon</th>
        <th class="type-list-cell">Type</th>

        % if req.show_abilities:
            <th class="ability-list-cell">Abilities</th>
        % endif
        % if req.show_hidden_abilities:
            <th class="ability-list-cell">Hidden ability</th>
        % endif

        <th class="stat-cell"><abbr title="Hit Points">HP</abbr></th>
        <th class="stat-cell"><abbr title="Attack">Atk</abbr></th>
        <th class="stat-cell"><abbr title="Defense">Def</abbr></th>
        % if req.game is None or req.game.generation_id >= 2:
            <th class="stat-cell"><abbr title="Special Attack">SpA</abbr></th>
            <th class="stat-cell"><abbr title="Special Defense">SpD</abbr></th>
        % endif
        <th class="stat-cell"><abbr title="Speed">Spe</abbr></th>
        % if req.game is not None and req.game.generation_id == 1:
            <th class="stat-cell"><abbr title="Special">Spc</abbr></th>
        % endif
    </tr>
</thead>

% for (a_pokemon, pokemon_instances) in pokemon:
    <tbody>
        % for pokemon_instance in pokemon_instances:
            ${pokemon_row(pokemon_instance)}
        % endfor
    </tbody>
% endfor
</table>
</%def>

<%def name="pokemon_row(pokemon)">
<% form = pokemon.pokemon_form %>
<tr>
    <td class="pokemon-icon-cell">
        <img
            src="/static/pokemon-icons/${form.identifier}.png"
            srcset="/static/pokemon-icons/80px/${form.identifier}.png 2x"
            class="pokemon-icon" alt=""
        >
    </td>

    <td class="pokemon-cell">
        <% resource = PokemonResource(form, request) %>
        <a href="${req.resource_path(resource.__parent__, resource.__name__)}">
            ${form.pokemon.name}
            % if form.name:
                <span class="pokemon-form-name expanded-only">
                    ${form.name}
                </span>
            % endif
        </a>
    </td>

    <td class="type-list-cell">${h.type_list(pokemon.types)}</td>

    % if req.show_abilities:
        ${ability_cell(pokemon, hidden=False)}
    % endif
    % if req.show_hidden_abilities:
        ${ability_cell(pokemon, hidden=True)}
    % endif

    % for stat in pokemon.stats:
        <td class="stat-cell stat-cell-${stat.stat.identifier}">
            ${stat.base_stat}
        </td>
    % endfor
</tr>
</%def>

<%def name="ability_cell(pokemon, hidden)">
    <%
        hidden_slots = (
            AbilitySlot.hidden_ability,
            AbilitySlot.unique_ability
        )
        class_ = 'ability-list-hidden' if hidden else 'ability-list-regular'
    %>
    <td class="ability-list-cell ${class_}">
        <ul>
            % for pokemon_ability in pokemon.pokemon_abilities:
                % if (pokemon_ability.slot in hidden_slots) == hidden:
                    <li
                        % if pokemon_ability.slot is AbilitySlot.hidden_ability:
                            class="hidden-ability"
                        % elif pokemon_ability.slot is AbilitySlot.unique_ability:
                            class="unique-ability"
                        % endif
                    >
                        ${h.link(
                            AbilityResource(pokemon_ability.ability, request))}
                    </li>
                % endif
            % endfor
       </ul>
    </td>
</%def>

<%def name="move_table(move_instances)">
<table class="description-table">
    <thead>
        <tr>
            <th class="move-cell">Move</th>
            <th class="type-cell">Type</th>
            <th class="type-cell">Category</th>
            <th class="power-cell"><abbr title="Power">Pow.</abbr></th>
            <th class="accuracy-cell"><abbr title="Accuracy">Acc.</abbr></th>
            <th class="pp-cell">PP</th>
            <th class="description-cell">Summary</th>
        </tr>
    </thead>
    % for move_instance in move_instances:
        <tr>
            <td class="move-cell">
                ${h.link(MoveResource(move_instance.move, request))}
            </td>

            <td class="type-cell">${h.type_link(move_instance.type)}</td>

            <td class="type-cell">
                ${h.damage_category_icon(move_instance.category)}
            </td>

            % if move_instance.power is not None:
                <td class="power-cell">${move_instance.power}</td>
            % elif move_instance.category is DamageCategory.status:
                <td class="power-cell non-numeric">—</td>
            % else:
                <td class="power-cell non-numeric">*</td>
            % endif

            % if move_instance.accuracy is not None:
                <td class="accuracy-cell">${move_instance.accuracy}%</td>
            % else:
                <td class="accuracy-cell non-numeric">—</td>
            % endif

            % if move_instance.pp is not None:
                <td class="pp-cell">${move_instance.pp}</td>
            % else:
                <td class="pp-cell non-numeric">—</td>
            % endif

            <td class="description-cell">
                <% priority = move_instance.priority or 0 %>
                % if priority > 0:
                    <span class="priority-positive">+${priority} priority.</span>
                % elif priority < 0:
                    <span class="priority-negative">−${-priority} priority.</span>
                % endif
                <span class="data-pending">[move descriptions pending]</span>
            </td>
        </tr>
    % endfor
</table>
</%def>
