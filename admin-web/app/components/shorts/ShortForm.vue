<script setup lang="ts">
const props = defineProps<{
  short?: Short
  /** Preselects the source episode when arriving from an episode page. */
  presetEpisodeId?: string
}>()

const emit = defineEmits<{
  submit: [data: Short]
  delete: []
}>()

const isEditing = computed(() => !!props.short)

const status = defineModel<Status>('status', { default: 'draft' })

const { clippableEpisodes, episodeDuration } = useShorts()

const episodeId = ref<string[]>(
  props.short
    ? [props.short.episodeId]
    : props.presetEpisodeId
      ? [props.presetEpisodeId]
      : []
)
const title = ref(props.short?.title ?? '')
const range = ref<number[]>([props.short?.startsAt ?? 0, props.short?.endsAt ?? 30])

const submitted = ref(false)

const episodeOptions = computed(() =>
  clippableEpisodes.value.map((e) => ({
    label: e.season
      ? `${e.season.show.title} S${e.season.number}E${e.number} — ${e.title}`
      : e.title,
    value: e.id
  }))
)

const selectedEpisodeId = computed(() => episodeId.value[0] ?? '')
const duration = computed(() =>
  selectedEpisodeId.value ? episodeDuration(selectedEpisodeId.value) : 0
)

// Pull the range back inside the video whenever the source episode changes.
watch(duration, (value) => {
  if (value === 0) return
  const start = Math.min(range.value[0] ?? 0, Math.max(0, value - 5))
  const end = Math.min(range.value[1] ?? 30, value)
  range.value = [start, Math.max(end, start + 5)]
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    episode: !selectedEpisodeId.value ? 'Velg en episode' : undefined,
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    id: props.short?.id ?? crypto.randomUUID(),
    status: status.value,
    episodeId: selectedEpisodeId.value,
    title: title.value.trim(),
    startsAt: range.value[0] ?? 0,
    endsAt: range.value[1] ?? 0,
    createdAt: props.short?.createdAt ?? new Date().toISOString()
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett shorten?',
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
      <div class="flex flex-col gap-1">
        <label class="text-body-3 text-text-muted block">Hent fra episode</label>
        <DesignSelect
          v-model="episodeId"
          :items="episodeOptions"
          placeholder="Velg episode"
        />
        <p
          v-if="errors.episode"
          class="text-caption-1 text-semantic-error mt-1"
        >
          {{ errors.episode }}
        </p>
        <p class="text-caption-1 text-text-hint mt-1">
          Bare episoder som har video kan klippes.
        </p>
      </div>
    </div>

    <div class="border-border-1 border-t py-6">
      <ShortClipField
        v-model="range"
        :duration="duration"
        :disabled="!selectedEpisodeId"
      />
    </div>

    <div class="border-border-1 border-t py-6">
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Kort tittel som vises på shorten"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett short' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/shorts')"
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
