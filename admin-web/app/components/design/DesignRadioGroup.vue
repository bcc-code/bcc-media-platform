<script setup lang="ts" generic="T extends RadioGroupItem">
import { RadioGroup } from '@ark-ui/vue'

export interface RadioGroupItem {
  label: string
  value: string
  description?: string
  icon?: string
}

withDefaults(
  defineProps<{
    items: T[]
    columns?: number
  }>(),
  { columns: 3 }
)

const model = defineModel<T['value']>({ required: true })
</script>

<template>
  <RadioGroup.Root
    v-model="model"
    class="grid gap-3"
    :style="{ gridTemplateColumns: `repeat(${columns}, minmax(0, 1fr))` }"
  >
    <RadioGroup.Item
      v-for="item in items"
      :key="item.value"
      :value="item.value"
      class="ease-out-expo bg-surface-raise gradient-border shadow-floating data-[state=checked]:ring-primary-contrast group has-focus-visible:outline-focus-ring flex cursor-pointer items-start gap-3 rounded-2xl p-4 text-left transition-shadow duration-200 has-focus-visible:outline-2 has-focus-visible:outline-offset-2 data-[state=checked]:ring-2"
    >
      <slot name="leading" :item="item">
        <Icon
          v-if="item.icon"
          :name="item.icon"
          class="text-text-muted shrink-0"
        />
      </slot>
      <span class="flex min-w-0 flex-1 flex-col gap-1">
        <RadioGroup.ItemText
          class="text-title-3 text-text-default block truncate"
        >
          {{ item.label }}
        </RadioGroup.ItemText>
        <p
          v-if="item.description"
          class="text-body-3 text-text-muted block truncate"
        >
          {{ item.description }}
        </p>
      </span>
      <RadioGroup.ItemControl
        class="border-border-1 group-data-[state=checked]:border-primary-contrast flex size-4 shrink-0 items-center justify-center rounded-full border-2"
      >
        <span
          class="bg-primary-contrast size-1.5 rounded-full opacity-0 group-data-[state=checked]:opacity-100"
        />
      </RadioGroup.ItemControl>
      <RadioGroup.ItemHiddenInput />
    </RadioGroup.Item>
  </RadioGroup.Root>
</template>
