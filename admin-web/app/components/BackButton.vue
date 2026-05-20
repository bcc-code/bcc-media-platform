<script setup lang="ts">
defineProps<{
  to: string
  label: string
}>()
</script>

<template>
  <NuxtLink :to="to" class="mb-6 inline-flex rounded-full">
    <DesignButton
      variant="secondary"
      size="medium"
      icon="tabler:arrow-left"
      tabindex="-1"
    >
      {{ label }}
    </DesignButton>
  </NuxtLink>
</template>
