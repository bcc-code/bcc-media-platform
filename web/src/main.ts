import { createApp } from 'vue'
import './styles/index.css'
import './styles/barlow.css'
import './styles/design-system.css'
import App from './App.vue'
import router from './router'
import auth0 from '@/services/auth0'

import * as Sentry from '@sentry/vue'

import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import 'swiper/css/scrollbar'
import i18n from './i18n'
import { MotionPlugin } from '@vueuse/motion'

const app = createApp(App)

if (import.meta.env.PROD) {
    Sentry.init({
        app,
        dsn: 'https://905cd79d515c1c75c7bfc0dc5e2d83b4@o4507803294892032.ingest.de.sentry.io/4507803304394832',
        integrations: [
            Sentry.browserTracingIntegration({ router }),
            Sentry.browserProfilingIntegration(),
        ],
        tracePropagationTargets: [/^\//],
        tracesSampleRate: 0.5,
        profilesSampleRate: 0.5,
        environment: import.meta.env.MODE,
    })
}

app.use(i18n).use(router).use(auth0).use(MotionPlugin, {})
app.mount('#app')
