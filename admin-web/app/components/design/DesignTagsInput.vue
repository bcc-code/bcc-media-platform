<script setup lang="ts">
import { TagsInput } from '@ark-ui/vue'

interface Props {
  label?: string
  placeholder?: string
  disabled?: boolean
  invalid?: boolean
  max?: number
}

withDefaults(defineProps<Props>(), {
  label: undefined,
  placeholder: 'Add tag...',
  max: undefined
})

const model = defineModel<string[]>({ default: () => [] })
</script>

<template>
  <TagsInput.Root
    v-model="model"
    :disabled="disabled"
    :invalid="invalid"
    :max="max"
  >
    <TagsInput.Label
      v-if="label"
      class="text-body-3 text-text-muted mb-1 block"
    >
      {{ label }}
    </TagsInput.Label>
    <TagsInput.Context v-slot="tagsInput">
      <TagsInput.Control
        class="border-border-1 bg-surface-default data-invalid:border-semantic-error flex min-h-10 flex-wrap items-center gap-1.5 rounded-xl border px-3 py-2 disabled:cursor-not-allowed disabled:opacity-50"
      >
        <TagsInput.Item
          v-for="(value, index) in tagsInput.value"
          :key="index"
          :index="index"
          :value="value"
          class="flex"
        >
          <TagsInput.ItemPreview
            class="bg-surface-raise gradient-border shadow-resting text-caption-1 text-text-default data-highlighted:ring-focus-ring inline-flex items-center gap-1 rounded-lg px-2 py-0.5 data-highlighted:ring-2"
          >
            <TagsInput.ItemText>{{ value }}</TagsInput.ItemText>
            <TagsInput.ItemDeleteTrigger
              class="text-text-hint hover:text-text-default flex cursor-pointer"
            >
              <Icon name="tabler:x" class="size-3.5" />
            </TagsInput.ItemDeleteTrigger>
          </TagsInput.ItemPreview>
          <TagsInput.ItemInput class="outline-none" />
        </TagsInput.Item>
        <TagsInput.Input
          :placeholder="placeholder"
          class="text-body-3 text-text-default placeholder:text-text-hint min-w-20 flex-1 bg-transparent outline-none"
        />
      </TagsInput.Control>
    </TagsInput.Context>
    <TagsInput.HiddenInput />
  </TagsInput.Root>
</template>
