<%namespace name="h" file="helpers.mako" />

<%def name="pokemon_table(pokemon_forms)">
<table>
<thead>
    <tr>
        <th colspan="2">Pokémon</th>
        <th>Type</th>
        <th>Abilities</th>
        <th class="stat-cell">HP</th>
        <th class="stat-cell">Atk</th>
        <th class="stat-cell">Def</th>
        <th class="stat-cell">SpA</th>
        <th class="stat-cell">SpD</th>
        <th class="stat-cell">Spe</th>
    </tr>
</thead>
<tbody>
    % for pokemon_form in pokemon_forms:
    <tr>
        <td class="pokemon-icon-cell">
            <img src="/static/pokemon-icons/${pokemon_form.identifier}.png"
                 class="pokemon-icon">
        </td>

        <td class="pokemon-cell">${h.pokemon_form_link(pokemon_form)}</td>

        <td class="type-cell">
            ${'/'.join(type.name for type in pokemon_form.types)}
        </td>

        <td class="ability-cell">
            <ul class="ability-list">
                <li><a>Ability 1</a></li>
                % if pokemon_form.pokemon_id % 2 == 0:
                    <li><a>A Second Ability</a></li>
                % endif
                % if pokemon_form.pokemon_id % 3 == 0:
                    <li class="hidden-ability"><a>Hidden Ability</a></li>
                % endif
            </ul>
        </td>

        % for n in range(6):
            <td class="stat-cell">123</td>
        % endfor
    </tr>
    % endfor
</tbody>
</table>
</%def>
