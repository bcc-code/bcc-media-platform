<script setup lang="ts">
import { RadioGroup } from '@ark-ui/vue'

defineProps<{
  ratings: string[]
}>()

const model = defineModel<string>({ required: true })
</script>

<template>
  <RadioGroup.Root
    v-model="model"
    class="inline-flex flex-wrap items-center gap-1"
  >
    <RadioGroup.Item
      v-for="rating in ratings"
      :key="rating"
      :value="rating"
      class="ease-out-expo has-focus-visible:outline-focus-ring data-[state=checked]:bg-surface-raise data-[state=checked]:shadow-resting data-[state=checked]:gradient-border cursor-pointer rounded-lg p-1.5 opacity-40 transition-all duration-150 hover:opacity-100 has-focus-visible:outline-2 has-focus-visible:outline-offset-2 data-[state=checked]:opacity-100"
    >
      <DesignAgeRating :rating="rating" />
      <RadioGroup.ItemHiddenInput />
    </RadioGroup.Item>
  </RadioGroup.Root>
</template>
