WITH customer_orders AS (

    SELECT * FROM {{ ref('int_customer_orders') }}

),

segmented AS (

    SELECT
        -- Customer Identity
        CUSTOMER_ID,
        CUSTOMER_FULL_NAME,
        CUSTOMER_EMAIL,
        CUSTOMER_CITY,
        CUSTOMER_STATE,
        LOYALTY_TIER,
        SIGNUP_DATE,
        DAYS_SINCE_SIGNUP,
        IS_ACTIVE,

        -- Order Behaviour
        TOTAL_ORDERS,
        TOTAL_SPEND,
        AVG_ORDER_VALUE,
        FIRST_ORDER_DATE,
        LAST_ORDER_DATE,
        DAYS_SINCE_LAST_ORDER,

        -- Spend Segment Classification
        CASE
            WHEN TOTAL_SPEND > 50000  THEN 'HIGH'
            WHEN TOTAL_SPEND > 10000  THEN 'MEDIUM'
            ELSE                           'LOW'
        END                                 AS spend_segment,

        -- Customer Value Score (simple composite)
        ROUND(
            (TOTAL_SPEND / NULLIF(DAYS_SINCE_SIGNUP, 0)) * 30
        , 2)                                AS monthly_value_score,
         {{ tier_score('LOYALTY_TIER') }}    AS loyalty_score

    FROM customer_orders

)

SELECT * FROM segmented