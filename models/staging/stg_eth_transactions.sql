with source as (
    select
        `hash`                                                          as transaction_id,
        from_address,
        to_address,
        value / 1e18                                                    as value_eth,
        gas,
        gas_price / 1e9                                                 as gas_price_gwei,
        receipt_gas_used,
        (cast(gas_price as numeric) * cast(receipt_gas_used as numeric)) / 1e18  as transaction_fee_eth,
        block_timestamp,
        block_number,
        receipt_status,
        case 
            when receipt_status = 1 then true 
            else false 
        end                                                             as is_successful,
        transaction_type,
        max_fee_per_gas / 1e9                                          as max_fee_per_gas_gwei,
        max_priority_fee_per_gas / 1e9                                 as max_priority_fee_per_gas_gwei
    from {{ source('raw_us', 'eth_transactions') }}
)

select * from source