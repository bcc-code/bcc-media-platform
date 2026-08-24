<script setup lang="ts">
useHead({ title: 'Direktestrøm' })

const { config, update } = useLivestream()
const confirm = useConfirm()
const toaster = useToast()

const url = ref(config.value.livestreamUrl)
const urlDirty = computed(() => url.value.trim() !== config.value.livestreamUrl)

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

function saveUrl() {
  update({ livestreamUrl: url.value.trim() })
  toaster.value.success({ title: 'Strøm-URL lagret' })
}

function toggleNpaw(value: boolean) {
  update({ npawEnabled: value })
}
</script>

<template>
  <div class="flex max-w-3xl flex-col gap-8">
    <div>
      <h1 class="text-heading-2 text-text-default">Direktestrøm</h1>
      <p class="text-body-3 text-text-muted mt-1">
        Styrer om direktesendingen er tilgjengelig i appene.
      </p>
    </div>

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
          :icon="config.liveOnline ? 'tabler:player-stop' : 'tabler:broadcast'"
          @click="toggleLive"
        >
          {{ config.liveOnline ? 'Ta av luften' : 'Sett på luften' }}
        </DesignButton>
      </div>

      <p class="text-caption-1 text-text-hint border-border-1 border-t pt-4">
        Sist endret {{ lastChanged }} av {{ config.updatedBy }}
      </p>
    </section>

    <section class="flex flex-col gap-4">
      <h2 class="text-title-1 text-text-default">Innstillinger</h2>

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

      <div
        class="border-border-1 flex items-start justify-between border-t pt-4"
      >
        <div>
          <p class="text-title-3 text-text-default">Avspillingsstatistikk</p>
          <p class="text-body-3 text-text-muted mt-1">
            Sender avspillingsdata til NPAW.
          </p>
        </div>
        <DesignSwitch
          :model-value="config.npawEnabled"
          @update:model-value="toggleNpaw"
        />
      </div>
    </section>
  </div>
</template>
