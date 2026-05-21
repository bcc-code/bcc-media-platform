<script setup lang="ts">
interface Props {
  size?: number
}

withDefaults(defineProps<Props>(), {
  size: 40
})
</script>

<template>
  <div class="flex size-full items-center justify-center px-4">
    <DesignProgressCircle :size="size" />
  </div>
</template>
