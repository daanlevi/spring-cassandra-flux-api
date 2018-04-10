!#/bin/bash
cqlsh -e "CREATE KEYSPACE IF NOT EXISTS recommend WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };"
cqlsh -e "CREATE TABLE IF NOT EXISTS recommend.Product (sku text PRIMARY KEY,recommendations list<text>);"
cqlsh -e "CREATE TABLE IF NOT EXISTS recommend.User (userId text PRIMARY KEY,trigger text);"
# verify
cqlsh -e "SELECT * FROM system_schema.keyspaces;"
