<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />

<%block name="title">Abilities - porygo.nz</%block>
<%block name="breadcrumbs"><li>Abilities</li></%block>

<ul>
    % for ability in abilities:
        <li>${h.link(ability)}</li>
    % endfor
</ul>
