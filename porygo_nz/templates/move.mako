<%! from porydex.db import DamageCategory %>
<%inherit file="base.mako" />
<%namespace name="h" file="helpers/helpers.mako" />
<%namespace name="type_matchups" file="helpers/type_matchups.mako" />

<%block name="title">${move.name} - Moves - porygo.nz</%block>
<%block name="breadcrumbs">
    <li>${h.link(request.context.__parent__, 'Moves')}</li>
    <li>${move.name}</li>
</%block>

<div id="move-basics">
    <dl id="move-stats">
        <dt>Type</dt>
        <dd class="type-list">${h.type_link(move_instance.type)}</dd>

        <dt>Category</dt>
        <dd class="type-list">
            ${h.damage_category_icon(move_instance.category)}
        </dd>

        <dt>Power</dt>
        % if move_instance.power is not None:
            <dd>${move_instance.power}</dd>
        % elif move_instance.category is DamageCategory.status:
            <dd class="not-applicable">n/a</dd>
        % else:
            <dd class="not-applicable">Varies/other</dd>
        % endif

        <dt>Accuracy</dt>
        % if move_instance.accuracy is not None:
            <dd>${move_instance.accuracy}%</dd>
        % else:
            ## TODO: Distinguish "n/a" vs. "always hits"
            <dd class="not-applicable">n/a</dd>
        % endif

        <dt>PP</dt>
        % if move_instance.pp is None:
            <dd class="not-applicable">n/a</dd>
        % elif move_instance.pp == 1:
            <dd>1</dd>
        % else:
            <%
                max_pp = move_instance.pp * 8 // 5
                if req.game is not None and req.game.generation_id <= 2:
                    max_pp = min(61, max_pp)
            %>
            <dd>
                <dl>
                    <dt>Base</dt>
                    <dd>${move_instance.pp}</dd>

                    <dt>Max.</dt>
                    <dd>${max_pp}</dd>
                </dl>
            </dd>
        % endif

        % if move_instance.priority is not None:
            <dt>Priority</dt>
            <dd>
            % if move_instance.priority > 0:
                <span class="priority-positive">
                    +${move_instance.priority}
                </span>
                (fast)
            % elif move_instance.priority < 0:
                <span class="priority-negative">
                    –${-move_instance.priority}
                </span>
                (slow)
            % else:
                0 (normal)
            % endif
        % endif

        <dt>Target</dt>
        <dd class="data-pending">[data pending]</dd>
    </dl>

    <div id="move-summary">
        <h2>Summary</h2>
        <p class="data-pending">[data pending]</p>
    </div>

    % if move_instance.category != DamageCategory.status:
        <div id="move-matchups">
            <h2>Type matchups</h2>
            ${type_matchups.body([move_instance.type])}
        </div>
    % endif
</div>


<h1>Pokémon</h1>
<p class="data-pending">[data pending]</p>
