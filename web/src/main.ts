import { createApp } from "vue"
import "./index.css"
import App from "./App.vue"
import router from "./router"
import auth0 from "@/services/auth0"
import { api } from "@/config"

import "swiper/css"
import "swiper/css/navigation"
import "swiper/css/pagination"
import "swiper/css/scrollbar"

createApp(App)
    .use(router)
    .use(auth0)
    .mount("#app")
