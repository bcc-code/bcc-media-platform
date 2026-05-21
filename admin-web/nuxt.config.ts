import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@nuxtjs/color-mode',
    '@nuxt/icon',
    '@vueuse/nuxt',
    '@pinia/nuxt'
  ],

  ssr: false,

  app: {
    head: {
      link: [
        {
          rel: 'icon',
          type: 'image/svg+xml',
          href: '/favicon-light.svg',
          media: '(prefers-color-scheme: light)'
        },
        {
          rel: 'icon',
          type: 'image/svg+xml',
          href: '/favicon-dark.svg',
          media: '(prefers-color-scheme: dark)'
        }
      ]
    }
  },

  devtools: {
    enabled: true
  },

  css: ['~/assets/css/main.css'],

  colorMode: {
    classSuffix: ''
  },

  components: {
    dirs: [
      {
        path: '~/components',
        pathPrefix: false
      }
    ]
  },

  runtimeConfig: {
    public: {
      apiUrl: 'https://api.brunstad.tv/admin',
      auth0Domain: 'https://login.bcc.no',
      auth0ClientId: 'yxkvLCpWCA6O0F4SxKZy217yALi61zFC' // TODO: get own client_id, this is from Live
    }
  },

  experimental: {
    typedPages: true
  },

  compatibilityDate: '2025-01-15',

  vite: {
    plugins: [tailwindcss()],
    optimizeDeps: {
      include: [
        'cva',
        '@ark-ui/vue',
        '@urql/vue',
        'vue-draggable-plus',
        '@auth0/auth0-vue',
        '@urql/exchange-auth'
      ]
    }
  },

  icon: {
    mode: 'svg'
  }
})
