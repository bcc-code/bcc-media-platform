<script setup lang="ts">
useHead({ title: 'Meldinger' })

const { messages, activeMessages, setActive } = useMessages()
const toaster = useToast()

const filter = ref('')

const filtered = computed(() => {
  const query = filter.value.trim().toLowerCase()
  if (!query) return messages.value
  return messages.value.filter(
    (m) =>
      m.title.toLowerCase().includes(query) ||
      m.body.toLowerCase().includes(query)
  )
})

function toggle(message: AppMessage, value: boolean) {
  setActive(message.id, value)
  toaster.value.success({
    title: value ? 'Meldingen vises nå' : 'Meldingen er skrudd av',
    description: value
      ? `Vises i ${message.appGroupIds.map(applicationGroupLabel).join(', ')}.`
      : undefined
  })
}
</script>

<template>
  <div class="flex gap-10">
    <div class="flex max-w-3xl flex-1 flex-col gap-8">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-heading-2 text-text-default">Meldinger</h1>
          <p class="text-body-3 text-text-muted mt-1">
            Bannere som vises øverst i appene. Flere kan være aktive samtidig.
          </p>
        </div>
        <NuxtLink to="/messages/new">
          <DesignButton icon="tabler:plus">Ny melding</DesignButton>
        </NuxtLink>
      </div>

      <DesignInput
        v-model="filter"
        placeholder="Søk i meldinger..."
        icon="tabler:search"
      />

      <DesignEmptyState
        v-if="filtered.length === 0"
        icon="tabler:message-off"
        title="Ingen meldinger"
        :description="
          filter ? 'Ingen treff på søket.' : 'Opprett en melding for å starte.'
        "
      />

      <div v-else class="flex flex-col gap-2">
        <div
          v-for="message in filtered"
          :key="message.id"
          class="border-border-1 hover:bg-surface-indent flex items-start gap-4 rounded-xl border px-4 py-3"
          :class="message.active ? 'bg-surface-indent/60' : ''"
        >
          <NuxtLink
            :to="`/messages/${message.id}`"
            class="flex min-w-0 flex-1 items-start gap-3"
          >
            <DesignBadge :variant="severityVariants[message.severity]">
              {{ severityLabels[message.severity] }}
            </DesignBadge>
            <span class="min-w-0 flex-1">
              <span class="text-title-3 text-text-default block truncate">
                {{ message.title }}
              </span>
              <span class="text-caption-1 text-text-muted block truncate">
                {{ message.body }}
              </span>
              <span class="text-caption-1 text-text-hint mt-1 block truncate">
                {{ message.appGroupIds.map(applicationGroupLabel).join(', ') }}
              </span>
            </span>
          </NuxtLink>

          <DesignSwitch
            :model-value="message.active"
            @update:model-value="toggle(message, $event)"
          />
        </div>
      </div>
    </div>

    <aside class="hidden lg:block">
      <MessageDevicePreview
        :messages="activeMessages"
        empty-hint="Ingen aktive meldinger"
      />
    </aside>
  </div>
</template>
