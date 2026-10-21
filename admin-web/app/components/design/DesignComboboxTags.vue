<script setup lang="ts">
import { Combobox, createListCollection } from '@ark-ui/vue'

export interface ComboboxTagsItem {
  label: string
  value: string
}

interface Props {
  items: ComboboxTagsItem[]
  label?: string
  placeholder?: string
  emptyText?: string
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  label: undefined,
  placeholder: undefined,
  emptyText: undefined
})

const model = defineModel<string[]>({ default: () => [] })

const query = ref('')

const filtered = computed(() => {
  const q = query.value.trim().toLowerCase()
  if (!q) return props.items
  return props.items.filter(
    (item) =>
      item.label.toLowerCase().includes(q) ||
      item.value.toLowerCase().includes(q)
  )
})

const collection = computed(() =>
  createListCollection({
    items: filtered.value,
    itemToString: (item) => item.label,
    itemToValue: (item) => item.value
  })
)

// Values missing from items (e.g. a deleted group) still render as their code.
const labelFor = (value: string) =>
  props.items.find((item) => item.value === value)?.label ?? value

function remove(value: string) {
  model.value = model.value.filter((v) => v !== value)
}

function onBackspace() {
  if (!query.value && model.value.length) {
    model.value = model.value.slice(0, -1)
  }
}
</script>

<template>
  <Combobox.Root
    v-model="model"
    v-model:input-value="query"
    :collection="collection"
    :disabled="disabled"
    :positioning="{ placement: 'bottom-start', gutter: 4, sameWidth: true }"
    multiple
    open-on-click
    :close-on-select="false"
  >
    <Combobox.Label v-if="label" class="text-body-3 text-text-muted mb-1 block">
      {{ label }}
    </Combobox.Label>
    <Combobox.Control
      class="border-border-1 bg-surface-default flex min-h-10 flex-wrap items-center gap-1.5 rounded-xl border px-3 py-2 data-disabled:cursor-not-allowed data-disabled:opacity-50"
    >
      <span
        v-for="value in model"
        :key="value"
        class="bg-surface-raise gradient-border shadow-resting text-caption-1 text-text-default inline-flex items-center gap-1 rounded-lg px-2 py-0.5"
      >
        {{ labelFor(value) }}
        <button
          type="button"
          class="text-text-hint hover:text-text-default flex cursor-pointer"
          :disabled="disabled"
          @click.stop="remove(value)"
        >
          <Icon name="tabler:x" class="size-3.5" />
        </button>
      </span>
      <Combobox.Input
        :placeholder="model.length ? undefined : placeholder"
        class="text-body-3 text-text-default placeholder:text-text-hint min-w-20 flex-1 bg-transparent outline-none"
        @keydown.backspace="onBackspace"
      />
    </Combobox.Control>

    <Teleport to="#teleports">
      <Combobox.Positioner>
        <Combobox.Content
          class="gradient-border bg-surface-raise shadow-floating ease-out-expo max-h-72 origin-[--transform-origin] overflow-y-auto rounded-xl p-1 transition-[opacity,transform] duration-200 data-[state=closed]:scale-95 data-[state=closed]:opacity-0 data-[state=open]:scale-100 data-[state=open]:opacity-100"
        >
          <Combobox.Empty
            v-if="emptyText"
            class="text-body-3 text-text-muted px-3 py-2"
          >
            {{ emptyText }}
          </Combobox.Empty>
          <Combobox.Item
            v-for="item in filtered"
            :key="item.value"
            :item="item"
            class="text-body-3 text-text-default data-highlighted:bg-surface-indent flex cursor-pointer items-center justify-between gap-2 rounded-lg px-3 py-2"
          >
            <Combobox.ItemText>{{ item.label }}</Combobox.ItemText>
            <Combobox.ItemIndicator>
              <Icon name="tabler:check" class="text-primary-contrast size-4" />
            </Combobox.ItemIndicator>
          </Combobox.Item>
        </Combobox.Content>
      </Combobox.Positioner>
    </Teleport>
  </Combobox.Root>
</template>
