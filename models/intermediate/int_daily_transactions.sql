with staged as (
    select
        date(block_timestamp)           as transaction_date,
        count(*)                        as total_transactions,
        countif(is_successful = true)   as successful_transactions,
        countif(is_successful = false)  as failed_transactions,
        round(cast(sum(value_eth) as numeric), 4)           as total_eth_transferred,
        round(cast(avg(value_eth) as numeric), 4)           as avg_eth_per_transaction,
        round(cast(avg(gas_price_gwei) as numeric), 2)      as avg_gas_price_gwei,
        round(cast(sum(cast(transaction_fee_eth as numeric)) as numeric), 6) as total_fees_eth,
        round(cast(avg(transaction_fee_eth) as numeric), 6) as avg_fee_eth
    from {{ ref('stg_eth_transactions') }}
    group by transaction_date
)
select * from staged