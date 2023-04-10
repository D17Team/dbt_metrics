{% macro gen_calendar_join(group_values, grain) %}
    {{ return(adapter.dispatch('gen_calendar_join', 'metrics')(group_values, grain)) }}
{%- endmacro -%}

{% macro default__gen_calendar_join(group_values, grain) %}
        left join calendar
        {%- if group_values.window is not none and grain not in ['hour', 'quarter_hour'] %}
            on cast(base_model.{{group_values.timestamp}} as date) > dateadd({{group_values.window.period}}, -{{group_values.window.count}}, calendar.date_day)
            and cast(base_model.{{group_values.timestamp}} as date) <= calendar.date_day
        {%- elif grain == 'quarter_hour' %}
            on dateadd(minute, floor(datediff(minute, date_trunc('hour', {{group_values.timestamp}}), {{group_values.timestamp}}) / 15.0, 0) * 15, date_trunc('hour', {{group_values.timestamp}})) = calendar.date_quarter_hour
        {%- elif grain == 'hour' %}
            on date_trunc('hour', {{group_values.timestamp}}) = calendar.date_hour
        {%- else %}
            on cast(base_model.{{group_values.timestamp}} as date) = calendar.date_day
        {% endif -%}
        
{% endmacro %}

{% macro bigquery__gen_calendar_join(group_values, grain) %}
        left join calendar
        {%- if group_values.window is not none and grain not in ['hour', 'quarter_hour'] %}
            on cast(base_model.{{group_values.timestamp}} as date) > date_sub(calendar.date_day, interval {{group_values.window.count}} {{group_values.window.period}})
            and cast(base_model.{{group_values.timestamp}} as date) <= calendar.date_day
        {%- elif grain == 'quarter_hour' -%}
            on dateadd(minute, floor(datediff(minute, date_trunc('hour', {{group_values.timestamp}}), {{group_values.timestamp}}) / 15.0, 0) * 15, date_trunc('hour', {{group_values.timestamp}})) = calendar.date_quarter_hour
        {%- elif grain == 'hour' -%}
            on date_trunc('hour', {{group_values.timestamp}}) = calendar.date_hour
        {%- else %}
            on cast(base_model.{{group_values.timestamp}} as date) = calendar.date_day
        {% endif -%}
{% endmacro %}

{% macro postgres__gen_calendar_join(group_values, grain) %}
        left join calendar
        {%- if group_values.window is not none and grain not in ['hour', 'quarter_hour'] %}
            on cast(base_model.{{group_values.timestamp}} as date) > calendar.date_day - interval '{{group_values.window.count}} {{group_values.window.period}}'
            and cast(base_model.{{group_values.timestamp}} as date) <= calendar.date_day
        {%- elif grain == 'quarter_hour' -%}
            on dateadd(minute, floor(datediff(minute, date_trunc('hour', {{group_values.timestamp}}), {{group_values.timestamp}}) / 15.0, 0) * 15, date_trunc('hour', {{group_values.timestamp}})) = calendar.date_quarter_hour
        {%- elif grain == 'hour' -%}
            on date_trunc('hour', {{group_values.timestamp}}) = calendar.date_hour
        {%- else %}
            on cast(base_model.{{group_values.timestamp}} as date) = calendar.date_day
        {% endif -%}
{% endmacro %}

{% macro redshift__gen_calendar_join(group_values, grain) %}
        left join calendar
        {%- if group_values.window is not none and grain not in ['hour', 'quarter_hour'] %}
            on cast(base_model.{{group_values.timestamp}} as date) > dateadd({{group_values.window.period}}, -{{group_values.window.count}}, calendar.date_day)
            and cast(base_model.{{group_values.timestamp}} as date) <= calendar.date_day
        {%- elif grain == 'quarter_hour' -%}
            on dateadd(minute, floor(datediff(minute, date_trunc('hour', {{group_values.timestamp}}), {{group_values.timestamp}}) / 15.0, 0) * 15, date_trunc('hour', {{group_values.timestamp}})) = calendar.date_quarter_hour
        {%- elif grain == 'hour' -%}
            on date_trunc('hour', {{group_values.timestamp}}) = calendar.date_hour
        {%- else %}
            on cast(base_model.{{group_values.timestamp}} as date) = calendar.date_day
        {% endif -%}
{% endmacro %}
