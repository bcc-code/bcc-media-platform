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
import { plugin as unleashPlugin } from '@unleash/proxy-client-vue'
import unleashClient from './services/unleash'

const app = createApp(App)

if (import.meta.env.PROD) {
    Sentry.init({
        app,
        dsn: import.meta.env.VITE_SENTRY_DSN ?? '',
        integrations: [
            Sentry.browserTracingIntegration({ router }),
            Sentry.browserProfilingIntegration(),
            Sentry.vueIntegration({
                app,
                tracingOptions: {
                    trackComponents: true,
                    hooks: ['activate', 'create', 'unmount', 'mount', 'update'],
                }
            }),
        ],
        tracePropagationTargets: [/^\//],
        tracesSampleRate: 0.5,
        profilesSampleRate: 0.5,
        environment: import.meta.env.MODE,
    })
}

app.use(i18n).use(router).use(auth0).use(unleashPlugin, { client: unleashClient, startClient: false }).use(MotionPlugin, {})
app.mount('#app')
