import 'dotenv/config'
import type { CodegenConfig } from '@graphql-codegen/cli'

const config: CodegenConfig = {
  schema: {
    // Build-time introspection via the x-api-key path; at runtime the app
    // authenticates with the API's own tokens (see composables/useAuth.ts).
    'https://api.brunstad.tv/admin': {
      headers: {
        'x-api-key': process.env.NUXT_PUBLIC_API_KEY ?? ''
      }
    }
  },
  documents: ['app/composables/**/*.ts', 'app/graphql/**/*.graphql'],
  ignoreNoDocuments: true,
  generates: {
    './app/api/': {
      preset: 'client',
      config: {
        useTypeImports: true
      }
    }
  }
}

export default config
