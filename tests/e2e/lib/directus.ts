import { Directus } from "@directus/sdk"
import { episodes } from "./types"
import { config } from "dotenv"

config()

export const client = new Directus<episodes>("http://localhost:8055")

export const login = async () => {
    await client.auth.login({
        email: process.env.DIRECTUS_EMAIL ?? "",
        password: process.env.DIRECTUS_PASSWORD ?? "",
    })
}
