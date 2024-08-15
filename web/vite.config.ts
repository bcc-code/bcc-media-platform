import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'node:path'
import VueI18nPlugin from '@intlify/unplugin-vue-i18n/vite'

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        vue(),
        VueI18nPlugin({
            /* options */
            fullInstall: true,
            runtimeOnly: false,
        }),
    ],
    server: {
        port: 3000,
    },
    resolve: {
        alias: {
            '@': resolve(__dirname, './src'),
        },
    },
    build: {
        outDir: 'build',
    },
})
