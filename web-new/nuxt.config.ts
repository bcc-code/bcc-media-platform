import tailwindcss from "@tailwindcss/vite";

export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },
  modules: ["@nuxt/eslint", "@nuxt/test-utils", "nuxt-graphql-client", "@vueuse/nuxt"],
  css: [
    "~/assets/css/barlow.css",
    "~/assets/css/design-system.css",
    "~/assets/css/main.css",
  ],
  ssr: false,

  experimental: {
    typedPages: true,
  },

  routeRules: {
    "/live": {
      redirect: "https://live.bcc-connect.org",
    },
  },

  app: {
    head: {
      bodyAttrs: {
        class: "bg-background",
      },
    }
  },

  runtimeConfig: {
    public: {
      apiUrl: "https://api.brunstad.tv",
      auth0: {
        domain: "login.bcc.no",
        clientId: "iaDsfutxWw4eoRHHVryW65JHd49kXaP0",
        audience: "api.bcc.no",
      },
      sentry: {
        dsn: "https://60910093b795d754468e034c78400f31@o4507803294892032.ingest.de.sentry.io/4507865254133841",
      },
      unleash: {
        url: "https://unleash-server-prod-t5xl3eo6wq-ez.a.run.app/api/frontend",
        clientKey:
          "*:development.03da0cc96d92d3c3dc35efc801a4b27dfc2b175d00460c43e71d6fa2",
      },
      GQL_HOST: "https://api.brunstad.tv/query",
    },
  },

  vite: {
    plugins: [tailwindcss()],
  },
});