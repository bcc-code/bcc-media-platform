<script setup lang="ts">
import { SegmentGroup } from '@ark-ui/vue'

export interface SegmentGroupItem {
  label: string
  value: string
  icon?: string
}

defineProps<{
  items: SegmentGroupItem[]
}>()

const model = defineModel<string>({ required: true })
</script>

<template>
  <SegmentGroup.Root
    v-model="model"
    class="bg-surface-indent relative isolate inline-flex items-center gap-0.5 rounded-xl p-1"
  >
    <SegmentGroup.Indicator
      class="gradient-border bg-surface-raise shadow-resting absolute z-0 rounded-lg"
      style="
        width: var(--width);
        height: var(--height);
        top: var(--top);
        left: var(--left);
        transition:
          left 250ms var(--ease-out-expo),
          width 200ms var(--ease-out-expo),
          height 200ms var(--ease-out-expo),
          top 200ms var(--ease-out-expo);
      "
    />
    <SegmentGroup.Item
      v-for="item in items"
      :key="item.value"
      :value="item.value"
      class="text-title-3 text-text-muted data-[state=checked]:text-text-default relative z-1 inline-flex cursor-pointer items-center gap-1.5 rounded-lg px-3 py-1.5 select-none"
    >
      <Icon v-if="item.icon" :name="item.icon" class="relative z-1 size-4" />
      <SegmentGroup.ItemText class="relative z-1">
        {{ item.label }}
      </SegmentGroup.ItemText>
      <SegmentGroup.ItemControl class="hidden" />
      <SegmentGroup.ItemHiddenInput />
    </SegmentGroup.Item>
  </SegmentGroup.Root>
</template>
