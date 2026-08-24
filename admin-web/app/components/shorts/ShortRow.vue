<script setup lang="ts">
const statusConfig: Record<
  Status,
  { label: string; variant: 'success' | 'info' | 'neutral' | 'warning' }
> = {
  published: { label: 'Publisert', variant: 'success' },
  unlisted: { label: 'Ikke oppført', variant: 'info' },
  draft: { label: 'Utkast', variant: 'neutral' },
  archived: { label: 'Arkivert', variant: 'warning' }
}

const props = defineProps<{
  short: Short
  episode?: Episode
}>()

const length = computed(() => props.short.endsAt - props.short.startsAt)
const created = useTimeAgo(computed(() => props.short.createdAt))
</script>

<template>
  <tr
    class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
    @click="navigateTo(`/shorts/${short.id}`)"
  >
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ short.title }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5 tabular-nums">
        {{ formatTimecode(short.startsAt) }}–{{ formatTimecode(short.endsAt) }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3">
      <span v-if="episode">{{ episode.title }}</span>
      <DesignBadge v-else variant="warning">Ukjent episode</DesignBadge>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ length }} sek
    </td>
    <td class="px-4 py-3">
      <DesignBadge :variant="statusConfig[short.status].variant">
        {{ statusConfig[short.status].label }}
      </DesignBadge>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ created }}
    </td>
  </tr>
</template>
