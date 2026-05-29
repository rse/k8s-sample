#!/usr/bin/env bash
set -e

#   create the application user and database only if they do not yet exist
#   (the official image may already create them when POSTGRES_USER/POSTGRES_DB match)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	DO \$\$
	BEGIN
		IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$CFG_CUSTOM_USERNAME') THEN
			CREATE USER "$CFG_CUSTOM_USERNAME" WITH PASSWORD '$CFG_CUSTOM_PASSWORD';
		END IF;
	END
	\$\$;
	SELECT 'CREATE DATABASE "$CFG_CUSTOM_DATABASE"'
		WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$CFG_CUSTOM_DATABASE')\gexec
	GRANT ALL PRIVILEGES ON DATABASE "$CFG_CUSTOM_DATABASE" TO "$CFG_CUSTOM_USERNAME";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$CFG_CUSTOM_DATABASE" <<-EOSQL
	GRANT ALL ON SCHEMA public TO "$CFG_CUSTOM_USERNAME";
EOSQL
