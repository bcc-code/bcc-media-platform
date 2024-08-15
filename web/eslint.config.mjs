import js from '@eslint/js'
import ts from 'typescript-eslint'
import vuePlugin from 'eslint-plugin-vue'
import eslintConfigPrettier from 'eslint-config-prettier'

export default ts.config(
    js.configs.recommended,
    ...ts.configs.recommended,
    ...vuePlugin.configs['flat/recommended'],
    eslintConfigPrettier,
    {
        ignores: ['src/graph/generated.ts'],
    },
    {
        files: ['**/*.ts', '**/*.vue'],
        languageOptions: {
            parserOptions: {
                parser: '@typescript-eslint/parser'
            }
        }
    },
    {
        rules: {
            'vue/block-lang': [
                'error',
                {
                    script: {
                        lang: 'ts',
                    },
                },
            ],
            'vue/block-order': [
                'error',
                {
                    order: [
                        'script:not([setup])',
                        'script[setup]',
                        'template',
                        'style',
                    ],
                },
            ],
        },
    },
)
