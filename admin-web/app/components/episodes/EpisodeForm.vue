<script setup lang="ts">
const props = defineProps<{
  episode?: Episode
}>()

const emit = defineEmits<{
  submit: [data: Episode]
  delete: []
}>()

const isEditing = computed(() => !!props.episode)

const status = defineModel<Status>('status', { default: 'draft' })

const { seasons } = useSeasons()

const title = ref(props.episode?.title ?? '')
const description = ref(props.episode?.description ?? '')
const imageUrl = ref(props.episode?.imageUrl ?? '')
const type = ref<EpisodeType>(props.episode?.type ?? 'episode')
const assetId = ref<string | null>(props.episode?.assetId ?? null)
const seasonId = ref<string[]>(
  props.episode ? [props.episode.season?.id ?? ''] : []
)
const number = ref(props.episode?.number?.toString() ?? '')
// Defaults on, because a false value silently excludes the episode from the
// background translation export.
const translationsRequired = ref(props.episode?.translationsRequired ?? true)

function splitDate(value: string | undefined, fallback: string) {
  return value?.split('T')[0] ?? fallback
}

const today = new Date().toISOString().split('T')[0]!

const publishDate = ref(splitDate(props.episode?.publishDate, today))
const publishTime = ref(
  props.episode?.publishDate.split('T')[1]?.slice(0, 5) ?? '10:00'
)
const availableFrom = ref(splitDate(props.episode?.availableFrom, today))
const availableTo = ref(splitDate(props.episode?.availableTo, '2099-12-31'))

const submitted = ref(false)

const typeItems = [
  { label: 'Episode', value: 'episode', icon: 'tabler:list-numbers' },
  { label: 'Frittstående', value: 'standalone', icon: 'tabler:player-play' }
]

const seasonOptions = computed(() =>
  seasons.value.map((s) => ({
    label: `${s.show.title} — Sesong ${s.number}`,
    value: s.id
  }))
)

const selectedSeason = computed(() =>
  seasons.value.find((s) => s.id === seasonId.value[0])
)

const publishDateTime = computed(
  () => `${publishDate.value}T${publishTime.value}:00Z`
)

const availabilityValid = computed(
  () => new Date(availableTo.value) > new Date(availableFrom.value)
)

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    season:
      type.value === 'episode' && !selectedSeason.value
        ? 'Velg en sesong'
        : undefined,
    availableTo: !availabilityValid.value
      ? 'Sluttdato må være etter startdato'
      : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

// The whole point of the flow: you cannot put an episode live without video.
const blockedFromPublishing = computed(
  () => status.value !== 'draft' && assetId.value === null
)

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value || blockedFromPublishing.value) return

  const season = selectedSeason.value
  emit('submit', {
    id: props.episode?.id ?? crypto.randomUUID(),
    uuid: props.episode?.uuid ?? crypto.randomUUID(),
    legacyID: props.episode?.legacyID ?? null,
    status: status.value,
    type: type.value,
    title: title.value.trim(),
    description: description.value.trim(),
    imageUrl: imageUrl.value.trim() || null,
    publishDate: publishDateTime.value,
    availableFrom: `${availableFrom.value}T00:00:00Z`,
    availableTo: `${availableTo.value}T23:59:59Z`,
    assetId: assetId.value,
    translationsRequired: translationsRequired.value,
    number: number.value.trim() ? parseInt(number.value) : null,
    season:
      type.value === 'episode' && season
        ? {
            id: season.id,
            number: season.number,
            show: { id: season.show.id, title: season.show.title }
          }
        : null
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett episoden?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}
</script>

<template>
  <div class="flex flex-col">
    <DesignBanner
      v-if="blockedFromPublishing"
      variant="warning"
      icon="tabler:alert-triangle"
    >
      Episoden mangler video og kan ikke publiseres. Velg en video, eller sett
      status til utkast.
    </DesignBanner>

    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Navn på episoden"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="description"
        label="Beskrivelse"
        placeholder="Kort beskrivelse av episoden"
        :rows="3"
      />
    </div>

    <div class="border-border-1 border-t py-6">
      <EpisodeVideoField
        v-model="assetId"
        :current-episode-id="props.episode?.id"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Type</label>
        <DesignSegmentGroup v-model="type" :items="typeItems" />
      </div>

      <Transition
        enter-active-class="transition-all duration-300 ease-out-expo overflow-hidden"
        leave-active-class="transition-all duration-200 ease-out-expo overflow-hidden"
        enter-from-class="max-h-0 opacity-0"
        enter-to-class="max-h-40 opacity-100"
        leave-from-class="max-h-40 opacity-100"
        leave-to-class="max-h-0 opacity-0"
      >
        <div v-if="type === 'episode'" class="flex items-start gap-4">
          <div class="flex flex-col gap-1">
            <label class="text-body-3 text-text-muted block">Sesong</label>
            <DesignSelect
              v-model="seasonId"
              :items="seasonOptions"
              placeholder="Velg sesong"
            />
            <p
              v-if="errors.season"
              class="text-caption-1 text-semantic-error mt-1"
            >
              {{ errors.season }}
            </p>
          </div>
          <div class="w-32">
            <DesignInput v-model="number" label="Episode nr." placeholder="1" />
          </div>
        </div>
      </Transition>
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Publisering
      </h3>
      <div class="flex gap-4">
        <div class="flex-1">
          <DesignDatePicker
            v-model="publishDate"
            label="Publiseringsdato"
            required
          />
        </div>
        <div class="flex-1">
          <DesignInput v-model="publishTime" label="Tidspunkt" type="time" />
        </div>
      </div>
      <div class="flex gap-4">
        <div class="flex-1">
          <DesignDatePicker v-model="availableFrom" label="Tilgjengelig fra" />
        </div>
        <div class="flex-1">
          <DesignDatePicker
            v-model="availableTo"
            label="Tilgjengelig til"
            :invalid="!!errors.availableTo"
            :error-text="errors.availableTo"
          />
        </div>
      </div>
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <DesignInput
        v-model="imageUrl"
        label="Bilde-URL"
        placeholder="/images/episode.jpg"
        type="url"
      />
      <div class="flex items-start justify-between gap-6">
        <div>
          <p class="text-title-3 text-text-default">Send til oversettelse</p>
          <p class="text-body-3 text-text-muted mt-1">
            Tittel og beskrivelse sendes automatisk til oversetting når episoden
            er publisert.
          </p>
        </div>
        <DesignSwitch v-model="translationsRequired" />
      </div>
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton :disabled="blockedFromPublishing" @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/episodes')"
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
