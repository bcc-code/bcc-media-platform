<script setup lang="ts">
const props = defineProps<{
  notification?: PushNotification
}>()

const emit = defineEmits<{
  submit: [data: NotificationSubmit]
  delete: []
  change: [draft: NotificationDraft]
}>()

const isEditing = computed(() => !!props.notification)

const state = computed(() =>
  props.notification ? notificationState(props.notification) : 'draft'
)
// Once the send job has started there is nothing left to edit.
const isLocked = computed(
  () => state.value === 'sent' || state.value === 'sending'
)

const title = ref(props.notification?.title ?? '')
const body = ref(props.notification?.body ?? '')
const appGroupId = ref<string[]>(
  props.notification ? [props.notification.appGroupId] : []
)
const targetIds = ref<string[]>([...(props.notification?.targetIds ?? [])])
const highPriority = ref(props.notification?.highPriority ?? false)
const action = ref<NotificationAction>(props.notification?.action ?? 'none')
const deepLink = ref(props.notification?.deepLink ?? '')

const sendMode = ref<'now' | 'scheduled'>(
  props.notification?.scheduleAt ? 'scheduled' : 'now'
)

const tomorrow = new Date()
tomorrow.setDate(tomorrow.getDate() + 1)
const defaultDate = tomorrow.toISOString().split('T')[0]!

const scheduledDate = ref(
  props.notification?.scheduleAt?.split('T')[0] ?? defaultDate
)
const scheduledTime = ref(
  props.notification?.scheduleAt?.split('T')[1]?.slice(0, 5) ?? '09:00'
)

const submitted = ref(false)

const appGroupOptions = mockApplicationGroups.map((g) => ({
  label: g.label,
  value: g.id
}))

const targetItems = mockTargets.map((t) => ({ label: t.label, value: t.id }))

const actionItems = [
  { label: 'Ingen', value: 'none', icon: 'tabler:circle-off' },
  { label: 'Åpne innhold', value: 'deep_link', icon: 'tabler:link' },
  { label: 'Tøm cache', value: 'clear_cache', icon: 'tabler:refresh' }
]

const scheduledDateTime = computed(() => {
  if (sendMode.value !== 'scheduled') return null
  return `${scheduledDate.value}T${scheduledTime.value}:00Z`
})

const isScheduleInFuture = computed(() => {
  if (sendMode.value !== 'scheduled') return true
  return new Date(scheduledDateTime.value!) > new Date()
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    title: !title.value.trim() ? 'Tittel er påkrevd' : undefined,
    body: !body.value.trim() ? 'Melding er påkrevd' : undefined,
    appGroupId: appGroupId.value.length === 0 ? 'Velg en app' : undefined,
    deepLink:
      action.value === 'deep_link' && !deepLink.value.trim()
        ? 'Lenke er påkrevd'
        : undefined,
    scheduledDate: !isScheduleInFuture.value
      ? 'Tidspunktet må være i fremtiden'
      : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

const primaryLabel = computed(() =>
  sendMode.value === 'scheduled' ? 'Planlegg varsling' : 'Send varsling'
)

function payload(overrides: Partial<NotificationSubmit>): NotificationSubmit {
  return {
    title: title.value.trim(),
    body: body.value.trim(),
    appGroupId: appGroupId.value[0] ?? '',
    targetIds: [...targetIds.value],
    highPriority: highPriority.value,
    action: action.value,
    deepLink: action.value === 'deep_link' ? deepLink.value.trim() : null,
    scheduleAt: scheduledDateTime.value,
    sendNow: false,
    ...overrides
  }
}

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return
  emit('submit', payload({ sendNow: sendMode.value === 'now' }))
}

function handleDraft() {
  submitted.value = true
  if (!title.value.trim()) return
  emit('submit', payload({ scheduleAt: null, sendNow: false }))
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

watch(
  [title, body, appGroupId, highPriority],
  () =>
    emit('change', {
      title: title.value,
      body: body.value,
      appGroupId: appGroupId.value[0] ?? '',
      highPriority: highPriority.value
    }),
  { immediate: true }
)
</script>

<template>
  <div class="flex flex-col">
    <DesignBanner v-if="isLocked" variant="info" icon="tabler:info-circle">
      Denne varslingen er allerede sendt og kan ikke redigeres.
    </DesignBanner>

    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="title"
        label="Tittel"
        placeholder="Skriv tittel på varslingen"
        required
        :disabled="isLocked"
        :invalid="!!errors.title"
        :error-text="errors.title"
      />
      <DesignTextarea
        v-model="body"
        label="Melding"
        placeholder="Skriv meldingsteksten"
        :rows="3"
        required
        :disabled="isLocked"
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

      <div class="flex flex-col gap-1">
        <label class="text-body-3 text-text-muted block">App</label>
        <DesignSelect
          v-model="appGroupId"
          :items="appGroupOptions"
          placeholder="Velg app"
        />
        <p
          v-if="errors.appGroupId"
          class="text-caption-1 text-semantic-error mt-1"
        >
          {{ errors.appGroupId }}
        </p>
      </div>

      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Begrens til</label>
        <DesignToggleChips
          v-model="targetIds"
          :items="targetItems"
          :disabled="isLocked"
        />
        <p class="text-caption-1 text-text-hint">
          {{
            targetIds.length === 0
              ? 'Uten begrensninger går varselet til alle i appen.'
              : targetIds
                  .map((id) => mockTargets.find((t) => t.id === id))
                  .filter(Boolean)
                  .map((t) => `${t!.label}: ${targetSummary(t!)}`)
                  .join(' — ')
          }}
        </p>
      </div>
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <h3
        class="text-caption-1 text-text-hint font-medium tracking-wide uppercase"
      >
        Handling
      </h3>
      <DesignSegmentGroup
        v-model="action"
        :items="actionItems"
        :class="isLocked ? 'pointer-events-none opacity-50' : ''"
      />
      <DesignInput
        v-if="action === 'deep_link'"
        v-model="deepLink"
        label="Lenke"
        placeholder="bccm://episode/123"
        :disabled="isLocked"
        :invalid="!!errors.deepLink"
        :error-text="errors.deepLink"
      />
      <div class="flex items-start justify-between gap-6">
        <div>
          <p class="text-title-3 text-text-default">Høy prioritet</p>
          <p class="text-body-3 text-text-muted mt-1">
            Leveres umiddelbart, også når enheten sparer strøm.
          </p>
        </div>
        <DesignSwitch v-model="highPriority" :disabled="isLocked" />
      </div>
    </div>

    <div
      v-if="!isLocked"
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
        <div v-if="sendMode === 'scheduled'" class="flex w-full gap-4">
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
      v-if="!isLocked"
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
