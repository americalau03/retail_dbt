{{
    config(
        materialized     = 'incremental',
        unique_key       = 'ORDER_ID',
        on_schema_change = 'sync_all_columns'
    )
}}

WITH source AS (

    SELECT * FROM {{ source('retail_raw', 'ORDERS') }}

    {% if is_incremental() %}
        WHERE ORDER_DATE > (SELECT MAX(ORDER_DATE) FROM {{ this }})
    {% endif %}

),

renamed AS (

    SELECT
        -- Primary Key
        ORDER_ID,

        -- Foreign Key
        CUSTOMER_ID,

        -- Order Details
        ORDER_DATE,
        ORDER_STATUS,
        ORDER_CHANNEL,
        SHIPPING_CITY,

        -- Financials
        DISCOUNT_AMOUNT,
        TOTAL_AMOUNT,
        TOTAL_AMOUNT + DISCOUNT_AMOUNT      AS gross_amount,

        -- Derived Date Columns
        DATE(ORDER_DATE)                    AS order_day,
        DATE_TRUNC('month', ORDER_DATE)     AS order_month,
        YEAR(ORDER_DATE)                    AS order_year,
        MONTHNAME(ORDER_DATE)               AS order_month_name,
        DAYNAME(ORDER_DATE)                 AS order_day_name,

        -- Metadata
        _LOADED_AT

    FROM source

)

SELECT * FROM renamed