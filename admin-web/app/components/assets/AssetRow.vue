<script setup lang="ts">
const props = defineProps<{
  asset: Asset
  episode?: Episode
}>()

const arrived = useTimeAgo(computed(() => props.asset.arrivedAt))
</script>

<template>
  <tr class="border-border-1 border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ asset.name }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5">
        {{ asset.mediabankenId }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ formatDuration(asset.duration) }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ arrived }}
    </td>
    <td class="px-4 py-3">
      <NuxtLink
        v-if="episode"
        :to="`/episodes/${episode.id}`"
        class="text-body-3 text-text-default hover:underline"
      >
        {{ episode.title }}
      </NuxtLink>
      <DesignBadge v-else variant="info">Ikke koblet</DesignBadge>
    </td>
  </tr>
</template>
