/// <reference types="vitest/config" />
import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import path from "path"

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "src"),
        },
    },
    build: {
        lib: {
            entry: path.resolve(__dirname, "src"),
            name: "btv-video",
        },
        outDir: "build",
    },
    test: {
        // Restrict discovery to our own sources — external-projects/ contains
        // vendored test suites (QUnit-based) that aren't ours to run.
        include: ["src/**/*.{test,spec}.{ts,tsx,js}"],
    },
})
