<script setup lang="ts">
const props = defineProps<{
  event?: CalendarEvent
}>()

const emit = defineEmits<{
  submit: [data: CalendarEvent]
  delete: []
}>()

const isEditing = computed(() => !!props.event)

const title = ref(props.event?.title ?? '')

const defaultDate = new Date().toISOString().split('T')[0]!
const startDate = ref(
  props.event ? props.event.start.split('T')[0]! : defaultDate
)
const endDate = ref(props.event ? props.event.end.split('T')[0]! : defaultDate)
const image = ref(props.event?.image ?? '')

const submitted = ref(false)

const isEndAfterStart = computed(() => {
  return new Date(endDate.value) >= new Date(startDate.value)
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    end: !isEndAfterStart.value
      ? 'Sluttdato må være lik eller etter startdato'
      : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    id: props.event?.id ?? crypto.randomUUID(),
    title: title.value.trim(),
    start: `${startDate.value}T00:00:00Z`,
    end: `${endDate.value}T23:59:59Z`,
    image: image.value.trim()
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett hendelsen?',
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
        placeholder="Navn på hendelsen"
        required
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignInput
        v-model="image"
        label="Bilde-URL"
        placeholder="/images/event.jpg"
        type="url"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Periode
      </h3>
      <div class="flex gap-4">
        <div class="flex-1">
          <DesignDatePicker v-model="startDate" label="Startdato" />
        </div>
        <div class="flex-1">
          <DesignDatePicker
            v-model="endDate"
            label="Sluttdato"
            :invalid="!!errors.end"
            :error-text="errors.end"
          />
        </div>
      </div>
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/calendar/events')"
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
