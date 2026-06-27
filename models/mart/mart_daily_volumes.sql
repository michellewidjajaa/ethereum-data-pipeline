with daily_transactions as (
    select
        transaction_date,
        total_transactions,
        successful_transactions,
        failed_transactions,
        total_eth_transferred,
        avg_eth_per_transaction,
        avg_gas_price_gwei,
        total_fees_eth,
        avg_fee_eth
    from {{ ref('int_daily_transactions') }}
),

final as (
    select
        transaction_date,
        total_transactions,
        successful_transactions,
        failed_transactions,
        round(
            cast(failed_transactions as numeric) / 
            cast(total_transactions as numeric) * 100, 2
        )                                                              as failure_rate_pct,
        round(cast(total_eth_transferred as numeric), 4)               as total_eth_transferred,
        round(cast(avg_eth_per_transaction as numeric), 4)             as avg_eth_per_transaction,
        round(cast(avg_gas_price_gwei as numeric), 2)                  as avg_gas_price_gwei,
        round(cast(total_fees_eth as numeric), 6)                      as total_fees_eth,
        round(cast(avg_fee_eth as numeric), 6)                         as avg_fee_eth,
        cast(sum(total_transactions) over (
            order by transaction_date
        ) as numeric)                                                  as cumulative_transactions,
        round(cast(sum(total_eth_transferred) over (
            order by transaction_date
        ) as numeric), 4)                                              as cumulative_eth_transferred
    from daily_transactions
)

select * from final