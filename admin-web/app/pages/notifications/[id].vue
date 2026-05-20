<script setup lang="ts">
const route = useRoute()
const { notifications, update, remove } = useNotifications()
const toaster = useToast()

const formRef = useTemplateRef<{
  title: string
  body: string
  applicationCodes: string[]
}>('formRef')

const notification = computed(() =>
  notifications.value.find((n) => n.id === route.params.id)
)

useHead({ title: () => notification.value?.title ?? 'Rediger varsling' })

function handleSubmit(data: {
  title: string
  body: string
  applicationCodes: string[]
  recipientGroup: string
  status: PushNotification['status']
  scheduledAt: string | null
}) {
  const id = route.params.id as string
  update(id, {
    applicationCode: data.applicationCodes[0] ?? 'bccm-mobile',
    title: data.title,
    body: data.body,
    status: data.status,
    recipientCount:
      data.status === 'sent' ? Math.floor(Math.random() * 10000) : 0,
    recipientGroup: data.recipientGroup,
    sentAt: data.status === 'sent' ? new Date().toISOString() : null,
    scheduledAt: data.scheduledAt
  })
  toaster.value.success({
    title: 'Varsling oppdatert',
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
    <div class="flex max-w-5xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/notifications" label="Tilbake til push-varsler" />
        <div class="flex items-center justify-between">
          <h1 class="text-heading-2 text-text-default">Rediger varsling</h1>
        </div>
      </div>

      <NotificationForm
        ref="formRef"
        :notification="notification"
        @submit="handleSubmit"
        @delete="handleDelete"
      />
    </div>

    <aside class="hidden lg:block">
      <NotificationDevicePreview
        :title="formRef?.title ?? notification.title"
        :body="formRef?.body ?? notification.body"
        :application-code="
          formRef?.applicationCodes?.[0] ?? notification.applicationCode
        "
      />
    </aside>
  </div>

  <div v-else class="text-body-2 text-text-hint px-4 py-12 text-center">
    Varslingen ble ikke funnet.
  </div>
</template>
