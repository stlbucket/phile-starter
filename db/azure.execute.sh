#!/usr/bin/env bash
echo -d postgres -h drp-dev-tmp.postgres.database.azure.com
echo script: $1
psql "sslmode=verify-ca sslrootcert=../root.crt host=drp-dev-tmp.postgres.database.azure.com port=5432 dbname=pg_phile_starter user=drpdevadmin@drp-dev-tmp password=CQ4KTKnz3sRyLZkr sslmode=require" - a --file $1