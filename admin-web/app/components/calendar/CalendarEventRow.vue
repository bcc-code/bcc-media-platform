<script setup lang="ts">
const props = defineProps<{
  event: CalendarEvent
}>()

const start = computed(() => new Date(props.event.start))
const end = computed(() => new Date(props.event.end))

const startFormatted = computed(() =>
  start.value.toLocaleDateString('nb-NO', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
)

const endFormatted = computed(() =>
  end.value.toLocaleDateString('nb-NO', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
)

const dayCount = computed(() => {
  const ms = end.value.getTime() - start.value.getTime()
  return Math.ceil(ms / 86400000)
})
</script>

<template>
  <tr class="border-border-1 hover:bg-surface-indent cursor-pointer border-t">
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ event.title }}</p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ startFormatted }}
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ endFormatted }}
    </td>
    <td class="px-4 py-3">
      <DesignBadge variant="neutral">
        {{ dayCount }} {{ dayCount === 1 ? 'dag' : 'dager' }}
      </DesignBadge>
    </td>
  </tr>
</template>
