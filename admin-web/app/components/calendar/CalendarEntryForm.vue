<script setup lang="ts">
const props = defineProps<{
  entry?: CalendarEntry
}>()

const emit = defineEmits<{
  submit: [data: CalendarEntry]
  delete: []
}>()

const isEditing = computed(() => !!props.entry)

const status = defineModel<Status>('status', { default: 'draft' })

const { calendarEvents } = useCalendarEvents()

const entryType = ref<CalendarEntryType>(
  props.entry?.type ?? 'SimpleCalendarEntry'
)
const title = ref(props.entry?.title ?? '')
const description = ref(props.entry?.description ?? '')

const defaultDate = new Date().toISOString().split('T')[0]!

function datePart(value: string | undefined, fallback: string) {
  return value?.split('T')[0] ?? fallback
}
function timePart(value: string | undefined, fallback: string) {
  return value?.split('T')[1]?.slice(0, 5) ?? fallback
}

const startDate = ref(datePart(props.entry?.start, defaultDate))
const startTime = ref(timePart(props.entry?.start, '19:00'))
const endDate = ref(datePart(props.entry?.end, defaultDate))
const endTime = ref(timePart(props.entry?.end, '21:00'))

const eventId = ref<string[]>(props.entry ? [props.entry.event.id] : [])

function initialLinkId(entry: CalendarEntry | undefined): string[] {
  if (!entry) return []
  if (entry.type === 'EpisodeCalendarEntry') return [entry.episodeId]
  if (entry.type === 'SeasonCalendarEntry') return [entry.seasonId]
  if (entry.type === 'ShowCalendarEntry') return [entry.showId]
  return []
}

const linkId = ref<string[]>(initialLinkId(props.entry))
const isReplay = ref(
  props.entry?.type === 'EpisodeCalendarEntry' ? props.entry.isReplay : false
)

const imageUrl = ref(props.entry?.imageUrl ?? '')
const imageFromLink = ref(props.entry?.imageFromLink ?? true)

const bufferEnabled = ref((props.entry?.buffer.availableHours ?? 0) > 0)
const bufferHours = ref(
  (props.entry?.buffer.availableHours ?? 24).toString()
)
const bufferOverride = ref(
  !!(props.entry?.buffer.start || props.entry?.buffer.end)
)
const bufferStartTime = ref(timePart(props.entry?.buffer.start ?? undefined, '18:30'))
const bufferEndTime = ref(timePart(props.entry?.buffer.end ?? undefined, '21:30'))

const submitted = ref(false)

const typeItems = [
  { label: 'Direkte', value: 'SimpleCalendarEntry', icon: 'tabler:broadcast' },
  {
    label: 'Episode',
    value: 'EpisodeCalendarEntry',
    icon: 'tabler:player-play'
  },
  { label: 'Sesong', value: 'SeasonCalendarEntry', icon: 'tabler:stack-2' },
  { label: 'Serie', value: 'ShowCalendarEntry', icon: 'tabler:device-tv' }
]

const eventOptions = computed(() =>
  calendarEvents.value.map((e) => ({ label: e.title, value: e.id }))
)

const isLinked = computed(() => entryType.value !== 'SimpleCalendarEntry')

const startDateTime = computed(
  () => `${startDate.value}T${startTime.value}:00Z`
)
const endDateTime = computed(() => `${endDate.value}T${endTime.value}:00Z`)

const isEndAfterStart = computed(
  () => new Date(endDateTime.value) > new Date(startDateTime.value)
)

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    description: !description.value.trim()
      ? 'Beskrivelse er påkrevd'
      : undefined,
    event: eventId.value.length === 0 ? 'Velg en hendelse' : undefined,
    link:
      isLinked.value && !linkId.value[0]
        ? 'Velg hva oppføringen skal peke på'
        : undefined,
    end: !isEndAfterStart.value
      ? 'Sluttidspunkt må være etter starttidspunkt'
      : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

const selectedEvent = computed(() =>
  calendarEvents.value.find((e) => e.id === eventId.value[0])
)

function buildBuffer(): CalendarEntryBuffer {
  if (!bufferEnabled.value) return { ...noBuffer }
  return {
    availableHours: parseInt(bufferHours.value) || 0,
    start: bufferOverride.value
      ? `${startDate.value}T${bufferStartTime.value}:00Z`
      : null,
    end: bufferOverride.value
      ? `${endDate.value}T${bufferEndTime.value}:00Z`
      : null
  }
}

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  const base = {
    id: props.entry?.id ?? crypto.randomUUID(),
    status: status.value,
    title: title.value.trim(),
    description: description.value.trim(),
    start: startDateTime.value,
    end: endDateTime.value,
    event: selectedEvent.value!,
    imageUrl: imageFromLink.value ? null : imageUrl.value.trim() || null,
    imageFromLink: isLinked.value ? imageFromLink.value : false,
    buffer: buildBuffer()
  }

  const target = linkId.value[0]!

  let entry: CalendarEntry
  switch (entryType.value) {
    case 'EpisodeCalendarEntry':
      entry = {
        ...base,
        type: 'EpisodeCalendarEntry',
        episodeId: target,
        isReplay: isReplay.value
      }
      break
    case 'SeasonCalendarEntry':
      entry = { ...base, type: 'SeasonCalendarEntry', seasonId: target }
      break
    case 'ShowCalendarEntry':
      entry = { ...base, type: 'ShowCalendarEntry', showId: target }
      break
    default:
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
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Type</label>
        <DesignSegmentGroup v-model="entryType" :items="typeItems" />
      </div>

      <CalendarLinkField
        v-model="linkId"
        :type="entryType"
        :invalid="errors.link"
      />

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

    <div class="border-border-1 flex flex-col gap-2 border-t py-6">
      <label class="text-body-3 text-text-muted block">Hendelse</label>
      <DesignSelect
        v-model="eventId"
        :items="eventOptions"
        placeholder="Velg hendelse"
      />
      <p v-if="errors.event" class="text-caption-1 text-semantic-error mt-1">
        {{ errors.event }}
      </p>
    </div>

    <div
      v-if="entryType === 'EpisodeCalendarEntry'"
      class="border-border-1 border-t py-6"
    >
      <DesignSwitch v-model="isReplay" label="Reprise" />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Bilde
      </h3>
      <DesignSwitch
        v-if="isLinked"
        v-model="imageFromLink"
        label="Bruk bildet fra det oppføringen peker på"
      />
      <DesignInput
        v-if="!isLinked || !imageFromLink"
        v-model="imageUrl"
        label="Bilde-URL"
        placeholder="/images/entry.jpg"
        type="url"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Start forfra
      </h3>
      <DesignSwitch
        v-model="bufferEnabled"
        label="La seere starte sendingen forfra"
      />

      <template v-if="bufferEnabled">
        <div class="w-48">
          <DesignInput
            v-model="bufferHours"
            label="Tilgjengelig i (timer)"
            placeholder="24"
            helper-text="Etter at oppføringen er ferdig."
          />
        </div>

        <DesignSwitch
          v-model="bufferOverride"
          label="Overstyr start- og sluttid for opptaket"
        />

        <div v-if="bufferOverride" class="flex gap-4">
          <div class="flex-1">
            <DesignInput
              v-model="bufferStartTime"
              label="Opptak starter"
              type="time"
            />
          </div>
          <div class="flex-1">
            <DesignInput
              v-model="bufferEndTime"
              label="Opptak slutter"
              type="time"
            />
          </div>
        </div>
      </template>
    </div>

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
