<script setup lang="ts">
interface Props {
  rating: string
}

defineProps<Props>()

// Based on the palette used by Medietilsynet
const borderPalette: Record<string, string> = {
  A: 'border-[#6FB052]',
  '6': 'border-[#6FB052]',
  '9': 'border-[#E1D702]',
  '12': 'border-[#E1D702]',
  '15': 'border-[#EA5B26]',
  '18': 'border-[#E20610]',
  U: 'border-border-1'
}
</script>

<template>
  <span
    class="text-caption-1 text-text-default inline-flex size-6 items-center justify-center rounded border-2 px-1.5 tabular-nums"
    :class="borderPalette[rating] ?? 'border-border-1'"
  >
    {{ rating }}
  </span>
</template>
