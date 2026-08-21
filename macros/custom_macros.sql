-- Macro 1: Format currency in Indian Rupees
-- Usage: {{ format_inr(column_name) }}
{% macro format_inr(amount) %}
    CONCAT('₹', TO_CHAR(ROUND({{ amount }}, 2), '999,999,999.00'))
{% endmacro %}


-- Macro 2: Classify loyalty tier into numeric score
-- Usage: {{ tier_score('LOYALTY_TIER') }}
{% macro tier_score(tier_column) %}
    CASE {{ tier_column }}
        WHEN 'Platinum' THEN 4
        WHEN 'Gold'     THEN 3
        WHEN 'Silver'   THEN 2
        WHEN 'Bronze'   THEN 1
        ELSE 0
    END
{% endmacro %}


-- Macro 3: Safe division (prevents divide by zero)
-- Usage: {{ safe_divide('numerator', 'denominator') }}
{% macro safe_divide(numerator, denominator) %}
    CASE
        WHEN {{ denominator }} = 0 THEN NULL
        ELSE {{ numerator }} / {{ denominator }}
    END
{% endmacro %}
