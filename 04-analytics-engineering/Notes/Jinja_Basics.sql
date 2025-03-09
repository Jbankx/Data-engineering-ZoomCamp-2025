{% for i in range(10) %}

    select {{ i }} as number {% if not loop.last %} union all {% endif %}
    
{% endfor %}

--Example 2
{% set my_cool_string = 'wow! cool!' %}

{{ my_cool_string }}

--Example 3 (list)
{% set my_hobbies = ['football', 'sql', 'coding', 'food', 'thrillers'] %}

{{ my_hobbies[0] }}

--try iterating of a list
{% for hobby in my_hobbies %}

    My favorite activity is definately {{ hobby }}!
    
{% endfor %}

--combining both
--The (-)
{%- set foods = [ 'kenkey', 'waakye', 'jollof', 'pizza'] -%}

{% for food in foods %}
    {%- if food  == 'pizza' -%}
        {%- set food_type = 'italian food' -%}
    {%- else -%}
        {% set food_type = 'ghanaian food' %}  
    {%- endif -%}

    The classic and humble {{ food }} is my favourite {{ food_type }}!

{% endfor %}

--Example_3 - Dictionaries
{% set juniors_dict = {
    'word' : 'data',
    'speech_part' : 'noun',
    'definition' : 'anytype of information stored. If you know you know'
    }
 -%}
 {{juniors_dict['word']}} ({{juniors_dict['speech_part']}}):  {{juniors_dict['definition']}}