<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">${move.name} - Moves - porygo.nz</%block>
<%block name="breadcrumbs">
    <li>${h.link(request.context.__parent__, 'Moves')}</li>
    <li>${move.name}</li>
</%block>
