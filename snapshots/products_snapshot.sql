{% snapshot products_snapshot %}

{{
    config(
        target_schema  = 'snapshots',
        unique_key     = 'PRODUCT_ID',
        strategy       = 'timestamp',
        updated_at     = '_LOADED_AT'
    )
}}

SELECT * FROM {{ source('retail_raw', 'PRODUCTS') }}

{% endsnapshot %}