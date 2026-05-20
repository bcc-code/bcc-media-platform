<script setup lang="ts">
useHead({ title: 'Ny varsling' })

const { add } = useNotifications()
const toaster = useToast()

const formRef = useTemplateRef<{
  title: string
  body: string
  applicationCodes: string[]
}>('formRef')

function handleSubmit(data: {
  title: string
  body: string
  applicationCodes: string[]
  recipientGroup: string
  status: PushNotification['status']
  scheduledAt: string | null
}) {
  add({
    id: crypto.randomUUID(),
    applicationCode: data.applicationCodes[0] ?? 'bccm-mobile',
    title: data.title,
    body: data.body,
    status: data.status,
    recipientCount:
      data.status === 'sent' ? Math.floor(Math.random() * 10000) : 0,
    recipientGroup: data.recipientGroup,
    sentAt: data.status === 'sent' ? new Date().toISOString() : null,
    scheduledAt: data.scheduledAt,
    createdAt: new Date().toISOString()
  })
  toaster.value.success({
    title: 'Varsling opprettet',
    description: 'Den nye varslingen ble opprettet.'
  })
  navigateTo('/notifications')
}
</script>

<template>
  <div class="flex gap-10">
    <div class="flex max-w-5xl flex-1 flex-col gap-8">
      <div>
        <BackButton to="/notifications" label="Tilbake til push-varsler" />
        <h1 class="text-heading-2 text-text-default">Ny varsling</h1>
      </div>

      <NotificationForm ref="formRef" @submit="handleSubmit" />
    </div>

    <aside class="hidden lg:block">
      <NotificationDevicePreview
        :title="formRef?.title ?? ''"
        :body="formRef?.body ?? ''"
        :application-code="formRef?.applicationCodes?.[0] ?? ''"
      />
    </aside>
  </div>
</template>
