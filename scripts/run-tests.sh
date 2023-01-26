docker compose -f compose.test.yml down

# Start the DB
docker compose -f compose.test.yml up db redis -d --wait

# Run migrations
cd ./migrations
./migrate_test.sh -h localhost -p 5400 -U bccm -d bccm

# Run tests
cd ..
docker compose -f compose.test.yml up api directus -d --wait

# cd ./tests/e2e
# pnpm i
# pnpm ava
