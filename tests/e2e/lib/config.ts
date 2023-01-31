import { config } from "dotenv"
config()

export const directus = {
    email: process.env.DIRECTUS_EMAIL ?? "admin@brunstad.tv",
    password: process.env.DIRECTUS_PASSWORD ?? "btv123",
    address: process.env.DIRECTUS_ADDRESS ?? "http://localhost:7055",
}

export const api = {
    endpoint: process.env.API_ENDPOINT ?? "http://localhost:7077",
}
