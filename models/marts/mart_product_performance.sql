WITH enriched AS (

    SELECT * FROM {{ ref('int_orders_enriched') }}

),

aggregated AS (

    SELECT
        PRODUCT_ID,
        PRODUCT_NAME,
        CATEGORY,
        BRAND,
        PRODUCT_UNIT_PRICE,
        PRODUCT_COST_PRICE,
        PRODUCT_MARGIN_PCT,

        COUNT(DISTINCT ORDER_ID)                AS total_orders,
        SUM(QUANTITY)                           AS total_units_sold,
        SUM(REVENUE_CONTRIBUTION)               AS total_revenue,
        SUM(ITEM_DISCOUNT)                      AS total_discounts_given,
        SUM(REVENUE_CONTRIBUTION)
            - SUM(QUANTITY * PRODUCT_COST_PRICE) AS total_gross_profit,
        AVG(REVENUE_CONTRIBUTION)               AS avg_revenue_per_sale

    FROM enriched
    WHERE ORDER_STATUS != 'CANCELLED'
    GROUP BY
        PRODUCT_ID, PRODUCT_NAME, CATEGORY, BRAND,
        PRODUCT_UNIT_PRICE, PRODUCT_COST_PRICE, PRODUCT_MARGIN_PCT

),

ranked AS (

    SELECT
        *,
        RANK() OVER (
            PARTITION BY CATEGORY
            ORDER BY TOTAL_REVENUE DESC
        )                                       AS revenue_rank_in_category

    FROM aggregated

)

SELECT * FROM ranked