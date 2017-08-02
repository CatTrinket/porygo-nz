<% import collections %>

<%def name="link(thing, text=None)">\
<a href="${req.resource_path(thing.__parent__, thing.__name__)}">\
${text or thing.name}\
</a>\
</%def>

<%def name="type_link(type)">\
<a href="${req.resource_path(type.__parent__, type.__name__)}"\
   class="type type-${type.identifier}">${type.name}</a>\
</%def>

<%def name="type_list(types)">\
<ul class="type-list">
    % for type in types:
    <li>${type_link(type)}</li>
    % endfor
</ul>\
</%def>
