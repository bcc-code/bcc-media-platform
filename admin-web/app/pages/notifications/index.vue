<script setup lang="ts">
useHead({ title: 'Push-varsler' })

const { notifications } = useNotifications()
const { matchesFilter } = useAppFilter()

const filteredNotifications = computed(() => {
  return notifications.value.filter((n) => matchesFilter(n.applicationCode))
})
</script>

<template>
  <div class="flex max-w-5xl flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-heading-2 text-text-default">Push-varsler</h1>
      <div class="flex items-center gap-2">
        <AppSelector />
      </div>
    </div>

    <section>
      <div class="mb-4 flex items-center justify-between">
        <h2 class="text-title-1 text-text-default">Varslingshistorikk</h2>
        <NuxtLink to="/notifications/new">
          <DesignButton icon="tabler:plus">Ny varsling</DesignButton>
        </NuxtLink>
      </div>

      <DesignTable
        :columns="['Tittel', 'Mottakere', 'Status', 'Dato']"
        :empty="
          filteredNotifications.length === 0
            ? 'Ingen varsler funnet for denne appen.'
            : undefined
        "
      >
        <NotificationRow
          v-for="notification in filteredNotifications"
          :key="notification.id"
          :notification="notification"
        />
      </DesignTable>
    </section>
  </div>
</template>
