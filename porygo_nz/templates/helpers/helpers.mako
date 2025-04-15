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
<a href="${req.resource_path(resource.__parent__, resource.__name__)}"\
   class="type type-${type.identifier}">${type.name}</a>\
</%def>

<%def name="type_list(types)">\
<ul class="type-list">
    % for type in types:
    <li>${type_link(type)}</li>
    % endfor
</ul>\
</%def>
