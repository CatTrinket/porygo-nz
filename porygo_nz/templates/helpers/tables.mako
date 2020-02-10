<%namespace name="h" file="helpers.mako" />
<%!
    import itertools

    import porydex.db


    tall_pokemon = (
        'charizard-gigantamax',
        'meowth-gigantamax',
        'melmetal-gigantamax',
        'sandaconda-gigantamax',
        'alcremie-gigantamax',
        'duraludon-gigantamax',
        'eternatus-eternamax'
    )
%>

<%def name="pokemon_table(pokemon_forms)">
<%
    pokemon = itertools.groupby(pokemon_forms, lambda form: form.pokemon)
    pokemon = [(key, list(group)) for (key, group) in pokemon]
%>

<table class="pokemon-table">
<thead>
    <tr>
        <th class="pokemon-icon-cell"></th>
        <th class="pokemon-cell">Pokémon</th>
        <th class="type-list-cell">Type</th>
        % if req.generation is None or req.generation.id >= 3:
            <th class="ability-list-cell">Abilities</th>
        % endif
        <th class="stat-cell">HP</th>
        <th class="stat-cell">Atk</th>
        <th class="stat-cell">Def</th>
        <th class="stat-cell">SpA</th>
        <th class="stat-cell">SpD</th>
        <th class="stat-cell">Spe</th>
    </tr>
</thead>

% for (a_pokemon, pokemon_forms) in pokemon:
    <tbody>
        % for pokemon_form in pokemon_forms:
            ${pokemon_form_row(pokemon_form)}
        % endfor
    </tbody>
% endfor
</table>
</%def>

<%def name="pokemon_form_row(form)">
<tr>
    <td class="pokemon-icon-cell">
        <%
            icon_class = (
                'pokemon-icon tall'
                if form.identifier in tall_pokemon
                else 'pokemon-icon'
            )
        %>\
        <img src="/static/pokemon-icons/${form.identifier}.png"
             class="${icon_class}" alt="">
    </td>

    <td class="pokemon-cell">
        <a href="${req.resource_path(form.__parent__, form.__name__)}">
            ${form.pokemon.name}
            % if form.name:
                <span class="pokemon-form-name expanded-only">
                    ${form.name}
                </span>
            % endif
        </a>
    </td>

    <td class="type-list-cell">${h.type_list(form.types)}</td>

    % if req.generation is None or req.generation.id >= 3:
        <td class="ability-list-cell">
            <ul class="ability-list">
                % for pokemon_ability in form.pokemon_abilities:
                    <li
                        % if pokemon_ability.slot is porydex.db.AbilitySlot.hidden_ability:
                            class="hidden-ability"
                        % endif
                    >
                        ${h.link(pokemon_ability.ability)}
                    </li>
                % endfor
            </ul>
        </td>
    % endif

    % for n in range(6):
        <td class="stat-cell">123</td>
    % endfor
</tr>
</%def>
