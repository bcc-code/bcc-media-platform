<script setup lang="ts">
const statusConfig: Record<
  PushNotification['status'],
  { label: string; variant: 'success' | 'info' | 'neutral' | 'error' }
> = {
  sent: { label: 'Sendt', variant: 'success' },
  scheduled: { label: 'Planlagt', variant: 'info' },
  draft: { label: 'Utkast', variant: 'neutral' },
  failed: { label: 'Feilet', variant: 'error' }
}

const props = defineProps<{
  notification: PushNotification
}>()

const dateValue = computed(
  () =>
    props.notification.sentAt ??
    props.notification.scheduledAt ??
    props.notification.createdAt
)

const timeAgo = useTimeAgo(dateValue)
</script>

<template>
  <tr
    class="border-border-1 hover:bg-surface-indent cursor-pointer border-t"
    @click="navigateTo(`/notifications/${notification.id}`)"
  >
    <td class="px-4 py-3">
      <p class="text-title-3 text-text-default">{{ notification.title }}</p>
      <p class="text-caption-1 text-text-muted mt-0.5">
        {{ notification.body }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3">
      {{ notification.recipientGroup }}
      <span v-if="notification.recipientCount > 0" class="text-text-hint">
        ({{ notification.recipientCount.toLocaleString('nb-NO') }})
      </span>
    </td>
    <td class="px-4 py-3">
      <DesignStatusIndicator
        :variant="statusConfig[notification.status].variant"
      >
        {{ statusConfig[notification.status].label }}
      </DesignStatusIndicator>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ timeAgo }}
    </td>
  </tr>
</template>
