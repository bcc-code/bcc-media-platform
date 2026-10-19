<script setup lang="ts">
import type { ApiKeyInput } from '~/api/graphql'

definePageMeta({ middleware: 'superuser' })

const { t } = useI18n()
const { formatGraphQLError } = useGraphQLError()

useHead({ title: () => t('access.apiKeys.new') })

const { create } = useApiKeys()
const toaster = useToast()
const { copy, copied } = useClipboard({ legacy: true })

const saving = ref(false)
const createdKey = ref<string | null>(null)
const dialogOpen = ref(false)

async function handleSubmit(input: ApiKeyInput) {
  saving.value = true
  const { key, error } = await create(input)
  saving.value = false
  if (error || !key) {
    toaster.value.error(formatGraphQLError(error))
    return
  }
  createdKey.value = key
  dialogOpen.value = true
}

// The plaintext key is gone once the dialog closes, however it closes.
watch(dialogOpen, (open) => {
  if (open || !createdKey.value) return
  createdKey.value = null
  navigateTo('/access/api-keys')
})
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-8">
    <div>
      <BackButton to="/access/api-keys" :label="t('access.apiKeys.back')" />
      <h1 class="text-heading-2 text-text-default">
        {{ t('access.apiKeys.new') }}
      </h1>
    </div>

    <ApiKeyForm :saving="saving" @submit="handleSubmit" />

    <DesignDialog
      v-model:open="dialogOpen"
      :title="t('access.apiKeys.created.title')"
      :description="t('access.apiKeys.created.description')"
    >
      <template #default="{ initialFocus }">
        <div class="flex flex-col gap-5">
          <code
            class="bg-surface-indent text-body-3 text-text-default rounded-xl px-4 py-3 font-mono break-all select-all"
          >
            {{ createdKey }}
          </code>
          <DesignBanner variant="warning" icon="tabler:alert-triangle">
            <i18n-t keypath="access.apiKeys.created.headerHint" scope="global">
              <template #header>
                <code>x-api-key</code>
              </template>
            </i18n-t>
          </DesignBanner>
          <div class="flex items-center gap-3">
            <DesignButton
              :ref="initialFocus"
              :icon="copied ? 'tabler:check' : 'tabler:copy'"
              @click="copy(createdKey ?? '')"
            >
              {{
                copied
                  ? t('access.apiKeys.created.copied')
                  : t('access.apiKeys.created.copy')
              }}
            </DesignButton>
            <DesignButton variant="secondary" @click="dialogOpen = false">
              {{ t('common.done') }}
            </DesignButton>
          </div>
        </div>
      </template>
    </DesignDialog>
  </div>
</template>
