<script setup lang="ts">
import { Progress } from '@ark-ui/vue'

interface Props {
  value?: number | null
  size?: number
  thickness?: number
  showValue?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  value: null,
  size: 40,
  thickness: 4,
  showValue: false
})

const rootStyle = computed(() => ({
  '--size': `${props.size}px`,
  '--thickness': `${props.thickness}px`
}))

const isIndeterminate = computed(() => props.value == null)
</script>

<template>
  <Progress.Root
    :model-value="value"
    :style="rootStyle"
    class="text-primary-contrast relative inline-flex"
  >
    <Progress.Circle
      class="overflow-visible"
      :class="
        isIndeterminate ? 'animate-spin [animation-duration:0.75s]' : undefined
      "
    >
      <Progress.CircleTrack class="stroke-current opacity-15" />
      <Progress.CircleRange
        v-if="!isIndeterminate"
        class="stroke-current transition-[stroke-dashoffset] duration-300 ease-out"
        stroke-linecap="round"
      />
      <circle
        v-else
        class="indeterminate-segment stroke-current"
        stroke-linecap="round"
      />
    </Progress.Circle>
    <Progress.ValueText
      v-if="showValue && !isIndeterminate"
      class="text-caption-1 text-text-default absolute inset-0 flex items-center justify-center tabular-nums"
    />
  </Progress.Root>
</template>

<style scoped>
.indeterminate-segment {
  cx: calc(var(--size) / 2);
  cy: calc(var(--size) / 2);
  r: calc(var(--size) / 2 - var(--thickness) / 2);
  fill: transparent;
  stroke-width: var(--thickness);
  stroke-dasharray: calc(
    2 * 3.14159 * (var(--size) / 2 - var(--thickness) / 2)
  );
  transform-origin: center;
  transform: rotate(-90deg);
  animation: progress-circle-stretch 1.5s cubic-bezier(0.35, 0, 0.65, 1)
    infinite;
}

@keyframes progress-circle-stretch {
  0%,
  100% {
    stroke-dashoffset: calc(
      2 * 3.14159 * (var(--size) / 2 - var(--thickness) / 2) * 0.75
    );
  }
  50% {
    stroke-dashoffset: calc(
      2 * 3.14159 * (var(--size) / 2 - var(--thickness) / 2) * 0.25
    );
  }
}
</style>
