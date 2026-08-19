WITH source AS (

    SELECT * FROM {{ source('retail_raw', 'CUSTOMERS') }}

),

renamed AS (

    SELECT
        -- Primary Key
        CUSTOMER_ID,

        -- Customer Name
        FIRST_NAME                              AS customer_first_name,
        LAST_NAME                               AS customer_last_name,
        FIRST_NAME || ' ' || LAST_NAME          AS customer_full_name,

        -- Contact Details
        EMAIL                                   AS customer_email,
        PHONE                                   AS customer_phone,

        -- Location
        CITY                                    AS customer_city,
        STATE                                   AS customer_state,

        -- Loyalty
        LOYALTY_TIER,

        -- Status and Dates
        IS_ACTIVE,
        SIGNUP_DATE,
        DATEDIFF('day', SIGNUP_DATE,
                 CURRENT_DATE())                AS days_since_signup,

        -- Metadata
        _LOADED_AT

    FROM source

)

SELECT * FROM renamed