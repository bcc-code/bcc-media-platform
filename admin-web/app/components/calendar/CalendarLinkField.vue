<script setup lang="ts">
const props = defineProps<{
  type: CalendarEntryType
  invalid?: string
}>()

const model = defineModel<string[]>({ required: true })

const { episodes } = useEpisodes()
const { seasons } = useSeasons()
const { shows } = useShows()

const label = computed(
  () =>
    ({
      SimpleCalendarEntry: '',
      EpisodeCalendarEntry: 'Episode',
      SeasonCalendarEntry: 'Sesong',
      ShowCalendarEntry: 'Serie'
    })[props.type]
)

const options = computed(() => {
  switch (props.type) {
    case 'EpisodeCalendarEntry':
      return episodes.value.map((e) => ({
        label: e.season
          ? `${e.season.show.title} S${e.season.number}E${e.number} — ${e.title}`
          : e.title,
        value: e.id
      }))
    case 'SeasonCalendarEntry':
      return seasons.value.map((s) => ({
        label: `${s.show.title} — Sesong ${s.number}`,
        value: s.id
      }))
    case 'ShowCalendarEntry':
      return shows.value.map((s) => ({ label: s.title, value: s.id }))
    default:
      return []
  }
})
</script>

<template>
  <div v-if="type !== 'SimpleCalendarEntry'" class="flex flex-col gap-1">
    <label class="text-body-3 text-text-muted block">{{ label }}</label>
    <DesignSelect
      v-model="model"
      :items="options"
      :placeholder="`Velg ${label.toLowerCase()}`"
    />
    <p v-if="invalid" class="text-caption-1 text-semantic-error mt-1">
      {{ invalid }}
    </p>
  </div>
</template>
