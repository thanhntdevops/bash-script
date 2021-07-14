#!/bin/bash

# before run script, export PASSWORD="password_of_user_psql"
SHELL_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
while getopts h:d:u: flag
do
    case "${flag}" in
        h) HOST=${OPTARG};;
	d) DATABASE=${OPTARG};;
        u) USERNAME=${OPTARG};;
    esac
done

PGCOMMAND=" psql -h $HOST -U $USERNAME -d $DATABASE -At -c \"
            SELECT   table_name
            FROM     information_schema.tables
            WHERE    table_type='BASE TABLE'
            AND      table_schema='public'
            \""
TABLENAMES=$(export PGPASSWORD=$PASSWORD; eval "$PGCOMMAND")

for TABLENAME in $TABLENAMES; do
    PGCOMMAND=" psql -h $HOST -U $USERNAME -d $DATABASE -At -c \"
                SELECT   count(*)
                FROM     $TABLENAME
                \""
    export PGPASSWORD=$PASSWORD && eval "$PGCOMMAND" > $SHELL_DIR/count.txt
done

awk '{ sum += $1 } END { print sum }' $SHELL_DIR/count.txt
