# Infra

To deploy infra you need to configure the module. This is done in a separate repository.

We use Terragrunt in a private repository to deploy to production, staging and development environments. Specify the
path to environments with environment variables:

```sh
INFRA_PATH_DEV=/path/to/env/dev
INFRA_PATH_PROD=/path/to/env/prod
INFRA_PATH_STA=/path/to/env/sta
```

Run the scripts in [Makefile](../Makefile):
```sh
make infra.prod
make infra.dev
make infra.sta
```
