<script setup lang="ts">
const typeConfig: Record<
  CalendarEntryType,
  {
    label: string
    icon: string
    variant: 'success' | 'info' | 'neutral' | 'error'
  }
> = {
  SimpleCalendarEntry: {
    label: 'Direkte',
    icon: 'tabler:broadcast',
    variant: 'neutral'
  },
  EpisodeCalendarEntry: {
    label: 'Episode',
    icon: 'tabler:player-play',
    variant: 'info'
  },
  SeasonCalendarEntry: {
    label: 'Sesong',
    icon: 'tabler:stack-2',
    variant: 'success'
  },
  ShowCalendarEntry: {
    label: 'Serie',
    icon: 'tabler:device-tv',
    variant: 'success'
  }
}

const props = defineProps<{
  entry: CalendarEntry
}>()

const start = computed(() => new Date(props.entry.start))
const end = computed(() => new Date(props.entry.end))

const timeRange = useDateFormat(start, 'HH:mm')
const timeEnd = useDateFormat(end, 'HH:mm')

const isReplay = computed(
  () => props.entry.type === 'EpisodeCalendarEntry' && props.entry.isReplay
)

const hasBuffer = computed(() => props.entry.buffer.availableHours > 0)
</script>

<template>
  <div
    class="border-border-1 hover:bg-surface-indent flex cursor-pointer items-center gap-4 rounded-xl border px-4 py-3"
    :class="entry.status !== 'published' ? 'opacity-60' : ''"
  >
    <div class="flex w-14 shrink-0 flex-col items-center justify-center">
      <span class="text-title-2 text-text-default tabular-nums">
        {{ timeRange }}
      </span>
      <span class="text-caption-1 text-text-hint tabular-nums">
        {{ timeEnd }}
      </span>
    </div>

    <div class="bg-border-1 h-8 w-px" />

    <div class="min-w-0 flex-1">
      <p class="text-title-3 text-text-default truncate">{{ entry.title }}</p>
      <div class="mt-0.5 flex items-center gap-2">
        <Icon
          :name="typeConfig[entry.type].icon"
          class="text-text-hint size-3.5"
        />
        <span class="text-caption-1 text-text-muted truncate">
          {{ entry.description }}
        </span>
      </div>
    </div>

    <div class="flex shrink-0 gap-2">
      <DesignBadge v-if="entry.status === 'draft'" variant="neutral">
        Utkast
      </DesignBadge>
      <DesignTooltip v-if="hasBuffer" content="Kan startes forfra">
        <Icon name="tabler:rotate-clockwise" class="text-text-hint size-4" />
      </DesignTooltip>
      <DesignBadge v-if="isReplay" variant="neutral">Reprise</DesignBadge>
      <DesignBadge :variant="typeConfig[entry.type].variant">
        {{ typeConfig[entry.type].label }}
      </DesignBadge>
    </div>
  </div>
</template>
