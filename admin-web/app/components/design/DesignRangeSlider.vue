<script setup lang="ts">
import { Slider } from '@ark-ui/vue'

withDefaults(
  defineProps<{
    max: number
    min?: number
    step?: number
    minStepsBetweenThumbs?: number
    disabled?: boolean
  }>(),
  { min: 0, step: 1, minStepsBetweenThumbs: 1 }
)

const model = defineModel<number[]>({ required: true })
</script>

<template>
  <Slider.Root
    v-model="model"
    :min="min"
    :max="max"
    :step="step"
    :min-steps-between-thumbs="minStepsBetweenThumbs"
    :disabled="disabled"
    class="w-full"
  >
    <Slider.Control class="relative flex items-center py-3">
      <Slider.Track class="bg-surface-indent h-2 w-full rounded-full">
        <Slider.Range class="bg-primary-default h-full rounded-full" />
      </Slider.Track>
      <Slider.Thumb
        v-for="(_, index) in model"
        :key="index"
        :index="index"
        class="border-primary-default bg-surface-raise shadow-resting focus-visible:outline-focus-ring size-5 cursor-grab rounded-full border-2 focus-visible:outline-2 focus-visible:outline-offset-2 active:cursor-grabbing"
      >
        <Slider.HiddenInput />
      </Slider.Thumb>
    </Slider.Control>
  </Slider.Root>
</template>
