<%! from porygo_nz.views.move import MoveResource %>

<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">Moves - porygo.nz</%block>
<%block name="breadcrumbs"><li>Moves</li></%block>

<ul>
    % for move in moves:
        <li>${h.link(MoveResource(move, request))}</li>
    % endfor
</ul>
