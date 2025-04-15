<%namespace name="h" file="helpers/helpers.mako" />\
<%
    from porygo_nz.resources import HomeResource
    from porygo_nz.views.ability import AbilityIndexResource
    from porygo_nz.views.move import MoveIndexResource
    from porygo_nz.views.pokemon import PokemonIndexResource
    from porygo_nz.views.type import TypeIndexResource
%>\
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
            <img src="/static/lambda.png" alt="" class="sprite">porygo.nz
        </a>

        <nav id="main-nav">
            <ul>
                <li>${h.link(PokemonIndexResource(request), 'Pokémon')}</li>
                <li>${h.link(MoveIndexResource(request), 'Moves')}</li>

                % if request.show_abilities:
                    <li>${h.link(AbilityIndexResource(request), 'Abilities')}</li>
                % endif

                <li>${h.link(TypeIndexResource(request), 'Types')}</li>
            </ul>
        </nav>
    </header>

    <div id="page">
        <nav id="page-nav">
            <ul id="breadcrumbs">
                % if req.game is not None:
                    <li>${h.link(
                        HomeResource(request=req, game=req.game),
                        text=req.game.identifier
                    )}</li>
                % endif
                <%block name="breadcrumbs">
                    <li>[breadcrumbs undefined]</li>
                </%block>
            </ul>
        </nav>

        <main>
            ${next.body()}
        </main>
    </div>
</body>
</html>
