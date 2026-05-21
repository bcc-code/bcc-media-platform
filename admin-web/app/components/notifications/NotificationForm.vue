<script setup lang="ts">
const props = defineProps<{
  notification?: PushNotification
}>()

const emit = defineEmits<{
  submit: [
    data: {
      title: string
      body: string
      applicationCodes: string[]
      recipientGroup: string
      status: PushNotification['status']
      scheduledAt: string | null
    }
  ]
  delete: []
}>()

const isEditing = computed(() => !!props.notification)
const isSent = computed(
  () =>
    props.notification?.status === 'sent' ||
    props.notification?.status === 'failed'
)

const title = ref(props.notification?.title ?? '')
const body = ref(props.notification?.body ?? '')
const applicationCodes = ref<string[]>(
  props.notification ? [props.notification.applicationCode] : []
)
const recipientGroup = ref<string[]>(
  props.notification ? [props.notification.recipientGroup] : []
)
const sendMode = ref<'now' | 'scheduled'>(
  props.notification?.scheduledAt ? 'scheduled' : 'now'
)

const tomorrow = new Date()
tomorrow.setDate(tomorrow.getDate() + 1)
const defaultDate = tomorrow.toISOString().split('T')[0]!

const scheduledDate = ref(
  props.notification?.scheduledAt
    ? props.notification.scheduledAt.split('T')[0]!
    : defaultDate
)
const scheduledTime = ref(
  props.notification?.scheduledAt
    ? (props.notification.scheduledAt.split('T')[1]?.slice(0, 5) ?? '09:00')
    : '09:00'
)

const submitted = ref(false)

const appOptions = mockApplications.map((app) => ({
  label: applicationLabel(app.code),
  value: app.code
}))

const recipientGroupOptions = [
  { label: 'Alle', value: 'Alle' },
  { label: 'Abonnenter', value: 'Abonnenter' }
]

const scheduledDateTime = computed(() => {
  if (sendMode.value !== 'scheduled') return null
  return `${scheduledDate.value}T${scheduledTime.value}:00Z`
})

const isScheduleInFuture = computed(() => {
  if (sendMode.value !== 'scheduled') return true
  const dt = new Date(scheduledDateTime.value!)
  return dt > new Date()
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    body: !body.value.trim() ? 'Melding er påkrevd' : undefined,
    applicationCodes:
      applicationCodes.value.length === 0 ? 'Velg minst en app' : undefined,
    recipientGroup:
      recipientGroup.value.length === 0 ? 'Velg en mottakergruppe' : undefined,
    scheduledDate:
      sendMode.value === 'scheduled' && !isScheduleInFuture.value
        ? 'Tidspunktet må vaere i fremtiden'
        : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

const primaryLabel = computed(() => {
  if (sendMode.value === 'scheduled') return 'Planlegg varsling'
  return 'Send varsling'
})

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    title: title.value.trim(),
    body: body.value.trim(),
    applicationCodes: applicationCodes.value,
    recipientGroup: recipientGroup.value[0] ?? 'Alle',
    status: sendMode.value === 'scheduled' ? 'scheduled' : 'sent',
    scheduledAt: scheduledDateTime.value
  })
}

function handleDraft() {
  submitted.value = true
  if (!title.value.trim()) return

  emit('submit', {
    title: title.value.trim(),
    body: body.value.trim(),
    applicationCodes: applicationCodes.value,
    recipientGroup: recipientGroup.value[0] ?? 'Alle',
    status: 'draft',
    scheduledAt: null
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett varsling?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}

defineExpose({ title, body, applicationCodes })
</script>

<template>
  <div class="flex flex-col">
    <DesignBanner v-if="isSent" variant="info" icon="tabler:info-circle">
      Denne varslingen er allerede sendt og kan ikke redigeres.
    </DesignBanner>

    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Skriv tittel på varslingen"
        required
        :disabled="isSent"
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="body"
        label="Melding"
        placeholder="Skriv meldingsteksten"
        :rows="3"
        required
        :disabled="isSent"
        :invalid="!!errors.body"
        :error-text="errors.body"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Mottakere
      </h3>
      <div class="flex gap-4">
        <div class="flex flex-col gap-1">
          <label class="text-body-3 text-text-muted block">Apper</label>
          <DesignSelect
            v-model="applicationCodes"
            :items="appOptions"
            placeholder="Velg apper"
          />
          <p
            v-if="errors.applicationCodes"
            class="text-caption-1 text-semantic-error mt-1"
          >
            {{ errors.applicationCodes }}
          </p>
        </div>
        <div class="flex flex-col gap-1">
          <label class="text-body-3 text-text-muted block"
            >Mottakergruppe</label
          >
          <DesignSelect
            v-model="recipientGroup"
            :items="recipientGroupOptions"
            placeholder="Velg gruppe"
          />
          <p
            v-if="errors.recipientGroup"
            class="text-caption-1 text-semantic-error mt-1"
          >
            {{ errors.recipientGroup }}
          </p>
        </div>
      </div>
    </div>

    <div
      v-if="!isSent"
      class="border-border-1 flex flex-col items-start gap-4 border-t py-6"
    >
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Sending
      </h3>
      <DesignSegmentGroup
        v-model="sendMode"
        :items="[
          { label: 'Send nå', value: 'now', icon: 'tabler:send' },
          { label: 'Planlegg', value: 'scheduled', icon: 'tabler:clock' }
        ]"
      />
      <Transition
        enter-active-class="transition-all duration-300 ease-out-expo overflow-hidden"
        leave-active-class="transition-all duration-200 ease-out-expo overflow-hidden"
        enter-from-class="max-h-0 opacity-0"
        enter-to-class="max-h-40 opacity-100"
        leave-from-class="max-h-40 opacity-100"
        leave-to-class="max-h-0 opacity-0"
      >
        <div v-if="sendMode === 'scheduled'" class="flex gap-4">
          <div class="flex-1">
            <DesignDatePicker
              v-model="scheduledDate"
              label="Dato"
              :invalid="!!errors.scheduledDate"
              :error-text="errors.scheduledDate"
            />
          </div>
          <div class="flex-1">
            <DesignInput
              v-model="scheduledTime"
              label="Tidspunkt"
              type="time"
            />
          </div>
        </div>
      </Transition>
    </div>

    <div
      v-if="!isSent"
      class="border-border-1 flex items-center gap-3 border-t pt-6"
    >
      <DesignButton @click="handleSubmit">
        {{ primaryLabel }}
      </DesignButton>
      <DesignButton variant="secondary" @click="handleDraft">
        {{ isEditing ? 'Lagre endringer' : 'Lagre utkast' }}
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
