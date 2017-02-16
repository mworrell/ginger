{% if result %}
    <h4 class="search-suggestions__suggestions__title">{_ Results found _}</h4>
    <ul class="search-suggestions__suggestions__list">
        {% for result in result|slice:6 %}
            {% with result._source as record %}
                <li>
                    <a href="{% url adlib_object object_id=record.priref %}">
                        {% if record.reproduction|first as reproduction %}
                            <div class="search-suggestions__suggestions__img" style="background-image: url({{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=100&height=100)"></div>
                        {% endif %}
                        <p class="search-suggestions__suggestions__list__title">{{ record.title }} </p>
                    </a>
                </li>
            {% endwith %}
        {% endfor %}
    </ul>
{% else %}
    <h4 class="search-suggestions__suggestions__title no-results">{_ Nothing found _}</h4>
{% endif %}

<div class="search-suggestions__suggestions__enter">{_ Press enter to search _}</div>