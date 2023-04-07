{% macro get_grain_order() %}
    {{ return(adapter.dispatch('get_grain_order', 'metrics')()) }}
{% endmacro %}

{% macro default__get_grain_order() %}
    {% do return (['fifteen_minute', 'hour', 'day', 'week', 'month', 'quarter', 'year']) %}
{% endmacro %}