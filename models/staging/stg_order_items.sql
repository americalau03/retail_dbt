{{
    config(
        materialized     = 'incremental',
        unique_key       = 'ORDER_ITEM_ID',
        on_schema_change = 'sync_all_columns'
    )
}}

WITH source AS (

    SELECT * FROM {{ source('retail_raw', 'ORDER_ITEMS') }}

    {% if is_incremental() %}
        WHERE _LOADED_AT > (SELECT MAX(_LOADED_AT) FROM {{ this }})
    {% endif %}

),

renamed AS (

    SELECT
        -- Primary Key
        ORDER_ITEM_ID,

        -- Foreign Keys
        ORDER_ID,
        PRODUCT_ID,

        -- Line Item Details
        QUANTITY,
        UNIT_PRICE,
        LINE_TOTAL,
        DISCOUNT_AMOUNT,
        LINE_TOTAL - DISCOUNT_AMOUNT        AS effective_line_total,

        -- Metadata
        _LOADED_AT

    FROM source

)

SELECT * FROM renamed