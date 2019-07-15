\echo -----------------------------------------------------------------------------------------------------
\echo
\echo executing command:  psql -h 0.0.0.0 -U postgres
\echo -----------------------------------------------------------------------------------------------------
\echo DEFAULT PASSWORD = 1234
\echo you may consider creating a .pgpass file in your home directory
\echo https://www.postgresql.org/docs/9.4/libpq-pgpass.html
\echo
\echo with the following content
\echo
\echo  0.0.0.0:5432:*:postgres:1234
\echo
\echo -----------------------------------------------------------------------------------------------------
\echo
\echo
psql -h 0.0.0.0 -U postgres -d phile_starter