cd ./tests/e2e
docker compose down

# Start the DB
docker compose up db -d --wait

# Run migrations
cd ../../migrations
./migrate_test.sh -h localhost -p 5400 -U btv -d postgres

# Build project
cd ..
scripts/gen-version.sh
cp version.json ./backend
CGO_ENABLED=0 go build -v -o ./backend/bin ./backend/cmd/api

# Run tests
cd ./tests/e2e
docker compose up api directus -d --wait

pnpm i
pnpm ava
