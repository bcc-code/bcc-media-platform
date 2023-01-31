import { Directus } from "@directus/sdk"
import { episodes } from "./types"
import { directus } from "lib/config"

export const client = new Directus<episodes>(directus.address)

export const login = async () => {
    await client.auth.login({
        email: directus.email,
        password: directus.password,
    })
}
