<script setup lang="ts">
export interface ToggleChipItem {
  label: string
  value: string
}

defineProps<{
  items: ToggleChipItem[]
  disabled?: boolean
}>()

const model = defineModel<string[]>({ required: true })

function toggle(value: string) {
  model.value = model.value.includes(value)
    ? model.value.filter((v) => v !== value)
    : [...model.value, value]
}
</script>

<template>
  <div class="flex flex-wrap gap-2">
    <button
      v-for="item in items"
      :key="item.value"
      type="button"
      :disabled="disabled"
      :aria-pressed="model.includes(item.value)"
      class="text-title-3 ease-out-expo inline-flex cursor-pointer items-center gap-1.5 rounded-xl px-3 py-1.5 ring-1 transition-colors duration-150 ring-inset disabled:cursor-not-allowed disabled:opacity-50"
      :class="
        model.includes(item.value)
          ? 'bg-primary-default text-on-primary ring-transparent'
          : 'bg-surface-indent text-text-muted ring-border-1 hover:text-text-default'
      "
      @click="toggle(item.value)"
    >
      <Icon
        :name="model.includes(item.value) ? 'tabler:check' : 'tabler:plus'"
        class="size-3.5"
      />
      {{ item.label }}
    </button>
  </div>
</template>
