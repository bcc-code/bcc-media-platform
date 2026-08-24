<script setup lang="ts">
defineProps<{
  messages: Pick<AppMessage, 'id' | 'severity' | 'title' | 'body'>[]
  emptyHint?: string
}>()

const tones: Record<MessageSeverity, string> = {
  info: 'bg-sky-500/15 text-sky-300 ring-sky-400/30',
  warning: 'bg-amber-500/15 text-amber-300 ring-amber-400/30',
  error: 'bg-red-500/15 text-red-300 ring-red-400/30'
}
</script>

<template>
  <DevicePreview>
    <div v-if="messages.length > 0" class="flex flex-col gap-2">
      <div
        v-for="message in messages"
        :key="message.id"
        :class="[
          'rounded-2xl p-3.5 ring-1 ring-inset',
          tones[message.severity]
        ]"
      >
        <div class="flex gap-2.5">
          <Icon
            :name="severityIcons[message.severity]"
            class="mt-0.5 size-4 shrink-0"
          />
          <div class="min-w-0">
            <p class="text-sm leading-snug font-semibold">
              {{ message.title || 'Tittel på melding' }}
            </p>
            <p class="mt-1 text-xs leading-snug opacity-90">
              {{ message.body || 'Meldingsteksten vises her.' }}
            </p>
          </div>
        </div>
      </div>
    </div>

    <p v-else-if="emptyHint" class="text-center text-xs text-neutral-500">
      {{ emptyHint }}
    </p>

    <!-- Placeholder app content, so the banners read in context -->
    <div class="flex flex-col gap-3 opacity-40">
      <div class="h-3 w-24 rounded-full bg-neutral-400 dark:bg-neutral-600" />
      <div class="aspect-video rounded-xl bg-neutral-300 dark:bg-neutral-700" />
      <div class="grid grid-cols-2 gap-3">
        <div
          class="aspect-video rounded-xl bg-neutral-300 dark:bg-neutral-700"
        />
        <div
          class="aspect-video rounded-xl bg-neutral-300 dark:bg-neutral-700"
        />
      </div>
    </div>
  </DevicePreview>
</template>
