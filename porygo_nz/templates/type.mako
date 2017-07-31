<%inherit file="base.mako" />
<%namespace name="t" file="helpers/tables.mako" />
<%block name="title">${type.name} - Types - porygo.nz</%block>

<h1>${type.name}</h1>

type matchups go here

<h1>Pokémon</h1>

${t.pokemon_table(pokemon)}
