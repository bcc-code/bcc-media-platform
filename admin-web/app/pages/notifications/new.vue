<script setup lang="ts">
useHead({ title: 'Ny varsling' })

const { add } = useNotifications()
const toaster = useToast()

const draft = ref<NotificationDraft>({
  title: '',
  body: '',
  appGroupId: '',
  highPriority: false
})

function handleSubmit(data: NotificationSubmit) {
  const now = new Date().toISOString()
  add({
    id: crypto.randomUUID(),
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
    recipientCount: data.sendNow ? Math.floor(Math.random() * 10000) : 0,
    createdAt: now
  })
  toaster.value.success({
    title: data.sendNow ? 'Varsling sendt' : 'Varsling lagret',
    description: data.scheduleAt
      ? 'Varslingen er planlagt.'
      : data.sendNow
        ? 'Varslingen ble sendt.'
        : 'Varslingen ble lagret som utkast.'
  })
  navigateTo('/notifications')
}
</script>

<template>
  <div class="flex gap-10">
    <div class="flex max-w-2xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/notifications" label="Tilbake til push-varsler" />
        <h1 class="text-heading-2 text-text-default">Ny varsling</h1>
      </div>

      <NotificationForm @submit="handleSubmit" @change="draft = $event" />
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
</template>
