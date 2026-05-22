# Locales

One file per language. Filename = the language code (e.g. `de.ts` → `"de"`).

To add a language:

1. Create `<code>.ts` in this folder.
2. Default-export a `LocaleTable` (the type is exported from `../strings`).
3. That's it. The build picks it up via `import.meta.glob`.

`en.ts` is the canonical reference. TypeScript will refuse to compile until every key in `LocaleTable` is filled in. Interpolation placeholders (`{seconds}`, `{height}`, `{label}`, `{name}`, `{id}`, `{idx}`, `{rate}`) must be preserved verbatim — the runtime substitutes them by name.
