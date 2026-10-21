<script setup lang="ts">
import type { AuditLogItem } from '~/composables/useAuditLog'

const props = defineProps<{
  entry: AuditLogItem
}>()

const { t } = useI18n()
const { formatDateTime } = useFormat()

const expanded = ref(false)

const prettyArguments = computed(() => {
  try {
    return JSON.stringify(JSON.parse(props.entry.arguments), null, 2)
  } catch {
    return props.entry.arguments
  }
})

const actor = computed(() => {
  const e = props.entry
  if (e.authMethod === 'user') return e.userEmail ?? e.userId ?? '—'
  if (e.authMethod === 'apiKey') return e.apiKeyName ?? e.apiKeyId ?? '—'
  return t('access.auditLog.directus')
})
</script>

<template>
  <tr
    class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
    @click="expanded = !expanded"
  >
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ formatDateTime(entry.createdAt) }}
    </td>
    <td class="text-body-3 text-text-default px-4 py-3 font-mono">
      {{ entry.action }}
    </td>
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ actor }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5">
        {{ t(`access.auditLog.authMethods.${entry.authMethod}`) }}
        <template v-if="entry.adminUser">
          · {{ t('access.auditLog.reportedUser', { user: entry.adminUser }) }}
        </template>
      </p>
    </td>
    <td class="px-4 py-3">
      <DesignTooltip
        :content="entry.error ?? undefined"
        :disabled="!entry.error"
      >
        <DesignStatusIndicator :variant="entry.success ? 'success' : 'error'">
          {{
            entry.success
              ? t('access.auditLog.status.success')
              : t('access.auditLog.status.failed')
          }}
        </DesignStatusIndicator>
      </DesignTooltip>
    </td>
  </tr>
  <tr v-if="expanded" class="bg-surface-indent">
    <td colspan="4" class="px-4 py-3">
      <p v-if="entry.error" class="text-body-3 text-semantic-error mb-2">
        {{ entry.error }}
      </p>
      <pre
        class="text-caption-1 text-text-default overflow-x-auto font-mono whitespace-pre-wrap"
        >{{ prettyArguments }}</pre>
    </td>
  </tr>
</template>
