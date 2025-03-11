--Example: Use case of when you want to limit the data run when query sql models in "development environment"
--You can set default i.e. (last 3 days of data )

{% macro limit_data_in_dev(column_dt, dev_days_of_data)}

    {% if target.name == 'dev' %}
        where {{ column_name_dt }} >= dateadd('day', - {{ dev_days_of_data }}, current_timestamp)    
    {% endif %}


{% endmacro %}

--Calling the data (example)
{{ limit_data_in_dev(order_date, 7) }}


--You can try it on the below example as well
/*
{% macro limit_data_in_dev(column_dt, dev_days_of_data)}

    {% if source == 'staging' %}
        where {{ column_name_dt }} >= dateadd('day', - {{ dev_days_of_data }}, current_timestamp)    
    {% endif %}


{% endmacro %}

*/