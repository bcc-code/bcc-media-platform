<script setup lang="ts">
useHead({ title: 'Drift' })

const { config, update } = useLivestream()
const { messages, liveMessages, unplacedActive, placementsFor, setActive } =
  useMessages()
const confirm = useConfirm()
const toaster = useToast()

const lastChanged = useTimeAgo(computed(() => config.value.updatedAt))

// Only going off air is confirmed — it is the destructive direction, and
// turning it back on is always safe.
async function toggleLive() {
  if (config.value.liveOnline) {
    const ok = await confirm({
      title: 'Ta direktestrømmen av luften?',
      description:
        'Seere i alle apper mister direktesendingen umiddelbart. Du kan sette den på igjen når som helst.',
      confirmLabel: 'Ta av luften',
      intent: 'danger'
    })
    if (!ok) return
    update({ liveOnline: false })
    toaster.value.success({
      title: 'Direktestrømmen er av luften',
      description: 'Seere ser nå ingen direktesending.'
    })
    return
  }

  update({ liveOnline: true })
  toaster.value.success({
    title: 'Direktestrømmen er på luften',
    description: 'Seere kan se direktesendingen igjen.'
  })
}

function placementLabel(messageId: string): string {
  const placed = placementsFor(messageId)
  if (placed.length === 0) return ''
  return placed
    .map((p) => `${p.title} · ${applicationLabel(p.applicationCode)}`)
    .join(', ')
}

function toggleMessage(message: AppMessage, value: boolean) {
  setActive(message.id, value)
  const where = placementLabel(message.id)
  toaster.value.success({
    title: value ? 'Meldingen vises nå' : 'Meldingen er skrudd av',
    description: value
      ? where || 'Meldingen er ikke lagt på noen side ennå.'
      : undefined
  })
}

const settingsOpen = ref(false)
const url = ref(config.value.livestreamUrl)
const urlDirty = computed(() => url.value.trim() !== config.value.livestreamUrl)

function saveUrl() {
  update({ livestreamUrl: url.value.trim() })
  toaster.value.success({ title: 'Strøm-URL lagret' })
}
</script>

<template>
  <div class="flex gap-10">
    <div class="flex max-w-3xl flex-1 flex-col gap-10">
      <h1 class="text-heading-2 text-text-default">Drift</h1>

      <!-- Livestream -->
      <section
        class="gradient-border bg-surface-raise shadow-floating flex flex-col gap-5 rounded-2xl p-6"
      >
        <div class="flex items-start justify-between gap-6">
          <div class="flex flex-col items-start gap-2">
            <DesignStatusIndicator
              :variant="config.liveOnline ? 'success' : 'neutral'"
            >
              {{ config.liveOnline ? 'På luften' : 'Av luften' }}
            </DesignStatusIndicator>
            <p class="text-body-3 text-text-muted">
              {{
                config.liveOnline
                  ? 'Direktesendingen vises i alle apper.'
                  : 'Direktesendingen er skjult i alle apper.'
              }}
            </p>
          </div>

          <DesignButton
            size="large"
            :intent="config.liveOnline ? 'danger' : 'neutral'"
            :icon="
              config.liveOnline ? 'tabler:player-stop' : 'tabler:broadcast'
            "
            @click="toggleLive"
          >
            {{ config.liveOnline ? 'Ta av luften' : 'Sett på luften' }}
          </DesignButton>
        </div>

        <div
          class="border-border-1 flex items-center justify-between border-t pt-4"
        >
          <p class="text-caption-1 text-text-hint">
            Sist endret {{ lastChanged }} av {{ config.updatedBy }}
          </p>
          <DesignButton
            size="small"
            variant="tertiary"
            icon="tabler:adjustments"
            @click="settingsOpen = !settingsOpen"
          >
            Innstillinger
          </DesignButton>
        </div>

        <div
          v-if="settingsOpen"
          class="border-border-1 flex flex-col gap-4 border-t pt-4"
        >
          <div class="flex items-end gap-3">
            <div class="flex-1">
              <DesignInput
                v-model="url"
                label="Strøm-URL"
                type="url"
                placeholder="https://live.bcc.media/live/index.m3u8"
                helper-text="HLS-manifestet appene spiller av."
              />
            </div>
            <DesignButton
              variant="secondary"
              :disabled="!urlDirty"
              @click="saveUrl"
            >
              Lagre
            </DesignButton>
          </div>
          <div class="flex items-start justify-between">
            <div>
              <p class="text-title-3 text-text-default">
                Avspillingsstatistikk
              </p>
              <p class="text-body-3 text-text-muted mt-1">
                Sender avspillingsdata til NPAW.
              </p>
            </div>
            <DesignSwitch
              :model-value="config.npawEnabled"
              @update:model-value="update({ npawEnabled: $event })"
            />
          </div>
        </div>
      </section>

      <!-- Messages -->
      <section class="flex flex-col gap-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-title-1 text-text-default">Meldinger</h2>
            <p class="text-body-3 text-text-muted mt-1">
              Bannere øverst i appene. Flere kan være aktive samtidig.
            </p>
          </div>
          <NuxtLink to="/operations/messages/new">
            <DesignButton icon="tabler:plus">Ny melding</DesignButton>
          </NuxtLink>
        </div>

        <DesignBanner
          v-if="unplacedActive.length > 0"
          variant="warning"
          icon="tabler:alert-triangle"
        >
          {{ unplacedActive.length }}
          {{ unplacedActive.length === 1 ? 'melding er' : 'meldinger er' }}
          skrudd på, men ligger ikke på noen side og vises derfor ikke.
        </DesignBanner>

        <DesignEmptyState
          v-if="messages.length === 0"
          icon="tabler:message-off"
          title="Ingen meldinger"
          description="Opprett en melding for å starte."
        />

        <div v-else class="flex flex-col gap-2">
          <div
            v-for="message in messages"
            :key="message.id"
            class="border-border-1 hover:bg-surface-indent flex items-start gap-4 rounded-xl border px-4 py-3"
            :class="message.active ? 'bg-surface-indent/60' : ''"
          >
            <NuxtLink
              :to="`/operations/messages/${message.id}`"
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
                  {{ placementLabel(message.id) || 'Ikke lagt på noen side' }}
                </span>
              </span>
            </NuxtLink>

            <DesignSwitch
              :model-value="message.active"
              @update:model-value="toggleMessage(message, $event)"
            />
          </div>
        </div>
      </section>
    </div>

    <aside class="hidden lg:block">
      <MessageDevicePreview
        :messages="liveMessages"
        empty-hint="Ingen aktive meldinger"
      />
    </aside>
  </div>
</template>
