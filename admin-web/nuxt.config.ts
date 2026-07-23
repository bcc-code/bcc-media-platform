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

  devServer: {
    port: 4000
  },

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
      // Host base of the admin API; urql appends /admin, useAuth /auth/*.
      apiUrl: 'https://api.brunstad.tv'
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
        '@urql/exchange-auth'
      ]
    }
  },

  icon: {
    mode: 'svg'
  }
})
