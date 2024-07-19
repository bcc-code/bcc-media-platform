import { createApp } from "vue"
import "./styles/index.css"
import "./styles/barlow.css"
import "./styles/design-system.css"
import App from "./App.vue"
import router from "./router"
import auth0 from "@/services/auth0"

import * as Sentry from "@sentry/vue"

import "swiper/css"
import "swiper/css/navigation"
import "swiper/css/pagination"
import "swiper/css/scrollbar"
import i18n from "./i18n"
import { MotionPlugin } from '@vueuse/motion'

const app = createApp(App)

if (import.meta.env.PROD) {
    Sentry.init({
        app,
        dsn: "https://3ffd6244935a49dab6913bdc148d8d41@o1045703.ingest.sentry.io/4504299662278656",
        integrations: [Sentry.browserTracingIntegration({ router })],
        tracePropagationTargets: [/^\//],
        tracesSampleRate: 0.5,
        environment: import.meta.env.MODE,
    })
}

app.use(i18n).use(router).use(auth0).use(MotionPlugin, {

})
app.mount("#app")
