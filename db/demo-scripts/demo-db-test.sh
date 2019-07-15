TEST_DATABASE_URL=postgres://postgres:1234@0.0.0.0/pg_phile_starter jest release/evt-fn/_test/db/demonstrate-db-test.spec.js | pino-pretty

./execute.sh release/leaf-fn/_dev/scratch.sql