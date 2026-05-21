<script setup lang="ts">
const { selectedApp, appOptions } = useAppFilter()
</script>

<template>
  <DesignSelect
    v-model="selectedApp"
    :items="appOptions"
    placeholder="Velg app"
    placement="bottom-end"
  />
</template>
