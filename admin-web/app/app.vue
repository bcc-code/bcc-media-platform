<script setup lang="ts">
useBrand()

useHead({
  title: 'BCC Media Admin',
  titleTemplate: (title?: string) =>
    title && title !== 'BCC Media Admin'
      ? `${title} · BCC Media Admin`
      : 'BCC Media Admin'
})
</script>

<template>
  <NuxtLoadingIndicator color="var(--color-primary-default)" />
  <NuxtAnnouncer />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
  <DesignToastProvider />
  <DesignConfirmProvider />
</template>
