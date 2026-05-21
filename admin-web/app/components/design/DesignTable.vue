<script setup lang="ts">
defineProps<{
  columns: string[]
  empty?: string
}>()
</script>

<template>
  <div class="border-border-1 overflow-hidden rounded-xl border">
    <table class="w-full">
      <thead>
        <tr class="bg-surface-indent text-left">
          <th
            v-for="col in columns"
            :key="col"
            class="text-caption-1 text-text-muted px-4 py-2.5 font-medium"
          >
            {{ col }}
          </th>
        </tr>
      </thead>
      <tbody>
        <slot />
      </tbody>
    </table>

    <div v-if="empty" class="text-body-2 text-text-hint px-4 py-12 text-center">
      {{ empty }}
    </div>
  </div>
</template>
