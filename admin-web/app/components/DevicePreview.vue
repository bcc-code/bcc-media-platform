<script setup lang="ts">
defineProps<{
  width?: string
}>()
</script>

<template>
  <div class="sticky top-6">
    <!-- Phone frame -->
    <div
      class="shadow-floating mx-auto rounded-[36px] border-[3px] border-neutral-700 bg-neutral-900 p-2"
      :class="width ?? 'w-75'"
    >
      <!-- Notch -->
      <div class="flex justify-center pb-1.5">
        <div class="h-2 w-16 rounded-full bg-neutral-700" />
      </div>

      <!-- Screen -->
      <div
        class="flex flex-col gap-4 overflow-y-auto rounded-[28px] bg-neutral-100 px-3.5 pt-4 pb-5 dark:bg-neutral-800"
        style="height: 580px"
      >
        <slot />
      </div>

      <!-- Home indicator -->
      <div class="flex justify-center pt-2">
        <div class="h-1.5 w-14 rounded-full bg-neutral-600" />
      </div>
    </div>
  </div>
</template>
