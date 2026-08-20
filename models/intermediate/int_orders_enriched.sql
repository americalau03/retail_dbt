WITH orders AS (

    SELECT * FROM {{ ref('stg_orders') }}

),

order_items AS (

    SELECT * FROM {{ ref('stg_order_items') }}

),

products AS (

    SELECT * FROM {{ ref('stg_products') }}

),

enriched AS (

    SELECT
        -- Order Item Keys
        oi.ORDER_ITEM_ID,
        oi.ORDER_ID,
        oi.PRODUCT_ID,

        -- Order Context
        o.CUSTOMER_ID,
        o.ORDER_DATE,
        o.ORDER_STATUS,
        o.ORDER_CHANNEL,
        o.SHIPPING_CITY,
        o.ORDER_DAY,
        o.ORDER_MONTH,
        o.ORDER_YEAR,
        o.ORDER_MONTH_NAME,

        -- Product Context
        p.PRODUCT_NAME,
        p.CATEGORY,
        p.BRAND,
        p.UNIT_PRICE         AS product_unit_price,
        p.COST_PRICE         AS product_cost_price,
        p.MARGIN_PCT         AS product_margin_pct,

        -- Line Item Financials
        oi.QUANTITY,
        oi.LINE_TOTAL,
        oi.DISCOUNT_AMOUNT   AS item_discount,
        oi.EFFECTIVE_LINE_TOTAL AS revenue_contribution

    FROM order_items    oi
    JOIN orders         o  ON oi.ORDER_ID  = o.ORDER_ID
    JOIN products       p  ON oi.PRODUCT_ID = p.PRODUCT_ID

)

SELECT * FROM enriched