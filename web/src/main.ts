import { createApp } from "vue"
import "./index.css"
import App from "./App.vue"
import router from "./router"
import urql from "@urql/vue"
import client from "@/graph/client"
import auth0 from "@/services/auth0"
import { api } from "@/config"

import "swiper/css"
import "swiper/css/navigation"
import "swiper/css/pagination"
import "swiper/css/scrollbar"

import { Client as VideoClient } from "btv-video-player"
import "../node_modules/btv-video-player/build/style.css"
import Auth from "./services/auth"

VideoClient.initialize({
    endpoint: api.url,
    tokenFactory: async () => (await Auth.getToken()) ?? null,
})

createApp(App).use(router).use(auth0).use(urql, client).mount("#app")
