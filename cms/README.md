
# BrunstadTV Admin

## Local setup


```
docker compose up -d
npx directus bootstrap
make schema-update
```


##  Issues

###  Snapshots and apply

`schema apply` has some issues with foreign keys: https://github.com/directus/directus/issues/9723

To fix this, we create a temporary schema with the relations removed, then apply the original schema.
We do this in the make schema-update script.

```´
yq e '.collections.[].meta.group = null' schema.yml > temp.yml
npx directus schema apply temp.yml -y
npx directus schema apply schema.yml -y
```