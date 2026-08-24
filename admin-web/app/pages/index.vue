<script setup lang="ts">
useHead({ title: 'Hjem' })

const { currentUser } = useAuth()
const { episodes, missingVideo } = useEpisodes()
const { unlinked } = useAssets()
const { shorts } = useShorts()
const { calendarEntries } = useCalendarEntries()
const { notifications } = useNotifications()
const { liveMessages } = useMessages()
const { config } = useLivestream()

const now = useNow({ interval: 60000 })

const firstName = computed(() => currentUser.value?.firstName ?? '')

const draftCount = computed(
  () =>
    episodes.value.filter((e) => e.status === 'draft').length +
    shorts.value.filter((s) => s.status === 'draft').length
)

// Only surfaces what actually needs doing — the dashboard should be quiet
// when there is nothing outstanding.
const attention = computed(() =>
  [
    {
      key: 'missing-video',
      to: '/episodes',
      icon: 'tabler:movie-off',
      count: missingVideo.value.length,
      label: 'episoder mangler video',
      tone: 'warning' as const
    },
    {
      key: 'unlinked',
      to: '/assets',
      icon: 'tabler:link-off',
      count: unlinked.value.length,
      label: 'mediefiler er ikke koblet',
      tone: 'neutral' as const
    },
    {
      key: 'drafts',
      to: '/episodes',
      icon: 'tabler:pencil',
      count: draftCount.value,
      label: 'utkast venter',
      tone: 'neutral' as const
    }
  ].filter((item) => item.count > 0)
)

const upcomingEntries = computed(() =>
  calendarEntries.value
    .filter((e) => new Date(e.start) > now.value)
    .sort((a, b) => a.start.localeCompare(b.start))
    .slice(0, 4)
)

const scheduledNotifications = computed(() =>
  notifications.value
    .filter((n) => notificationState(n) === 'scheduled')
    .sort((a, b) => (a.scheduleAt ?? '').localeCompare(b.scheduleAt ?? ''))
)

function formatWhen(iso: string) {
  return new Date(iso).toLocaleString('nb-NO', {
    weekday: 'short',
    day: 'numeric',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>

<template>
  <div class="flex max-w-4xl flex-col gap-10">
    <h1 class="text-heading-2 text-text-default">
      {{ firstName ? `Hei, ${firstName}` : 'Hjem' }}
    </h1>

    <!-- Needs attention -->
    <section class="flex flex-col gap-4">
      <h2 class="text-title-1 text-text-default">Trenger oppmerksomhet</h2>

      <div v-if="attention.length > 0" class="grid gap-3 sm:grid-cols-3">
        <DashboardStat
          v-for="item in attention"
          :key="item.key"
          :to="item.to"
          :icon="item.icon"
          :count="item.count"
          :label="item.label"
          :tone="item.tone"
        />
      </div>

      <DesignBanner v-else variant="success" icon="tabler:check">
        Alt er à jour. Ingenting venter på deg.
      </DesignBanner>
    </section>

    <div class="grid gap-10 lg:grid-cols-2">
      <!-- Upcoming calendar -->
      <section class="flex flex-col gap-4">
        <div class="flex items-center justify-between">
          <h2 class="text-title-1 text-text-default">Neste i kalenderen</h2>
          <NuxtLink
            to="/calendar/entries"
            class="text-caption-1 text-text-muted hover:text-text-default"
          >
            Se alle
          </NuxtLink>
        </div>

        <div v-if="upcomingEntries.length > 0" class="flex flex-col gap-2">
          <NuxtLink
            v-for="entry in upcomingEntries"
            :key="entry.id"
            :to="`/calendar/entries/${entry.id}`"
            class="border-border-1 hover:bg-surface-indent flex items-center gap-3 rounded-xl border px-4 py-3"
          >
            <span class="min-w-0 flex-1">
              <span class="text-title-3 text-text-default block truncate">
                {{ entry.title }}
              </span>
              <span class="text-caption-1 text-text-muted block truncate">
                {{ entry.event.title }}
              </span>
            </span>
            <span class="text-caption-1 text-text-hint whitespace-nowrap">
              {{ formatWhen(entry.start) }}
            </span>
          </NuxtLink>
        </div>

        <p v-else class="text-body-3 text-text-hint">
          Ingenting planlagt framover.
        </p>
      </section>

      <!-- Live right now -->
      <section class="flex flex-col gap-4">
        <div class="flex items-center justify-between">
          <h2 class="text-title-1 text-text-default">Ute nå</h2>
          <NuxtLink
            to="/operations"
            class="text-caption-1 text-text-muted hover:text-text-default"
          >
            Drift
          </NuxtLink>
        </div>

        <div class="flex flex-col gap-2">
          <div
            class="border-border-1 flex items-center justify-between gap-3 rounded-xl border px-4 py-3"
          >
            <span class="text-body-3 text-text-muted">Direktestrøm</span>
            <DesignStatusIndicator
              size="sm"
              :variant="config.liveOnline ? 'success' : 'neutral'"
            >
              {{ config.liveOnline ? 'På luften' : 'Av luften' }}
            </DesignStatusIndicator>
          </div>

          <NuxtLink
            v-for="message in liveMessages"
            :key="message.id"
            :to="`/operations/messages/${message.id}`"
            class="border-border-1 hover:bg-surface-indent flex items-center gap-3 rounded-xl border px-4 py-3"
          >
            <Icon
              :name="severityIcons[message.severity]"
              class="text-text-hint size-4 shrink-0"
            />
            <span class="text-body-3 text-text-default min-w-0 flex-1 truncate">
              {{ message.title }}
            </span>
            <DesignBadge :variant="severityVariants[message.severity]">
              Vises
            </DesignBadge>
          </NuxtLink>

          <p
            v-if="liveMessages.length === 0"
            class="text-body-3 text-text-hint px-1"
          >
            Ingen aktive meldinger.
          </p>
        </div>
      </section>
    </div>

    <!-- Scheduled push -->
    <section v-if="scheduledNotifications.length > 0" class="flex flex-col gap-4">
      <div class="flex items-center justify-between">
        <h2 class="text-title-1 text-text-default">Planlagte varslinger</h2>
        <NuxtLink
          to="/notifications"
          class="text-caption-1 text-text-muted hover:text-text-default"
        >
          Se alle
        </NuxtLink>
      </div>

      <div class="flex flex-col gap-2">
        <NuxtLink
          v-for="notification in scheduledNotifications"
          :key="notification.id"
          :to="`/notifications/${notification.id}`"
          class="border-border-1 hover:bg-surface-indent flex items-center gap-3 rounded-xl border px-4 py-3"
        >
          <span class="min-w-0 flex-1">
            <span class="text-title-3 text-text-default block truncate">
              {{ notification.title }}
            </span>
            <span class="text-caption-1 text-text-muted block truncate">
              {{ applicationGroupLabel(notification.appGroupId) }}
            </span>
          </span>
          <span class="text-caption-1 text-text-hint whitespace-nowrap">
            {{ notification.scheduleAt ? formatWhen(notification.scheduleAt) : '' }}
          </span>
        </NuxtLink>
      </div>
    </section>
  </div>
</template>
