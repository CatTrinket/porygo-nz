<%namespace name="h" file="helpers.mako" />

<%def name="pokemon_table(pokemon_forms)">
<%
    import itertools
    pokemon = itertools.groupby(pokemon_forms, lambda form: form.pokemon)
    pokemon = [(key, list(group)) for (key, group) in pokemon]
%>

% for (a_pokemon, forms) in pokemon:
    % if len(forms) > 1:
        <input
            type="checkbox" id="pokemon-collapse-${a_pokemon.identifier}"
            class="pokemon-collapse pokemon-collapse-${a_pokemon.identifier}"
            % if len(forms) > 6:
                checked
            % endif
        >
    % endif
% endfor

<table class="pokemon-table">
<thead>
    <tr>
        <th class="pokemon-collapse-cell"></th>
        <th class="pokemon-icon-cell"></th>
        <th class="pokemon-cell">Pokémon</th>
        <th class="type-list-cell">Type</th>
        <th class="ability-list-cell">Abilities</th>
        <th class="stat-cell">HP</th>
        <th class="stat-cell">Atk</th>
        <th class="stat-cell">Def</th>
        <th class="stat-cell">SpA</th>
        <th class="stat-cell">SpD</th>
        <th class="stat-cell">Spe</th>
    </tr>
</thead>

% for (a_pokemon, pokemon_forms) in pokemon:
    <tbody class="pokemon-${a_pokemon.identifier}">
        % for pokemon_form in pokemon_forms:
            ${pokemon_form_row(pokemon_form, len(pokemon_forms) > 1)}
        % endfor
    </tbody>
% endfor
</table>
</%def>

<%def name="pokemon_form_row(form, is_multiform)">
<tr class="${'expanded-only' if not form.is_default else ''}">
    <td class="pokemon-collapse-cell">
        % if is_multiform:
            % if form.form_id == 1:
                <label for="pokemon-collapse-${form.pokemon.identifier}"
                       class="pokemon-collapse-label expanded-only">
                </label>
            % endif

            % if form.is_default:
                <label for="pokemon-collapse-${form.pokemon.identifier}"
                       class="pokemon-expand-label collapsed-only">
                </label>
            % endif
        % endif
    </td>

    <td class="pokemon-icon-cell">
        <img src="/static/pokemon-icons/${form.identifier}.png"
             class="pokemon-icon" alt="">
    </td>

    <td class="pokemon-cell">
        <a>
            ${form.pokemon.name}
            % if form.name:
                <span class="pokemon-form-name expanded-only">
                    ${form.name}
                </span>
            % endif
        </a>
    </td>

    <td class="type-list-cell">${h.type_list(form.types)}</td>

    <td class="ability-list-cell">
        <ul class="ability-list">
            <li><a>Ability 1</a></li>
            % if form.pokemon_id % 2 == 0:
                <li><a>A Second Ability</a></li>
            % endif
            % if form.pokemon_id % 3 == 0:
                <li class="hidden-ability"><a>Hidden Ability</a></li>
            % endif
        </ul>
    </td>

    % for n in range(6):
        <td class="stat-cell">123</td>
    % endfor
</tr>
</%def>
