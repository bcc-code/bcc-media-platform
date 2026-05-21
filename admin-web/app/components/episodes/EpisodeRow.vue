<script setup lang="ts">
const statusConfig: Record<
  Episode['status'],
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

const typeConfig: Record<EpisodeType, string> = {
  episode: 'Episode',
  standalone: 'Frittstående'
}

const props = defineProps<{
  episode: Episode
}>()

const timeAgo = useTimeAgo(computed(() => props.episode.publishDate))

function formatDuration(seconds: number) {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  if (h > 0) return `${h}t ${m}m`
  return `${m}m ${s}s`
}
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ episode.title }}</p>
      <p v-if="episode.season" class="text-caption-1 text-text-muted mt-0.5">
        {{ episode.season.show.title }} &middot; S{{ episode.season.number }}E{{
          episode.number
        }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ formatDuration(episode.duration) }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ typeConfig[episode.type] }}
    </td>
    <td class="px-4 py-3">
      <DesignBadge :variant="statusConfig[episode.status].variant">
        {{ statusConfig[episode.status].label }}
      </DesignBadge>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ timeAgo }}
    </td>
  </tr>
</template>
