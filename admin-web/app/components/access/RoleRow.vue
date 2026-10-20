<script setup lang="ts">
import type { PermissionItem } from '~/composables/useAccess'

defineProps<{
  role: { name: string; permissions: readonly PermissionItem[] }
}>()

const { permissionSummary } = useAccessMeta()
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent cursor-pointer border-t">
    <td class="text-title-3 text-text-default px-4 py-3">{{ role.name }}</td>
    <td class="text-body-3 text-text-muted px-4 py-3">
      {{ permissionSummary(role.permissions) }}
    </td>
  </tr>
</template>
