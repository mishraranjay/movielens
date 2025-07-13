#!/bin/bash
set -e
set -x

DBNAME="${DBNAME:-testdb1}"
DB2USER="${DB2INSTANCE:-db2inst1}"

#echo "✅ Starting DB2..."
#su - "$DB2USER" -c "db2start" || echo "⚠️ DB2 may already be running."

echo "🔗 Connecting to DB: $DBNAME"
su - "$DB2USER" -c "db2 connect to $DBNAME" || { echo "❌ Failed to connect"; exit 1; }

echo "🚀 Loading CSV files into DB2..."

# Wrap the entire db2 logic in a single su session
su - "$DB2USER" -c "
  source /database/config/db2inst1/sqllib/db2profile
  db2 connect to $DBNAME

  for file in /custom/csv/*.csv; do
    filename=\$(basename \"\$file\")
    tablename=\${filename%.csv}

    echo \"📄 Loading table: \$tablename from \$file\"

    header=\$(head -n 1 \"\$file\" | tr -d '\r' | tr -d '\"')
    cols=\$(echo \"\$header\" | awk -F',' '{for(i=1;i<=NF;i++) printf \"%s VARCHAR(255)%s\", \$i, (i<NF?\", \":\"\")}')

    db2 \"DROP TABLE IF EXISTS \$tablename\"
    db2 \"CREATE TABLE \$tablename (\$cols)\"

    col_count=\$(echo \"\$header\" | awk -F',' '{print NF}')
    positions=\$(seq -s, 1 \$col_count)

    db2 \"IMPORT FROM \$file OF DEL MODIFIED BY COLDEL, NOCHARDEL METHOD P (\$positions) INSERT INTO \$tablename\"
  done

  db2 TERMINATE
"
