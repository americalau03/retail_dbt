{% snapshot customers_snapshot %}

{{
    config(
        target_schema = 'snapshots',
        unique_key    = 'CUSTOMER_ID',
        strategy      = 'check',
        check_cols    = ['LOYALTY_TIER']
    )
}}

SELECT * FROM {{ source('retail_raw', 'CUSTOMERS') }}

{% endsnapshot %}