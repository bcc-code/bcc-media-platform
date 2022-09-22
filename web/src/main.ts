import { createApp } from "vue"
import "./index.css"
import App from "./App.vue"
import router from "./router"
import auth0 from "@/services/auth0"

import "swiper/css"
import "swiper/css/navigation"
import "swiper/css/pagination"
import "swiper/css/scrollbar"
import i18n from "./i18n"

createApp(App).use(i18n).use(router).use(auth0).mount("#app")
