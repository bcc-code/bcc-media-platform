<script setup lang="ts">
const props = defineProps<{
  page: Page
}>()

const emit = defineEmits<{
  save: [data: { code: string; title: string; description: string | null; applicationCode: string }]
}>()

const open = defineModel<boolean>('open', { default: false })

const code = ref(props.page.code)
const title = ref(props.page.title)
const description = ref(props.page.description ?? '')
const applicationCode = ref<string[]>([props.page.applicationCode])

const submitted = ref(false)

// Reset to the saved values every time the dialog opens.
watch(open, (isOpen) => {
  if (!isOpen) return
  code.value = props.page.code
  title.value = props.page.title
  description.value = props.page.description ?? ''
  applicationCode.value = [props.page.applicationCode]
  submitted.value = false
})

const appOptions = mockApplications.map((a) => ({
  label: applicationLabel(a.code),
  value: a.code
}))

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    code: !code.value.trim() ? 'Kode er påkrevd' : undefined,
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function save() {
  submitted.value = true
  if (hasErrors.value) return
  emit('save', {
    code: code.value.trim(),
    title: title.value.trim(),
    description: description.value.trim() || null,
    applicationCode: applicationCode.value[0] ?? props.page.applicationCode
  })
  open.value = false
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    title="Sideinnstillinger"
    description="Kode og tittel for siden"
  >
    <template #default="{ initialFocus }">
      <div class="flex flex-col gap-4">
        <DesignInput
          :ref="initialFocus"
          v-model="title"
          label="Tittel"
          placeholder="Hjem"
          required
          :invalid="!!errors.title"
          :error-text="errors.title"
        />
        <DesignInput
          v-model="code"
          label="Kode"
          placeholder="home"
          required
          helper-text="Brukes av appene for å finne siden."
          :invalid="!!errors.code"
          :error-text="errors.code"
        />
        <DesignTextarea
          v-model="description"
          label="Beskrivelse"
          placeholder="Valgfri beskrivelse"
          :rows="2"
        />
        <div class="flex flex-col gap-1">
          <label class="text-body-3 text-text-muted block">App</label>
          <DesignSelect v-model="applicationCode" :items="appOptions" />
        </div>

        <div class="flex items-center gap-3 pt-2">
          <DesignButton @click="save">Lagre</DesignButton>
          <DesignButton variant="secondary" @click="open = false">
            Avbryt
          </DesignButton>
        </div>
      </div>
    </template>
  </DesignDialog>
</template>
