<script setup lang="ts">
const statusConfig: Record<
  Show['status'],
  {
    label: string
    variant: 'success' | 'info' | 'neutral' | 'warning' | 'error'
  }
> = {
  published: { label: 'Publisert', variant: 'success' },
  unlisted: { label: 'Ikke oppført', variant: 'info' },
  draft: { label: 'Utkast', variant: 'neutral' },
  archived: { label: 'Arkivert', variant: 'warning' }
}

const typeConfig: Record<ShowType, string> = {
  event: 'Arrangement',
  series: 'Serie'
}

defineProps<{
  show: Show
}>()
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent cursor-pointer border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ show.title }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5 line-clamp-1">
        {{ show.description }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 tabular-nums">
      {{ show.seasonCount }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 tabular-nums">
      {{ show.episodeCount }}
    </td>
    <td class="px-4 py-3">
      <DesignStatusIndicator :variant="statusConfig[show.status].variant">
        {{ statusConfig[show.status].label }}
      </DesignStatusIndicator>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ typeConfig[show.type] }}
    </td>
  </tr>
</template>
