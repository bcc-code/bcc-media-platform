
pnpm i

pnpm build --mode dev
mv build build-dev

pnpm build --mode sta
mv build build-sta

pnpm build --mode prod
mv build build-prod

artifact push workflow build-dev
artifact push workflow build-sta
artifact push workflow build-prod
