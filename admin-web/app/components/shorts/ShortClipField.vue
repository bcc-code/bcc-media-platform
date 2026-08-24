<script setup lang="ts">
const props = defineProps<{
  duration: number
  disabled?: boolean
}>()

/** [startsAt, endsAt] in seconds. */
const model = defineModel<number[]>({ required: true })

const start = computed(() => model.value[0] ?? 0)
const end = computed(() => model.value[1] ?? 0)
const length = computed(() => Math.max(0, end.value - start.value))

const tooLong = computed(() => length.value > 60)

function nudge(index: 0 | 1, delta: number) {
  const next = [...model.value]
  const value = (next[index] ?? 0) + delta
  // Keep the handles in order and inside the video.
  if (index === 0) {
    next[0] = Math.min(Math.max(0, value), end.value - 5)
  } else {
    next[1] = Math.max(Math.min(props.duration, value), start.value + 5)
  }
  model.value = next
}
</script>

<template>
  <div class="flex flex-col gap-3">
    <div class="flex items-baseline justify-between">
      <label class="text-body-3 text-text-muted block">Utsnitt</label>
      <span class="text-caption-1 text-text-hint tabular-nums">
        av {{ formatTimecode(duration) }}
      </span>
    </div>

    <DesignRangeSlider
      v-model="model"
      :max="duration"
      :min-steps-between-thumbs="5"
      :disabled="disabled"
    />

    <div class="flex items-center gap-4">
      <div class="flex items-center gap-1">
        <span class="text-caption-1 text-text-muted w-10">Start</span>
        <DesignButton
          size="small"
          variant="tertiary"
          icon="tabler:minus"
          aria-label="Flytt start ett sekund tilbake"
          :disabled="disabled"
          @click="nudge(0, -1)"
        />
        <span class="text-title-3 text-text-default w-14 text-center tabular-nums">
          {{ formatTimecode(start) }}
        </span>
        <DesignButton
          size="small"
          variant="tertiary"
          icon="tabler:plus"
          aria-label="Flytt start ett sekund fram"
          :disabled="disabled"
          @click="nudge(0, 1)"
        />
      </div>

      <div class="flex items-center gap-1">
        <span class="text-caption-1 text-text-muted w-10">Slutt</span>
        <DesignButton
          size="small"
          variant="tertiary"
          icon="tabler:minus"
          aria-label="Flytt slutt ett sekund tilbake"
          :disabled="disabled"
          @click="nudge(1, -1)"
        />
        <span class="text-title-3 text-text-default w-14 text-center tabular-nums">
          {{ formatTimecode(end) }}
        </span>
        <DesignButton
          size="small"
          variant="tertiary"
          icon="tabler:plus"
          aria-label="Flytt slutt ett sekund fram"
          :disabled="disabled"
          @click="nudge(1, 1)"
        />
      </div>

      <DesignBadge :variant="tooLong ? 'warning' : 'neutral'" class="ml-auto">
        {{ length }} sek
      </DesignBadge>
    </div>

    <p v-if="tooLong" class="text-caption-1 text-semantic-warning">
      Shorts fungerer best under ett minutt.
    </p>
  </div>
</template>
