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
        <nav id="main-nav">
            <a href="/" id="site-title">
                <img src="/static/lambda.png">porygo.nz
            </a>

            <ul>
                <li><a href="/">Pokémon</a></li>
                <li><a href="/">Moves</a></li>
                <li><a href="/">Abilities</a></li>
                <li>${h.link(req.root['types'], 'Types')}</li>
                <li><a href="/">Whatever</a></li>
            </ul>
        </nav>

        <nav id="subnav">
            <ul id="breadcrumbs">
                <li><a href="/">Fake Breadcrumb</a></li>
                <li><a href="/">Another</a></li>
                <li><a href="/">Main Thing</a></li>
            </ul>
        </nav>
    </header>

    <main>
        ${next.body()}
    </main>
</body>
</html>
