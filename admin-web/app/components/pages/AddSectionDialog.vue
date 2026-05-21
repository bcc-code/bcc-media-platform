<script setup lang="ts">
const open = defineModel<boolean>('open', { default: false })

const emit = defineEmits<{
  add: [section: PageSection]
}>()

const sectionTypes: {
  type: PageSection['type']
  label: string
  description: string
  icon: string
  defaultSize: string
}[] = [
  {
    type: 'FeaturedSection',
    label: 'Hero',
    description: 'Stort banner med fremhevet innhold',
    icon: 'tabler:star',
    defaultSize: 'medium'
  },
  {
    type: 'DefaultSection',
    label: 'Standard',
    description: 'Horisontal karusell med landskapsminiatyrbilder',
    icon: 'tabler:carousel-horizontal',
    defaultSize: 'medium'
  },
  {
    type: 'PosterSection',
    label: 'Poster',
    description: 'Vertikale plakater i en karusell',
    icon: 'tabler:photo',
    defaultSize: 'medium'
  },
  {
    type: 'CardSection',
    label: 'Kort',
    description: 'Brede kort for innholdselementer',
    icon: 'tabler:cards',
    defaultSize: 'large'
  },
  {
    type: 'DefaultGridSection',
    label: 'Rutenett',
    description: 'Rutenettvisning med landskapsminiatyrbilder',
    icon: 'tabler:grid-dots',
    defaultSize: 'half'
  },
  {
    type: 'IconGridSection',
    label: 'Ikon-rutenett',
    description: 'Rutenett med ikoner og etiketter',
    icon: 'tabler:category',
    defaultSize: 'half'
  }
]

function addSection(config: (typeof sectionTypes)[number]) {
  const section = {
    id: `s${Date.now()}`,
    type: config.type,
    title: null,
    description: null,
    size: config.defaultSize,
    metadata: null
  } as PageSection

  emit('add', section)
  open.value = false
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    title="Legg til seksjon"
    description="Velg en seksjonstype"
  >
    <div class="grid grid-cols-2 gap-2">
      <button
        v-for="config in sectionTypes"
        :key="config.type"
        type="button"
        class="border-border-1 hover:bg-surface-indent ease-out-expo flex cursor-pointer flex-col items-start gap-2 rounded-xl border p-4 text-left transition-all duration-200 active:scale-[0.98]"
        @click="addSection(config)"
      >
        <div
          class="bg-primary-default/15 text-primary-contrast flex size-9 items-center justify-center rounded-lg"
        >
          <Icon :name="config.icon" class="size-5" />
        </div>
        <div>
          <p class="text-title-3 text-text-default">{{ config.label }}</p>
          <p class="text-caption-1 text-text-muted mt-0.5">
            {{ config.description }}
          </p>
        </div>
      </button>
    </div>
  </DesignDialog>
</template>
