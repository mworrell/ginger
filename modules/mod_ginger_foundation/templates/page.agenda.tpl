{% extends "base.tpl" %}

{% block body_class %}t--agenda{% endblock %}

{% block content %}
    {% include "masthead/masthead.tpl" id=id %}

    <main id="main-content" role="main">

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% include "part-of/part-of.tpl" id=id %}

                {% block page_actions %}
                    {% catinclude "page-actions/page-actions.tpl" id %}
                {% endblock %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}
            </article>

        </div>
        <aside class="main-aside">
            {% if id.query %}
                {% with m.search[{ginger_search query_id=id pagelen=6 page=q.page}] as result %}
                    {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
