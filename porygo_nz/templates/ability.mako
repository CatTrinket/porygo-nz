<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />
<%namespace name="t" file="helpers/tables.mako" />

<%block name="title">${ability.name} - Abilities - porygo.nz</%block>
<%block name="breadcrumbs">
    <li>${h.link(req.context.__parent__, 'Abilities')}</li>
    <li>${ability.name}</li>
</%block>

<h1>Pokémon</h1>

% if pokemon_regular:
    <h2>Regular ability</h2>
    ${t.pokemon_table(pokemon_regular)}
% endif

% if pokemon_hidden:
    <h2>Hidden ability</h2>
    ${t.pokemon_table(pokemon_hidden)}
% endif

% if pokemon_unique:
    <h2>Unique ability</h2>
    ${t.pokemon_table(pokemon_unique)}
% endif
