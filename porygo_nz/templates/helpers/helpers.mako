<%def name="link(thing, text=None)">\
<a href="${req.resource_path(thing.__parent__, thing.__name__)}">\
${text or thing.name}\
</a>\
</%def>
