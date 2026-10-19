<script setup lang="ts">
import type { ApiKeyInput } from '~/api/graphql'

definePageMeta({ middleware: 'superuser' })

const { t } = useI18n()
const { formatDate } = useFormat()
const { statusLabel } = useAccessMeta()
const { formatGraphQLError } = useGraphQLError()

const route = useRoute('access-api-keys-id')
const { apiKeys, fetching, update, revoke } = useApiKeys()
const toaster = useToast()

const apiKey = computed(() =>
  apiKeys.value.find((k) => k.id === route.params.id)
)

useHead({ title: () => apiKey.value?.name ?? t('access.apiKeys.singular') })

const status = computed(() => apiKey.value && apiKeyStatus(apiKey.value))

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
    title: t('access.apiKeys.toast.updatedTitle'),
    description: t('access.apiKeys.toast.updatedDescription')
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
    title: t('access.apiKeys.toast.revokedTitle'),
    description: t('access.apiKeys.toast.revokedDescription')
  })
  navigateTo('/access/api-keys')
}
</script>

<template>
  <div v-if="apiKey && status" class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/access/api-keys" :label="t('access.apiKeys.back')" />
      <div class="flex items-center justify-between gap-4">
        <h1 class="text-heading-2 text-text-default">{{ apiKey.name }}</h1>
        <DesignStatusIndicator :variant="apiKeyStatusVariants[status]">
          {{ statusLabel(status) }}
        </DesignStatusIndicator>
      </div>
      <p class="text-body-3 text-text-muted mt-1 font-mono">
        {{ apiKey.prefix }}… ·
        {{
          t('access.apiKeys.createdSuffix', {
            date: formatDate(apiKey.createdAt)
          })
        }}
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
    {{ t('access.apiKeys.notFound') }}
  </div>
</template>
