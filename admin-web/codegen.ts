import type { CodegenConfig } from '@graphql-codegen/cli'

const config: CodegenConfig = {
  // The local schema keeps types in step with the backend in this repo.
  schema: '../backend/graph/admin/schema.graphqls',
  documents: ['app/composables/**/*.ts', 'app/graphql/**/*.graphql'],
  ignoreNoDocuments: true,
  generates: {
    './app/api/': {
      preset: 'client',
      presetConfig: {
        fragmentMasking: false
      },
      config: {
        useTypeImports: true
      }
    }
  }
}

export default config
