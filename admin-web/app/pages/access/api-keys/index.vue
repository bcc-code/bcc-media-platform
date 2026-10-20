<script setup lang="ts">
definePageMeta({ middleware: 'superuser' })

const { t } = useI18n()
const { accessTabs } = useNav()
const { formatGraphQLError } = useGraphQLError()

useHead({ title: () => t('access.apiKeys.title') })

const { apiKeys, fetching, error, refetch } = useApiKeys()

const showRevoked = ref(false)

const visibleKeys = computed(() =>
  apiKeys.value.filter((k) => showRevoked.value || !k.revokedAt)
)

const columns = computed(() => [
  t('access.apiKeys.columns.name'),
  t('access.apiKeys.columns.key'),
  t('access.apiKeys.columns.status'),
  t('access.apiKeys.columns.expires'),
  t('access.apiKeys.columns.created')
])
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between gap-4">
      <h1 class="sr-only">{{ t('access.apiKeys.title') }}</h1>
      <DesignTabs :items="accessTabs" />
      <NuxtLink to="/access/api-keys/new">
        <DesignButton icon="tabler:plus">
          {{ t('access.apiKeys.newButton') }}
        </DesignButton>
      </NuxtLink>
    </div>

    <div class="flex items-center gap-3">
      <DesignSwitch
        v-model="showRevoked"
        :label="t('access.apiKeys.showRevoked')"
      />
    </div>

    <DesignLoadingState v-if="fetching && apiKeys.length === 0" />

    <DesignErrorState
      v-else-if="error"
      :title="formatGraphQLError(error).title"
      :description="formatGraphQLError(error).description"
    >
      <template #action>
        <DesignButton variant="secondary" @click="refetch">
          {{ t('common.retry') }}
        </DesignButton>
      </template>
    </DesignErrorState>

    <DesignTable
      v-else
      :columns="columns"
      :empty="visibleKeys.length === 0 ? t('access.apiKeys.empty') : undefined"
    >
      <NuxtLink
        v-for="apiKey in visibleKeys"
        :key="apiKey.id"
        :to="`/access/api-keys/${apiKey.id}`"
        custom
      >
        <template #default="{ navigate }">
          <ApiKeyRow :api-key="apiKey" @click="navigate" />
        </template>
      </NuxtLink>
    </DesignTable>
  </div>
</template>
