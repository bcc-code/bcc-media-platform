<script setup lang="ts">
import type { ApiKeyInput } from '~/api/graphql'

definePageMeta({ middleware: 'superuser' })

const route = useRoute('access-api-keys-id')
const { apiKeys, fetching, update, revoke } = useApiKeys()
const toaster = useToast()

const apiKey = computed(() =>
  apiKeys.value.find((k) => k.id === route.params.id)
)

useHead({ title: () => apiKey.value?.name ?? 'API-nøkkel' })

const saving = ref(false)

async function handleSubmit(input: ApiKeyInput) {
  saving.value = true
  const { error } = await update(route.params.id, input)
  saving.value = false
  if (error) {
    toaster.value.error(formatGraphQLError(error))
    return
  }
  toaster.value.success({
    title: 'Nøkkel oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/access/api-keys')
}

async function handleRevoke() {
  const { error } = await revoke(route.params.id)
  if (error) {
    toaster.value.error(formatGraphQLError(error))
    return
  }
  toaster.value.success({
    title: 'Nøkkel tilbakekalt',
    description: 'Nøkkelen gir ikke lenger tilgang.'
  })
  navigateTo('/access/api-keys')
}
</script>

<template>
  <div v-if="apiKey" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/access/api-keys" label="Tilbake til API-nøkler" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">{{ apiKey.name }}</h1>
        <DesignStatusIndicator
          :variant="apiKeyStatusConfig[apiKeyStatus(apiKey)].variant"
        >
          {{ apiKeyStatusConfig[apiKeyStatus(apiKey)].label }}
        </DesignStatusIndicator>
      </div>
      <p class="text-body-3 text-text-muted mt-1 font-mono">
        {{ apiKey.prefix }}… · opprettet {{ formatDate(apiKey.createdAt) }}
      </p>
    </div>

    <ApiKeyForm
      :key="apiKey.id"
      :api-key="apiKey"
      :saving="saving"
      @submit="handleSubmit"
      @revoke="handleRevoke"
    />
  </div>

  <DesignLoadingState v-else-if="fetching" />

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Nøkkelen ble ikke funnet.
  </div>
</template>
