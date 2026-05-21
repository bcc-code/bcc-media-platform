# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
pnpm dev          # Start dev server (localhost:3000)
pnpm build        # Production build
pnpm preview      # Preview production build
pnpm lint         # ESLint
pnpm format       # Prettier format
pnpm typecheck    # TypeScript type checking (vue-tsc)
pnpm codegen      # Generate GraphQL types (requires NUXT_PUBLIC_API_KEY in .env)
```

Package manager is **pnpm 10.33.0**. Do not use npm or yarn.

## Architecture

Nuxt 4 SPA (SSR disabled) with **Tailwind CSS 4**, **Ark UI** components, and **urql** for GraphQL.

- `app/` — main application source
  - `app.vue` — root layout component
  - `pages/` — file-based routing
  - `components/` — auto-imported Vue components (no path prefix)
  - `composables/` — auto-imported composables (GraphQL queries live here)
  - `stores/` — Pinia stores
  - `api/` — generated GraphQL types (output of `pnpm codegen`, do not edit)
  - `assets/css/main.css` — global styles and Tailwind theme (purple accent palette, light/dark themes)
- `codegen.ts` — GraphQL codegen config (schema from `api.brunstad.tv/admin`)
- `nuxt.config.ts` — Nuxt modules, CSS, route rules, runtime config

## Code Style

- ESLint via `@nuxt/eslint` (default Nuxt config, no custom rules)
- Prettier: **single quotes**, **no trailing commas**, **no semicolons**
- `<script setup>` composition API syntax in all Vue SFCs
- 2-space indentation, LF line endings
- Icons: use Tabler icons via `@nuxt/icon` (e.g. `<Icon name="tabler:plus" />`)

## Design

**Always** use the defined design system and its tokens. The tokens and design system is defined in `app/assets/css/main.css`.

### Component library

Components are built with **Ark UI** (`@ark-ui/vue`) for headless behavior and **CVA** for variant styling.

## Documentation

- Nuxt: https://nuxt.com/llms.txt
- Ark UI: https://ark-ui.com/llms-vue.txt
