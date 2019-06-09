# garment table backup and garment events to invetory events table creation
Bash script to create invetory events table using garment events in a google big query

## Working on

- Linux
- OSX

## Getting Started

### Usage

Step1: Copy the `run.sh`, `bq.sh`, `queries/..`, `schema/..` files locally or the server where you have gcloud installed & [authenticated](https://cloud.google.com/sdk/gcloud/reference/init).

Step2: 
`./run.sh [PROJECT-ID] [INVENTORY_DATASET_NAME] [GARMENTS_DATASET_NAME] [BACKUP_DATASET_NAME] [GARMENTS_TABLE_NAME] [INVENTORY_TABLE_NAME]`

### Info
Backup tables are created in the [BACKUP_DATASET_NAME] bigquery dataset.
