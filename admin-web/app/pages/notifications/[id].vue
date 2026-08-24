<script setup lang="ts">
const route = useRoute()
const { notifications, update, remove } = useNotifications()
const toaster = useToast()

const notification = computed(() =>
  notifications.value.find((n) => n.id === route.params.id)
)

useHead({ title: () => notification.value?.title ?? 'Rediger varsling' })

const state = computed(() =>
  notification.value ? notificationState(notification.value) : 'draft'
)

const draft = ref<NotificationDraft>({
  title: notification.value?.title ?? '',
  body: notification.value?.body ?? '',
  appGroupId: notification.value?.appGroupId ?? '',
  highPriority: notification.value?.highPriority ?? false
})

function handleSubmit(data: NotificationSubmit) {
  const now = new Date().toISOString()
  update(route.params.id as string, {
    title: data.title,
    body: data.body,
    appGroupId: data.appGroupId,
    targetIds: data.targetIds,
    highPriority: data.highPriority,
    action: data.action,
    deepLink: data.deepLink,
    scheduleAt: data.scheduleAt,
    sendStarted: data.sendNow ? now : null,
    sendCompleted: data.sendNow ? now : null,
    recipientCount: data.sendNow ? Math.floor(Math.random() * 10000) : 0
  })
  toaster.value.success({
    title: data.sendNow ? 'Varsling sendt' : 'Varsling oppdatert',
    description: 'Endringene ble lagret.'
  })
  navigateTo('/notifications')
}

function handleDelete() {
  remove(route.params.id as string)
  toaster.value.success({
    title: 'Varsling slettet',
    description: 'Varslingen ble fjernet.'
  })
  navigateTo('/notifications')
}
</script>

<template>
  <div v-if="notification" class="flex gap-10">
    <div class="flex max-w-2xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/notifications" label="Tilbake til push-varsler" />
        <div class="flex items-center justify-between gap-4">
          <h1 class="text-heading-2 text-text-default">Rediger varsling</h1>
          <DesignStatusIndicator
            :variant="notificationStateConfig[state].variant"
          >
            {{ notificationStateConfig[state].label }}
          </DesignStatusIndicator>
        </div>
      </div>

      <NotificationForm
        :notification="notification"
        @submit="handleSubmit"
        @delete="handleDelete"
        @change="draft = $event"
      />
    </div>

    <aside class="hidden lg:block">
      <NotificationDevicePreview
        :title="draft.title"
        :body="draft.body"
        :app-group-id="draft.appGroupId"
        :high-priority="draft.highPriority"
      />
    </aside>
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Varslingen ble ikke funnet.
  </div>
</template>
