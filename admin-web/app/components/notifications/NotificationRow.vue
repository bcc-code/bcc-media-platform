<script setup lang="ts">
const props = defineProps<{
  notification: PushNotification
}>()

const state = computed(() => notificationState(props.notification))

const dateValue = computed(
  () =>
    props.notification.sendCompleted ??
    props.notification.sendStarted ??
    props.notification.scheduleAt ??
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
      <div class="flex items-center gap-2">
        <p class="text-title-3 text-text-default">{{ notification.title }}</p>
        <DesignTooltip v-if="notification.highPriority" content="Høy prioritet">
          <Icon
            name="tabler:alert-circle-filled"
            class="text-semantic-warning size-4"
          />
        </DesignTooltip>
      </div>
      <p class="text-caption-1 text-text-muted mt-0.5">
        {{ notification.body }}
      </p>
    </td>
    <td class="px-4 py-3">
      <p class="text-body-3 text-text-muted">
        {{ applicationGroupLabel(notification.appGroupId) }}
      </p>
      <p class="text-caption-1 text-text-hint mt-0.5">
        {{
          notification.targetIds.length === 0
            ? 'Alle'
            : notification.targetIds.map(targetLabel).join(', ')
        }}
      </p>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      <span v-if="notification.recipientCount > 0">
        {{ notification.recipientCount.toLocaleString('nb-NO') }}
      </span>
      <span v-else class="text-text-hint">&mdash;</span>
    </td>
    <td class="px-4 py-3">
      <DesignStatusIndicator :variant="notificationStateConfig[state].variant">
        {{ notificationStateConfig[state].label }}
      </DesignStatusIndicator>
    </td>
    <td class="text-body-3 text-text-muted px-4 py-3 whitespace-nowrap">
      {{ timeAgo }}
    </td>
  </tr>
</template>
