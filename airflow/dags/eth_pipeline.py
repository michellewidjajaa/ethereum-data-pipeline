from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'michelle',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': False,
}

with DAG(
    dag_id='eth_pipeline',
    default_args=default_args,
    description='Ethereum data pipeline: dbt run and test',
    schedule_interval='0 6 * * *',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=['ethereum', 'dbt', 'crypto'],
) as dag:

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /opt/airflow/dbt/crypto_pipeline && dbt run',
        env={
            'GOOGLE_APPLICATION_CREDENTIALS': '/opt/airflow/gcloud/application_default_credentials.json',
            'PATH': '/home/airflow/.local/bin:/usr/bin:/bin',
        },
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt/crypto_pipeline && dbt test',
        env={
            'GOOGLE_APPLICATION_CREDENTIALS': '/opt/airflow/gcloud/application_default_credentials.json',
            'PATH': '/home/airflow/.local/bin:/usr/bin:/bin',
        },
    )

    dbt_run >> dbt_test