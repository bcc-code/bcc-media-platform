<script setup lang="ts">
import type { ApiKeyInput, PermissionInput } from '~/api/graphql'
import type { ApiKeyItem } from '~/composables/useAccess'

const props = defineProps<{
  apiKey?: ApiKeyItem
  saving?: boolean
}>()

const emit = defineEmits<{
  submit: [input: ApiKeyInput]
  revoke: []
}>()

const dirty = defineModel<boolean>('dirty', { default: false })

const { t } = useI18n()
const { formatDate } = useFormat()

const isEditing = computed(() => !!props.apiKey)
const isRevoked = computed(() => !!props.apiKey?.revokedAt)

// The date picker works in local YYYY-MM-DD; the API takes RFC3339.
function toDateValue(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  const pad = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
}

const name = ref(props.apiKey?.name ?? '')
const expiresOn = ref(toDateValue(props.apiKey?.expiresAt))
const initialPermissions = toPermissionInputs(props.apiKey?.permissions ?? [])
const permissions = ref<PermissionInput[]>(initialPermissions)

const initialName = name.value
const initialExpiresOn = expiresOn.value

watchEffect(() => {
  dirty.value =
    name.value !== initialName ||
    expiresOn.value !== initialExpiresOn ||
    !samePermissions(permissions.value, initialPermissions)
})

const submitted = ref(false)

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    name: !name.value.trim()
      ? t('access.apiKeys.form.nameRequired')
      : undefined,
    permissions:
      permissions.value.length === 0
        ? t('access.apiKeys.form.permissionsRequired')
        : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    name: name.value.trim(),
    // Valid through the whole chosen day. Omitting it means no expiry.
    expiresAt: expiresOn.value
      ? new Date(`${expiresOn.value}T23:59:59`).toISOString()
      : undefined,
    permissions: permissions.value
  })
}

const confirm = useConfirm()

async function handleRevoke() {
  const ok = await confirm({
    title: t('access.apiKeys.form.revokeConfirmTitle'),
    description: t('access.apiKeys.form.revokeConfirmDescription'),
    confirmLabel: t('access.apiKeys.form.revoke'),
    intent: 'danger'
  })
  if (ok) emit('revoke')
}
</script>

<template>
  <div class="flex flex-col">
    <DesignBanner
      v-if="isRevoked"
      variant="neutral"
      icon="tabler:ban"
      class="mb-2"
    >
      {{
        t('access.apiKeys.form.revokedBanner', {
          date: formatDate(apiKey?.revokedAt)
        })
      }}
    </DesignBanner>

    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="name"
        :label="t('access.apiKeys.form.nameLabel')"
        :placeholder="t('access.apiKeys.form.namePlaceholder')"
        required
        :disabled="isRevoked"
        :invalid="!!errors.name"
        :error-text="errors.name"
      />
      <DesignDatePicker
        v-model="expiresOn"
        :label="t('access.apiKeys.form.expiresLabel')"
        :placeholder="t('access.apiKeys.form.expiresPlaceholder')"
        :helper-text="t('access.apiKeys.form.expiresHelper')"
        :disabled="isRevoked"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-3 border-t py-6">
      <div>
        <h2 class="text-title-1 text-text-default">
          {{ t('access.permissions.title') }}
        </h2>
        <p
          class="text-body-3 mt-1"
          :class="
            errors.permissions ? 'text-semantic-error' : 'text-text-muted'
          "
        >
          {{ errors.permissions ?? t('access.apiKeys.form.permissionsHint') }}
        </p>
      </div>
      <PermissionEditor v-model="permissions" :disabled="isRevoked" />
    </div>

    <div
      v-if="!isRevoked"
      class="border-border-1 flex items-center gap-3 border-t pt-6"
    >
      <DesignButton :loading="saving" @click="handleSubmit">
        {{
          isEditing ? t('common.saveChanges') : t('access.apiKeys.form.create')
        }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/access/api-keys')"
      >
        {{ t('common.cancel') }}
      </DesignButton>
      <div v-if="isEditing" class="ml-auto">
        <DesignButton
          variant="tertiary"
          intent="danger"
          icon="tabler:ban"
          @click="handleRevoke"
        >
          {{ t('access.apiKeys.form.revoke') }}
        </DesignButton>
      </div>
    </div>
  </div>
</template>
