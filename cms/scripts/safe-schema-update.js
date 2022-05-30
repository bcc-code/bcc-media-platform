
const knex = require('../node_modules/knex')
const child_process = require('child_process')

let config = {
    "host": process.env.DB_HOST,
    "port": Number(process.env.DB_PORT),
    "user": process.env.DB_USER,
    "password": process.env.DB_PASSWORD,
    "database" : process.env.DB_DATABASE
}

const db = knex.knex({
    client: 'pg',
    connection: config,
});

async function run() {
    let lock_result = (await db.raw("SELECT pg_try_advisory_lock(1237123)"))
    
    if (lock_result?.rows?.[0]?.pg_try_advisory_lock !== true) {
        console.error("Skipping, because another instance is doing a migration")
        process.exit(1)
    }
    
    child_process.execSync("npx directus bootstrap", {stdio: 'inherit'})
    child_process.execSync("make schema-update", {stdio: 'inherit'})

    await db.raw("SELECT pg_advisory_unlock(1237123)")

    process.exit(0);

}

run()