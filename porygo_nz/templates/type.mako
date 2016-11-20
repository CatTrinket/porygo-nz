<%inherit file="base.mako" />
<%block name="title">${type.identifier.capitalize()} - Types - porygo.nz</%block>

% if request.root.generation_index is not None:
    IT'S ${type.identifier.upper()} IN GEN
    ${request.root.generation_index.generation.id}!!!!
% else:
    IT'S ${type.identifier.upper()}!!!!
% endif
