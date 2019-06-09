#!/bin/bash

# running the command
function run(){
    local command=$1
    eval "$command"
}

# copy table from one place to another
function copy_table(){
	cmd="bq cp $1 $2"
	run "$cmd"
}

# create a table from output of a query result
function create_table_by_result(){
	cmd="bq query --destination_table $1 --replace --use_legacy_sql=false '"$2"'"
	run "$cmd"
}

# execute a BQ sql query
function execute_query(){
	cmd="bq query --use_legacy_sql=false '"$1"'"
	run "$cmd"
}

# running the command
function replace_string(){
    local str=$1
    local param_name=$2
    local param_value=$3
    echo "${str//$param_name/$param_value}"
}

function readfile(){
	local file_name=$1
	local data=`cat "$file_name"`
	echo "$data"
}
