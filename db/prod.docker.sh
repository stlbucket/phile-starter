#!/usr/bin/env bash
echo dropdb
dropdb -h 0.0.0.0 -p 5432 -U postgres pg_phile_starter
echo createdb
createdb -h 0.0.0.0 -p 5432 -U postgres pg_phile_starter
echo restore
psql -h 0.0.0.0 -p 5432 -U postgres pg_phile_starter < ../../ps_hannah.sql


