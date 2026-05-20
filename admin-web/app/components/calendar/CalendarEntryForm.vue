<script setup lang="ts">
const props = defineProps<{
  entry?: CalendarEntry
}>()

const emit = defineEmits<{
  submit: [data: CalendarEntry]
  delete: []
}>()

const isEditing = computed(() => !!props.entry)

const entryType = ref<CalendarEntry['type']>(
  props.entry?.type ?? 'SimpleCalendarEntry'
)
const title = ref(props.entry?.title ?? '')
const description = ref(props.entry?.description ?? '')

const defaultDate = new Date().toISOString().split('T')[0]!
const startDate = ref(
  props.entry ? props.entry.start.split('T')[0]! : defaultDate
)
const startTime = ref(
  props.entry
    ? (props.entry.start.split('T')[1]?.slice(0, 5) ?? '19:00')
    : '19:00'
)
const endDate = ref(props.entry ? props.entry.end.split('T')[0]! : defaultDate)
const endTime = ref(
  props.entry
    ? (props.entry.end.split('T')[1]?.slice(0, 5) ?? '21:00')
    : '21:00'
)

const eventId = ref<string[]>(props.entry ? [props.entry.event.id] : [])
const isReplay = ref(
  props.entry?.type === 'EpisodeCalendarEntry' ? props.entry.isReplay : false
)

const submitted = ref(false)

const { calendarEvents } = useCalendarEvents()

const eventOptions = computed(() =>
  calendarEvents.value.map((e) => ({
    label: e.title,
    value: e.id
  }))
)

const typeItems = [
  {
    label: 'Arrangement',
    value: 'SimpleCalendarEntry',
    icon: 'tabler:broadcast'
  },
  {
    label: 'Episode',
    value: 'EpisodeCalendarEntry',
    icon: 'tabler:player-play'
  },
  {
    label: 'Sesong',
    value: 'SeasonCalendarEntry',
    icon: 'tabler:sparkles'
  }
]

const startDateTime = computed(
  () => `${startDate.value}T${startTime.value}:00Z`
)
const endDateTime = computed(() => `${endDate.value}T${endTime.value}:00Z`)

const isEndAfterStart = computed(() => {
  return new Date(endDateTime.value) > new Date(startDateTime.value)
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    description: !description.value.trim()
      ? 'Beskrivelse er påkrevd'
      : undefined,
    event: eventId.value.length === 0 ? 'Velg en hendelse' : undefined,
    end: !isEndAfterStart.value
      ? 'Sluttidspunkt må være etter starttidspunkt'
      : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

const selectedEvent = computed(() =>
  calendarEvents.value.find((e) => e.id === eventId.value[0])
)

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  const event = selectedEvent.value!
  const base = {
    id: props.entry?.id ?? crypto.randomUUID(),
    title: title.value.trim(),
    description: description.value.trim(),
    start: startDateTime.value,
    end: endDateTime.value,
    event
  }

  let entry: CalendarEntry
  if (entryType.value === 'EpisodeCalendarEntry') {
    entry = { ...base, type: 'EpisodeCalendarEntry', isReplay: isReplay.value }
  } else if (entryType.value === 'SeasonCalendarEntry') {
    entry = { ...base, type: 'SeasonCalendarEntry' }
  } else {
    entry = { ...base, type: 'SimpleCalendarEntry' }
  }

  emit('submit', entry)
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett oppføringen?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}
</script>

<template>
  <div class="flex flex-col">
    <div class="flex flex-col gap-4 py-6">
      <div>
        <label
          class="text-caption-1 text-text-hint mb-2 block font-medium tracking-wide uppercase"
        >
          Type
        </label>
        <DesignSegmentGroup v-model="entryType" :items="typeItems" />
      </div>

      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Navn på kalenderoppføringen"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="description"
        label="Beskrivelse"
        placeholder="Kort beskrivelse"
        :rows="3"
        required
        :invalid="!!errors.description"
        :error-text="errors.description"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Tidspunkt
      </h3>
      <div class="flex gap-4">
        <div class="flex-1">
          <DesignDatePicker v-model="startDate" label="Startdato" />
        </div>
        <div class="flex-1">
          <DesignInput v-model="startTime" label="Starttid" type="time" />
        </div>
      </div>
      <div class="flex gap-4">
        <div class="flex-1">
          <DesignDatePicker
            v-model="endDate"
            label="Sluttdato"
            :invalid="!!errors.end"
            :error-text="errors.end"
          />
        </div>
        <div class="flex-1">
          <DesignInput v-model="endTime" label="Sluttid" type="time" />
        </div>
      </div>
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Hendelse
      </h3>
      <div class="flex flex-col gap-1">
        <DesignSelect
          v-model="eventId"
          :items="eventOptions"
          placeholder="Velg hendelse"
        />
        <p v-if="errors.event" class="text-caption-1 text-semantic-error mt-1">
          {{ errors.event }}
        </p>
      </div>
    </div>

    <Transition
      enter-active-class="transition-all duration-300 ease-out-expo overflow-hidden"
      leave-active-class="transition-all duration-200 ease-out-expo overflow-hidden"
      enter-from-class="max-h-0 opacity-0"
      enter-to-class="max-h-40 opacity-100"
      leave-from-class="max-h-40 opacity-100"
      leave-to-class="max-h-0 opacity-0"
    >
      <div
        v-if="entryType === 'EpisodeCalendarEntry'"
        class="border-border-1 flex flex-col gap-4 border-t py-6"
      >
        <h3
          class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
        >
          Episode-innstillinger
        </h3>
        <DesignSwitch v-model="isReplay" label="Reprise" />
      </div>
    </Transition>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/calendar/entries')"
      >
        Avbryt
      </DesignButton>
      <div v-if="isEditing" class="ml-auto">
        <DesignButton
          variant="tertiary"
          intent="danger"
          icon="tabler:trash"
          @click="handleDelete"
        >
          Slett
        </DesignButton>
      </div>
    </div>
  </div>
</template>
