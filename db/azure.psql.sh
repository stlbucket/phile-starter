#!/usr/bin/env bash
echo -d postgres -h drp-dev-tmp.postgres.database.azure.com
psql "sslmode=verify-ca sslrootcert=../root.crt host=drp-dev-tmp.postgres.database.azure.com port=5432 dbname=postgres user=drpdevadmin@drp-dev-tmp password=CQ4KTKnz3sRyLZkr sslmode=require"