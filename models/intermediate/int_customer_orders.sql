WITH customers AS (

    SELECT * FROM {{ ref('stg_customers') }}

),

orders AS (

    SELECT * FROM {{ ref('stg_orders') }}

),

order_summary AS (

    SELECT
        CUSTOMER_ID,
        COUNT(DISTINCT ORDER_ID)            AS total_orders,
        SUM(TOTAL_AMOUNT)                   AS total_spend,
        AVG(TOTAL_AMOUNT)                   AS avg_order_value,
        MIN(ORDER_DATE)                     AS first_order_date,
        MAX(ORDER_DATE)                     AS last_order_date,
        DATEDIFF('day',
            MAX(ORDER_DATE),
            CURRENT_DATE())                 AS days_since_last_order

    FROM orders
    WHERE ORDER_STATUS != 'CANCELLED'
    GROUP BY CUSTOMER_ID

),

joined AS (

    SELECT
        -- Customer Profile
        c.CUSTOMER_ID,
        c.CUSTOMER_FULL_NAME,
        c.CUSTOMER_EMAIL,
        c.CUSTOMER_CITY,
        c.CUSTOMER_STATE,
        c.LOYALTY_TIER,
        c.SIGNUP_DATE,
        c.DAYS_SINCE_SIGNUP,
        c.IS_ACTIVE,

        -- Order Behaviour
        COALESCE(os.TOTAL_ORDERS, 0)        AS total_orders,
        COALESCE(os.TOTAL_SPEND, 0)         AS total_spend,
        COALESCE(os.AVG_ORDER_VALUE, 0)     AS avg_order_value,
        os.FIRST_ORDER_DATE,
        os.LAST_ORDER_DATE,
        os.DAYS_SINCE_LAST_ORDER

    FROM customers      c
    LEFT JOIN order_summary os ON c.CUSTOMER_ID = os.CUSTOMER_ID

)

SELECT * FROM joined