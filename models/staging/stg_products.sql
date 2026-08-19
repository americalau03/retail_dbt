WITH source AS (

    SELECT * FROM {{ source('retail_raw', 'PRODUCTS') }}

),

renamed AS (

    SELECT
        -- Primary Key
        PRODUCT_ID,

        -- Product Details
        PRODUCT_NAME,
        CATEGORY,
        SUBCATEGORY                                     AS brand,

        -- Pricing
        UNIT_PRICE,
        COST_PRICE,

        -- Derived Financial Metrics
        UNIT_PRICE - COST_PRICE                         AS profit_per_unit,
        ROUND(
            (UNIT_PRICE - COST_PRICE)
            / NULLIF(UNIT_PRICE, 0) * 100
        , 2)                                            AS margin_pct,

        -- Status
        IS_ACTIVE,

        -- Metadata
        _LOADED_AT

    FROM source

)

SELECT * FROM renamed