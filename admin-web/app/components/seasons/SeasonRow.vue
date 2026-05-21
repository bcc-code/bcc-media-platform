<script setup lang="ts">
const statusConfig: Record<
  Season['status'],
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

defineProps<{
  season: Season
}>()
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent cursor-pointer border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ season.title }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5">
        {{ season.show.title }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 tabular-nums">
      S{{ season.number }}
    </td>
    <td class="px-4 py-3">
      <DesignStatusIndicator :variant="statusConfig[season.status].variant">
        {{ statusConfig[season.status].label }}
      </DesignStatusIndicator>
    </td>
    <td class="px-4 py-3">
      <DesignAgeRating :rating="season.ageRating" />
    </td>
  </tr>
</template>
