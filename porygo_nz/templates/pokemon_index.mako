<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />
<%namespace name="t" file="helpers/tables.mako" />

<%block name="title">Pokémon - porygo.nz</%block>

${t.pokemon_table(pokemon)}
