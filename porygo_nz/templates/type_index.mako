<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">Types - porygo.nz</%block>

<ul>
    % for type in types:
        <li>${h.link(type, type.name)}</li>
    % endfor
</ul>
