# Locales

One file per language. Filename = the language code (e.g. `de.ts` → `"de"`).

To add a language:

1. Create `<code>.ts` in this folder. Default-export a `LocaleTable`.
2. Register it in `../strings.ts` — add the `import`, add the code to `SUPPORTED_LANGS`, and add the table to `STRINGS`. TypeScript will refuse to compile until all three are in sync.

`en.ts` is the canonical reference. TypeScript will also refuse to compile until every key in `LocaleTable` is filled in. Interpolation placeholders (`{seconds}`, `{height}`, `{label}`, `{name}`, `{id}`, `{idx}`, `{rate}`) must be preserved verbatim — the runtime substitutes them by name.
