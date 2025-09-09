import js from '@eslint/js'
import ts from 'typescript-eslint'
import vuePlugin from 'eslint-plugin-vue'
import eslintConfigPrettier from 'eslint-config-prettier'
import unusedImports from 'eslint-plugin-unused-imports'
import globals from 'globals'

export default ts.config(
    js.configs.recommended,
    ...ts.configs.recommended,
    ...vuePlugin.configs['flat/recommended'],
    eslintConfigPrettier,
    {
        ignores: ['src/graph/generated.ts', 'build/**', 'node_modules/**'],
    },
    {
        files: ['**/*.ts', '**/*.vue'],
        languageOptions: {
            globals: {
                ...globals.browser,
                ...globals.node,
            },
            parserOptions: {
                parser: '@typescript-eslint/parser',
            },
        },
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
            'vue/multi-word-component-names': 'off',
        },
    },
    {
        plugins: {
            'unused-imports': unusedImports,
        },
        rules: {
            'no-unused-vars': 'off',
            'unused-imports/no-unused-imports': 'error',
            'unused-imports/no-unused-vars': [
                'error',
                {
                    vars: 'all',
                    varsIgnorePattern: '^_',
                    args: 'after-used',
                    argsIgnorePattern: '^_',
                },
            ],
        },
    }
)
