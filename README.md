# Ethereum Data Pipeline

End-to-end data engineering pipeline processing 2M Ethereum transactions using dbt, BigQuery, and Airflow.

## Architecture
Raw (BigQuery) → dbt Staging → dbt Intermediate → dbt Mart → Looker Studio

## Stack
- **Warehouse**: Google BigQuery
- **Transformation**: dbt
- **Orchestration**: Airflow (Docker)
- **Dashboard**: Looker Studio
- **Source**: Ethereum public blockchain data (Q1 2025, 2M rows)

## Data Models
- `stg_eth_transactions` — cleaned and standardised raw transactions
- `int_daily_transactions` — daily aggregated metrics
- `mart_daily_volumes` — business-ready daily volumes with cumulative metrics

## Data Quality
16 dbt tests across all layers covering uniqueness, not-null constraints, and referential integrity.

## Setup
1. Clone this repo
2. Install dbt: `pip3 install dbt-bigquery`
3. Configure BigQuery credentials: `gcloud auth application-default login`
4. Run pipeline: `dbt run`
5. Test: `dbt test`
EOF