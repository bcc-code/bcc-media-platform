import { createApp, provide, h } from "vue"
import { createAuth0 } from "@auth0/auth0-vue"
import "./index.css"
import App from "./App.vue"
import config from "./config"
import router from "./router"

createApp(App)
    .use(
        createAuth0({
            domain: config.auth0.domain,
            client_id: config.auth0.domain,
            redirect_uri: window.location.origin,
        })
    )
    .use(router)
    .mount("#app")
