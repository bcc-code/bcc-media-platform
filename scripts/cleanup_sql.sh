#!/bin/bash

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_sql_file>"
    exit 1
fi

input_file="$1"
output_file="${input_file%.sql}_cleaned.sql"

# Process the file with multiple filters:
# 1. Remove lines starting with -- but not containing +
# 2. Remove lines starting with GRANT
# 3. Remove lines starting with COMMENT ON
# 4. Remove ALTER ... OWNER TO <user>; lines (with optional IF EXISTS)
# 5. Remove duplicate empty lines
sed -E '/^--[^+]*$/d' "$input_file" | \
    sed -E '/^GRANT /d' | \
    sed -E '/^COMMENT ON /d' | \
    sed -E '/^ALTER [A-Za-z_]+( IF EXISTS)? "[A-Za-z_]+"\."[A-Za-z0-9_]+"(\(\))?(\.[A-Za-z0-9_]+")* OWNER TO (bccm|builder|manager);$/d' | \
    cat -s > "$output_file"

echo "Cleaned SQL has been saved to $output_file"
