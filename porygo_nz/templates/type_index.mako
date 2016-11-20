<%inherit file="base.mako" />

<%block name="title">Types - porygo.nz</%block>

<ul>
    % for type in types:
        <li>
            <a href="${request.resource_path(type)}">${type.identifier}</a>
        </li>
    % endfor
</ul>
