<script setup lang="ts">
const props = defineProps<{
  season?: Season
}>()

const emit = defineEmits<{
  submit: [data: Season]
  delete: []
}>()

const isEditing = computed(() => !!props.season)

const { shows } = useShows()

const status = defineModel<Status>('status', { default: 'draft' })

const title = ref(props.season?.title ?? '')
const description = ref(props.season?.description ?? '')
const imageUrl = ref(props.season?.imageUrl ?? '')
const number = ref(props.season?.number?.toString() ?? '')
const ageRating = ref(props.season?.ageRating ?? 'A')
const showId = ref<string[]>(props.season ? [props.season.show.id] : [])

const submitted = ref(false)

const showOptions = computed(() =>
  shows.value.map((s) => ({ label: s.title, value: s.id }))
)

const ageRatings = ['A', '6', '9', '12', '15', '18', 'U']

const selectedShow = computed(() =>
  shows.value.find((s) => s.id === showId.value[0])
)

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    number: !number.value.trim() ? 'Sesongsnummer er påkrevd' : undefined,
    show: showId.value.length === 0 ? 'Velg en serie' : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  const show = selectedShow.value!
  emit('submit', {
    id: props.season?.id ?? crypto.randomUUID(),
    legacyID: props.season?.legacyID ?? null,
    title: title.value.trim(),
    description: description.value.trim(),
    imageUrl: imageUrl.value.trim() || null,
    number: parseInt(number.value),
    ageRating: ageRating.value,
    status: status.value,
    show: { id: show.id, title: show.title }
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett sesongen?',
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
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Navn på sesongen"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="description"
        label="Beskrivelse"
        placeholder="Kort beskrivelse av sesongen"
        :rows="3"
      />
      <DesignInput
        v-model="imageUrl"
        label="Bilde-URL"
        placeholder="/images/season.jpg"
        type="url"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <div class="flex items-start gap-4">
        <div class="flex flex-col gap-1">
          <label class="text-body-3 text-text-muted block">Serie</label>
          <DesignSelect
            v-model="showId"
            :items="showOptions"
            placeholder="Velg serie"
          />
          <p v-if="errors.show" class="text-caption-1 text-semantic-error mt-1">
            {{ errors.show }}
          </p>
        </div>
        <div class="w-32">
          <DesignInput
            v-model="number"
            label="Sesong nr."
            placeholder="1"
            required
            :invalid="!!errors.number"
            :error-text="errors.number"
          />
        </div>
      </div>
    </div>

    <div class="border-border-1 flex gap-8 border-t py-6">
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Aldersgrense</label>
        <DesignAgeRatingPicker v-model="ageRating" :ratings="ageRatings" />
      </div>
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/seasons')"
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
