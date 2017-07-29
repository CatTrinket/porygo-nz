<%inherit file="base.mako" />
<%block name="title">${type.name} - Types - porygo.nz</%block>

% if request.root.generation_index is not None:
    IT'S ${type.name.upper()} IN GEN
    ${request.root.generation_index.generation.id}!!!!
% else:
    IT'S ${type.name.upper()}!!!!
% endif
