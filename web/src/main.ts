import { createApp } from "vue"
import "./index.css"
import App from "./App.vue"
import router from "./router"
import urql from "@urql/vue"
import client from "@/graph/client"
import auth0 from "@/services/auth0"

import { Client as VideoClient } from "btv-video-player"
import "../node_modules/btv-video-player/build/style.css"
import Auth from "./services/auth"

VideoClient.initialize({
    endpoint: "http://localhost:8077/query",
    tokenFactory: async () => await Auth.getToken() ?? null
})

createApp(App)
    .use(router)
    .use(auth0)
    .use(urql, client)
    .mount("#app")
