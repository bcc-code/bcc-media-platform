<script setup lang="ts">
import type { ApiKeyItem } from '~/composables/useAccess'

const props = defineProps<{
  apiKey: ApiKeyItem
}>()

const { t } = useI18n()
const { formatDate } = useFormat()
const { statusLabel, permissionSummary } = useAccessMeta()

const status = computed(() => apiKeyStatus(props.apiKey))
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent cursor-pointer border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ apiKey.name }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5 line-clamp-1">
        {{ permissionSummary(apiKey.permissions) }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 font-mono">
      {{ apiKey.prefix }}…
    </td>
    <td class="px-4 py-3">
      <DesignStatusIndicator :variant="apiKeyStatusVariants[status]">
        {{ statusLabel(status) }}
      </DesignStatusIndicator>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ apiKey.expiresAt ? formatDate(apiKey.expiresAt) : t('common.never') }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ formatDate(apiKey.createdAt) }}
    </td>
  </tr>
</template>
