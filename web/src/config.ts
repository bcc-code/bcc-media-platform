export const auth0 = {
    domain: import.meta.env.VITE_AUTH0_DOMAIN as string,
    clientId: import.meta.env.VITE_AUTH0_CLIENT_ID as string,
    audience: import.meta.env.VITE_AUTH0_AUDIENCE as string,
}

export const api = {
    url: import.meta.env.VITE_API_URL as string,
}

export default {
    auth0,
    api,
}
