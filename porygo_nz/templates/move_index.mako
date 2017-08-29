<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">Moves - porygo.nz</%block>

<ul>
    % for move in moves:
        <li>${h.link(move)}</li>
    % endfor
</ul>
