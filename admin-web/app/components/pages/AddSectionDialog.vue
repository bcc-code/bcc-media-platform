<script setup lang="ts">
const open = defineModel<boolean>('open', { default: false })

const emit = defineEmits<{
  add: [section: PageSection]
}>()

const families: SectionFamily[] = ['carousel', 'grid', 'special']

const grouped = computed(() =>
  families.map((family) => ({
    family,
    label: sectionFamilyLabels[family],
    types: sectionTypes.filter((t) => t.family === family)
  }))
)

function addSection(info: SectionTypeInfo) {
  emit('add', newSection(info.type))
  open.value = false
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    title="Legg til seksjon"
    description="Velg en seksjonstype"
  >
    <div class="flex max-h-[28rem] flex-col gap-5 overflow-y-auto">
      <section v-for="group in grouped" :key="group.family">
        <h3
          class="text-caption-1 text-text-hint mb-2 font-medium tracking-wide uppercase"
        >
          {{ group.label }}
        </h3>
        <div class="grid grid-cols-2 gap-2">
          <button
            v-for="info in group.types"
            :key="info.type"
            type="button"
            class="border-border-1 hover:bg-surface-indent ease-out-expo flex cursor-pointer flex-col items-start gap-2 rounded-xl border p-3 text-left transition-all duration-200 active:scale-[0.98]"
            @click="addSection(info)"
          >
            <div
              class="bg-primary-default/15 text-primary-contrast flex size-8 items-center justify-center rounded-lg"
            >
              <Icon :name="info.icon" class="size-4" />
            </div>
            <div>
              <p class="text-title-3 text-text-default">{{ info.label }}</p>
              <p class="text-caption-1 text-text-muted mt-0.5">
                {{ info.description }}
              </p>
            </div>
          </button>
        </div>
      </section>
    </div>
  </DesignDialog>
</template>
