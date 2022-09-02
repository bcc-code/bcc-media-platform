import { createApp } from "vue"
import { createAuth0 } from "@auth0/auth0-vue"
import "./index.css"
import App from "./App.vue"
import config from "./config"
import router from "./router"
import urql from "@urql/vue"
import client from "@/services/api/client"

import { Client as VideoClient } from "btv-video-player"
import "../node_modules/btv-video-player/build/style.css"

VideoClient.initialize({
    endpoint: "http://localhost:8077/query",
    tokenFactory: null
})

createApp(App)
    .use(
        createAuth0({
            domain: config.auth0.domain,
            client_id: config.auth0.domain,
            redirect_uri: window.location.origin,
        })
    )
    .use(urql, client)
    .use(router)
    .mount("#app")
