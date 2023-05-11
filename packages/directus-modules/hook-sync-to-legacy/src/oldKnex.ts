// This is imported as an external dependency, so knex is not bundled with this module,
// but implicitly imported when booted with directus

// @ts-ignore
import knex from "knex";

export const oldKnex = knex({
    client: 'mssql',
    connection: {
        "host": process.env.OLDDB_HOST,
        "port": Number(process.env.OLDDB_PORT),
        "user": process.env.OLDDB_USER,
        "password": process.env.OLDDB_PASSWORD,
        "database": process.env.OLDDB_DATABASE,
        "options": {
            "encrypt": process.env.OLDDB_ENCRYPT === "true"
        }
    },
});
