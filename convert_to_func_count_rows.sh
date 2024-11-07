#!/bin/bash

# Initialize total row count
total_row_count=0

# Loop over each table and add up row counts
for table in $(sqlite3 professors.db "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")
do
    # Count rows for the current table and add to total
    row_count=$(sqlite3 professors.db "SELECT COUNT(*) FROM $table;")
    total_row_count=$((total_row_count + row_count))
done

echo "Total row count in professors.db: $total_row_count"
