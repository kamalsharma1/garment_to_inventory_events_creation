#!/bin/bash

declare -r PROJECT_ID=$1
[[ -z "${PROJECT_ID// }" ]] && exit

declare -r INVENTORY_DATASET_NAME=$2
[[ -z "${INVENTORY_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_DATASET_NAME=$3
[[ -z "${GARMENTS_DATASET_NAME// }" ]] && exit

declare -r BACKUP_DATASET_NAME=$4
[[ -z "${BACKUP_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_TABLE_NAME=$5
[[ -z "${GARMENTS_TABLE_NAME// }" ]] && exit

declare -r INVENTORY_TABLE_NAME=$6
[[ -z "${INVENTORY_TABLE_NAME// }" ]] && exit

source ./bq.sh

create_query_file_name=queries/garments_to_inventory_events_query.sql
inventory_table_schema=schema/inventory_schema.json

# backup data postfix
backup_table_name_postfix=_backup

# full table name with project id, dataset and table name
inventory_data_table_name=${PROJECT_ID}.${INVENTORY_DATASET_NAME}.${INVENTORY_TABLE_NAME}
garments_data_table_name=${PROJECT_ID}.${GARMENTS_DATASET_NAME}.${GARMENTS_TABLE_NAME}

# backup garmenrs and inventory tables
backup_garments_data_table_name=${PROJECT_ID}:${BACKUP_DATASET_NAME}.${GARMENTS_TABLE_NAME}${backup_table_name_postfix}

insert_query=$(readfile $create_query_file_name)
insert_query=$(replace_string "$insert_query" "GARMENT_EVENTS_TABLE" $garments_data_table_name)
insert_query=$(replace_string "$insert_query" "INVENTORY_EVENTS_TABLE" $inventory_data_table_name)

# Backup garment table in new table --> creation of backup table 
copy_table ${PROJECT_ID}:${GARMENTS_DATASET_NAME}.${GARMENTS_TABLE_NAME} $backup_garments_data_table_name

# create table
bq mk --table ${PROJECT_ID}:${INVENTORY_DATASET_NAME}.${INVENTORY_TABLE_NAME} $inventory_table_schema

# execute query
execute_query "$insert_query"