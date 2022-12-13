# BrunstadTV web project

This project contains the source code for the new BrunstadTV Web frontend (currently not published)

## Running

```
pnpm i
pnpm dev
```

Note: If you get "Failed to fetch dynamically imported module" errors, disable any adblockers or similar extensions.

## GraphQL

Generate types and queries with `pnpm generate`. Types are determined by definitions in .graphql files across the project.

## Translations

Install Crowdin CLI `brew install crowdin`

Create a file `.crowdin_token` and fill it with a crowdin token with access to listing projects and reading/writing translations and source strings.

Run `pnpm ts:download` to download new translations and `pnpm ts:upload` to upload translations.
