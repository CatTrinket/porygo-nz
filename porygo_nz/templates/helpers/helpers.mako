<%def name="link(thing, text=None)">\
<a href="${req.resource_path(thing.__parent__, thing.__name__)}">\
${text or thing.name}\
</a>\
</%def>

<%def name="pokemon_form_link(form)">\
<a>\
${form.pokemon.name}\
% if form.name:
 <span class="pokemon-form-name">${form.name}</span>\
% endif
</a>\
</%def>
