<script setup lang="ts">
defineProps<{
  title: string
  body: string
  applicationCode: string
}>()
</script>

<template>
  <DevicePreview>
    <!-- Push notification banner -->
    <div class="shadow-resting rounded-2xl bg-neutral-700/80 p-3.5">
      <!-- App row -->
      <div class="flex items-center gap-2 pb-2">
        <div class="bg-primary-default size-5 rounded-md" />
        <span
          class="text-xs font-medium tracking-wider text-neutral-300 uppercase"
        >
          {{ applicationCode ? applicationLabel(applicationCode) : 'App' }}
        </span>
        <span class="ml-auto text-xs text-neutral-400">nå</span>
      </div>
      <!-- Title -->
      <p class="truncate text-sm leading-snug font-semibold text-white">
        {{ title || 'Tittel' }}
      </p>
      <!-- Body -->
      <p class="mt-0.5 line-clamp-2 text-xs leading-snug text-neutral-300">
        {{ body || 'Meldingstekst' }}
      </p>
    </div>
  </DevicePreview>
</template>
