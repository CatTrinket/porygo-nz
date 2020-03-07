<%namespace name="h" file="helpers/helpers.mako" />\
<% import porygo_nz.resources as res %>\
<!DOCTYPE html>

<html>
<head>
    <title><%block name="title">porygo.nz</%block></title>
    <link rel="stylesheet" href="/static/porygo-nz.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
    <header>
        <a href="/" id="site-title">
            <img src="/static/lambda.png" alt="">porygo.nz
        </a>

        <nav id="main-nav">
            <ul>
                <% root = req.root.generation_index or req.root %>
                <li>${h.link(root['pokemon'], 'Pokémon')}</li>
                <li>${h.link(root['moves'], 'Moves')}</li>

                % try:
                    <% abilities = root['abilities'] %>
                    <li>${h.link(abilities, 'Abilities')}</li>
                % except KeyError:
                % endtry

                <li>${h.link(root['types'], 'Types')}</li>
            </ul>
        </nav>
    </header>

    <div id="page">
        <nav id="page-nav">
            <ul id="breadcrumbs">
                <li><a href="/">Fake Breadcrumb</a></li>
                <li><a href="/">Another</a></li>
                <li><a href="/">Main Thing</a></li>
            </ul>
        </nav>

        <main>
            ${next.body()}
        </main>
    </div>
</body>
</html>
