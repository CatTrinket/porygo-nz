<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />
<%namespace name="t" file="helpers/tables.mako" />
<%namespace name="type_matchups" file="helpers/type_matchups.mako" />

<%block name="title">${type.name} - Types - porygo.nz</%block>
<%block name="breadcrumbs">
    <li>${h.link(req.context.__parent__, 'Types')}</li>
    <li>${type.name}</li>
</%block>

<div id="type-basics">
    <div>
        <h2>Attacking</h2>
        ${type_matchups.body([type], defending=False)}
    </div>

    <div>
        <h2>Defending</h2>
        ${type_matchups.body([type], defending=True)}
    </div>
</div>


<h1>Pokémon</h1>

${t.pokemon_table(pokemon)}


<h1>Moves</h1>
<p class="data-pending">[data pending]</p>
