<script setup lang="ts">
const model = defineModel<Status>({ required: true })

const items = [
  { label: 'Utkast', value: 'draft', indicator: 'neutral' as const },
  { label: 'Publisert', value: 'published', indicator: 'success' as const },
  { label: 'Ikke oppført', value: 'unlisted', indicator: 'info' as const },
  { label: 'Arkivert', value: 'archived', indicator: 'warning' as const }
]

const selectValue = computed({
  get: () => [model.value],
  set: (value: string[]) => {
    model.value = value[0] as Status
  }
})
</script>

<template>
  <DesignSelect
    v-model="selectValue"
    :items="items"
    placeholder="Velg status"
    placement="bottom-end"
  >
    <template #trigger="{ item }">
      <button
        type="button"
        class="ease-out-expo inline-flex cursor-pointer items-center gap-1 transition-opacity hover:opacity-80"
      >
        <DesignStatusIndicator :variant="item?.indicator ?? 'neutral'">
          {{ item?.label ?? 'Velg status' }}
        </DesignStatusIndicator>
        <Icon name="tabler:chevron-down" class="text-text-muted size-4" />
      </button>
    </template>
    <template #item="{ item }">
      <DesignStatusIndicator :variant="item.indicator">
        {{ item.label }}
      </DesignStatusIndicator>
    </template>
  </DesignSelect>
</template>
