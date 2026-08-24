<script setup lang="ts">
defineProps<{
  page: Page
}>()

const statusConfig: Record<
  Status,
  { label: string; variant: 'success' | 'info' | 'neutral' | 'warning' }
> = {
  published: { label: 'Publisert', variant: 'success' },
  unlisted: { label: 'Ikke oppført', variant: 'info' },
  draft: { label: 'Utkast', variant: 'neutral' },
  archived: { label: 'Arkivert', variant: 'warning' }
}
</script>

<template>
  <tr
    class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
    @click="navigateTo(`/pages/${page.id}`)"
  >
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ page.title }}</p>
      <p v-if="page.description" class="text-caption-1 text-text-muted mt-0.5">
        {{ page.description }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 font-mono">
      {{ page.code }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ applicationLabel(page.applicationCode) }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 tabular-nums">
      {{ page.sections.length }}
    </td>
    <td class="px-4 py-3">
      <DesignBadge :variant="statusConfig[page.status].variant">
        {{ statusConfig[page.status].label }}
      </DesignBadge>
    </td>
  </tr>
</template>
