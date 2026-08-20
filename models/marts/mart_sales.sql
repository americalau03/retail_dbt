WITH enriched AS (

    SELECT * FROM {{ ref('int_orders_enriched') }}

),

aggregated AS (

    SELECT
        -- Dimensions
        ORDER_YEAR,
        ORDER_MONTH,
        ORDER_MONTH_NAME,
        CATEGORY,
        BRAND,
        PRODUCT_ID,
        PRODUCT_NAME,
        ORDER_CHANNEL,
        SHIPPING_CITY,

        -- Metrics
        COUNT(DISTINCT ORDER_ID)            AS total_orders,
        SUM(QUANTITY)                       AS total_units_sold,
        SUM(REVENUE_CONTRIBUTION)           AS total_revenue,
        SUM(ITEM_DISCOUNT)                  AS total_discounts,
        AVG(REVENUE_CONTRIBUTION)           AS avg_revenue_per_item,
        SUM(QUANTITY * PRODUCT_COST_PRICE)  AS total_cost,
        SUM(REVENUE_CONTRIBUTION)
            - SUM(QUANTITY * PRODUCT_COST_PRICE) AS gross_profit

    FROM enriched
    WHERE ORDER_STATUS != 'CANCELLED'
    GROUP BY
        ORDER_YEAR, ORDER_MONTH, ORDER_MONTH_NAME,
        CATEGORY, BRAND, PRODUCT_ID, PRODUCT_NAME,
        ORDER_CHANNEL, SHIPPING_CITY

)

SELECT * FROM aggregated