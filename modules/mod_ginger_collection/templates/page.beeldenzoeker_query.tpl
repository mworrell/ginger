{% extends "collection/base.tpl" %}

{% block body_class %}t--adlib-query{% endblock %}

{% block content %}

    {% include "masthead/masthead.tpl" %}

    <main>
        <div class="adlib-object__actions">
            <div class="main-container">
                {% include "collection/share.tpl" %}
            </div>
        </div>
        <article class="main-content">
            {% include "page-title/page-title.tpl" %}

            {% include "subtitle/subtitle.tpl" %}

            {% include "summary/summary.tpl" %}

            {% include "body/body.tpl" %}

        </article>

        {% block search_query %}
            {% include "collection/search-query-wrapper.tpl" class="list" id_exclude=id query_id=id pagelen=15 infinite_scroll %}
        {% endblock %}
    </main>

{% endblock %}

