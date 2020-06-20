<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">Types - porygo.nz</%block>
<%block name="breadcrumbs"><li>Types</li></%block>

<ul>
    % for type in types:
        <li>${h.type_link(type)}</li>
    % endfor
</ul>
