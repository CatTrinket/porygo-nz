<%!
    import porydex.db
    from porygo_nz.views.type import TypeResource
%>

<%def name="link(thing, text=None)">\
<a href="${req.resource_path(thing.__parent__, thing.__name__)}">\
${text or thing.item.name}\
</a>\
</%def>

<%def name="type_link(type)">\
<% resource = TypeResource(type, req) %>\
% if type is not None:
<a href="${req.resource_path(resource.__parent__, resource.__name__)}"\
   class="type type-${type.identifier}">${type.name}</a>\
% else:
## Placeholder — currently used for missing data but eventually for shadow
## moves
<a class="type type-question">—</a>\
% endif
</%def>

<%def name="type_list(types)">\
<ul class="type-list">
    % for type in types:
    <li>${type_link(type)}</li>
    % endfor
</ul>\
</%def>

<%def name="damage_category_icon(damage_category)">\
% if damage_category is not None:
<span class="damage-category damage-category-${damage_category}">\
${str(damage_category).capitalize()}\
</span>\
% else:
<span class="damage-category damage-category-inherit">*</span>\
% endif
</%def>
