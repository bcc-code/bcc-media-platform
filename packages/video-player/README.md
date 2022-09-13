# Setup
## Prerequisites
- NPM (external projects)
- PNPM (project)


# Building & development

`external-projects/videojs-chromecast`

MacOS M1 / ARM
```
arch -x86_64 npm i
```


`./`
```
pnpm i
pnpm dev #pnpm build
```

# Publishing
Verify version number before publishing, and make sure you have access to the npmjs package.
```
pnpm publish
```