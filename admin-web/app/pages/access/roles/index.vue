<script setup lang="ts">
definePageMeta({ middleware: 'superuser' })

const { t } = useI18n()
const { accessTabs } = useNav()
const { formatGraphQLError } = useGraphQLError()

useHead({ title: () => t('access.roles.title') })

const { roles, fetching, error } = useRoles()

const columns = computed(() => [
  t('access.roles.columns.role'),
  t('access.roles.columns.permissions')
])
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">{{ t('access.roles.title') }}</h1>
      <DesignTabs :items="accessTabs" />
    </div>

    <p class="text-body-3 text-text-muted">
      {{ t('access.roles.intro') }}
    </p>

    <DesignLoadingState v-if="fetching && roles.length === 0" />

    <DesignErrorState
      v-else-if="error"
      :title="formatGraphQLError(error).title"
      :description="formatGraphQLError(error).description"
    />

    <DesignTable
      v-else
      :columns="columns"
      :empty="roles.length === 0 ? t('access.roles.empty') : undefined"
    >
      <NuxtLink
        v-for="role in roles"
        :key="role.id"
        :to="`/access/roles/${role.id}`"
        custom
      >
        <template #default="{ navigate }">
          <RoleRow :role="role" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
