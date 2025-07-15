<%!
    from porydex.db.schema import DamageCategory
    from porygo_nz.views.move import MoveResource
%>

<%inherit file="base.mako" />
<%namespace name="t" file="helpers/tables.mako" />

<%block name="title">Moves - porygo.nz</%block>
<%block name="breadcrumbs"><li>Moves</li></%block>
${t.move_table(moves)}
