<script setup lang="ts" generic="T extends SelectItem">
import { Select, createListCollection } from '@ark-ui/vue'
import type { Placement } from '~/types/design'

export interface SelectItem {
  label: string
  value: string
}

interface Props {
  items: T[]
  placeholder?: string
  placement?: Placement
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Velg...',
  placement: 'bottom-start'
})

const model = defineModel<string[]>({ required: true })

const collection = computed(() =>
  createListCollection({
    items: props.items,
    itemToString: (item: T) => item.label,
    itemToValue: (item: T) => item.value
  })
)

const selectedItem = computed<T | undefined>(() =>
  props.items.find((item) => item.value === model.value[0])
)
</script>

<template>
  <Select.Root
    v-model="model"
    :collection="collection"
    :positioning="{ placement, gutter: 4 }"
  >
    <Select.Control>
      <Select.Trigger v-if="$slots.trigger" as-child>
        <slot name="trigger" :item="selectedItem" />
      </Select.Trigger>
      <Select.Trigger
        v-else
        class="gradient-border bg-surface-raise text-title-3 text-text-default shadow-resting hover:bg-surface-indent inline-flex cursor-pointer items-center gap-2 rounded-xl px-3 py-2"
      >
        {{ selectedItem?.label ?? placeholder }}
        <Icon name="tabler:chevron-down" class="text-text-muted size-4" />
      </Select.Trigger>
    </Select.Control>

    <Teleport to="#teleports">
      <Select.Positioner>
        <Select.Content
          class="gradient-border bg-surface-raise shadow-floating ease-out-expo origin-[--transform-origin] rounded-xl p-1 transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <Select.ItemGroup>
            <Select.Item
              v-for="item in items"
              :key="item.value"
              :item="item"
              class="text-body-3 text-text-default data-highlighted:bg-surface-indent flex cursor-pointer items-center justify-between gap-2 rounded-lg px-3 py-2"
            >
              <slot name="item" :item="item">
                <Select.ItemText>{{ item.label }}</Select.ItemText>
              </slot>
              <Select.ItemIndicator>
                <Icon
                  name="tabler:check"
                  class="text-primary-contrast size-4"
                />
              </Select.ItemIndicator>
            </Select.Item>
          </Select.ItemGroup>
        </Select.Content>
      </Select.Positioner>
    </Teleport>
  </Select.Root>
</template>
