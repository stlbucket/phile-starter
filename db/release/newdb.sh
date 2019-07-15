echo dropdb pg_phile_starter
dropdb -h 0.0.0.0 -p 5432 -U postgres pg_phile_starter
echo createdb pg_phile_starter
createdb -h 0.0.0.0 -p 5432 -U postgres pg_phile_starter

cd ../ansible && ansible-playbook deploy-database.yml --verbose
