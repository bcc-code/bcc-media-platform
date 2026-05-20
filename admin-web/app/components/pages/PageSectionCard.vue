<script setup lang="ts">
import { Collapsible } from '@ark-ui/vue'

const props = defineProps<{
  section: PageSection
  index: number
}>()

const emit = defineEmits<{
  remove: []
  update: [section: PageSection]
}>()

const expanded = ref(false)

const typeConfig: Record<
  PageSection['type'],
  {
    label: string
    icon: string
    variant: 'success' | 'info' | 'neutral' | 'error'
  }
> = {
  FeaturedSection: { label: 'Hero', icon: 'tabler:star', variant: 'info' },
  PosterSection: { label: 'Poster', icon: 'tabler:photo', variant: 'error' },
  DefaultSection: {
    label: 'Standard',
    icon: 'tabler:carousel-horizontal',
    variant: 'success'
  },
  CardSection: { label: 'Kort', icon: 'tabler:cards', variant: 'neutral' },
  DefaultGridSection: {
    label: 'Rutenett',
    icon: 'tabler:grid-dots',
    variant: 'neutral'
  },
  IconGridSection: {
    label: 'Ikon-rutenett',
    icon: 'tabler:grid-dots',
    variant: 'neutral'
  }
}

const sizeOptions: Record<
  PageSection['type'],
  { label: string; value: string }[]
> = {
  FeaturedSection: [
    { label: 'Liten', value: 'small' },
    { label: 'Medium', value: 'medium' }
  ],
  PosterSection: [
    { label: 'Liten', value: 'small' },
    { label: 'Medium', value: 'medium' }
  ],
  DefaultSection: [
    { label: 'Liten', value: 'small' },
    { label: 'Medium', value: 'medium' }
  ],
  CardSection: [
    { label: 'Stor', value: 'large' },
    { label: 'Mini', value: 'mini' }
  ],
  DefaultGridSection: [{ label: 'Halv', value: 'half' }],
  IconGridSection: [{ label: 'Halv', value: 'half' }]
}

const sectionType = ref([props.section.type])
const title = ref(props.section.title ?? '')
const description = ref(props.section.description ?? '')
const size = ref([props.section.size])
const collectionId = ref(props.section.metadata?.collectionId ?? '')
const continueWatching = ref(props.section.metadata?.continueWatching ?? false)
const myList = ref(props.section.metadata?.myList ?? false)
const secondaryTitles = ref(props.section.metadata?.secondaryTitles ?? false)
const useContext = ref(props.section.metadata?.useContext ?? false)
const prependLiveElement = ref(
  props.section.metadata?.prependLiveElement ?? false
)

const typeOptions = Object.entries(typeConfig).map(([value, config]) => ({
  label: config.label,
  value
}))

watch(sectionType, (newType) => {
  const options = sizeOptions[newType[0] as PageSection['type']]
  const first = options?.[0]
  if (first && !options.some((o) => o.value === size.value[0])) {
    size.value = [first.value as PageSection['size']]
  }
})

function emitUpdate() {
  const metadata: ItemSectionMetadata | null = collectionId.value
    ? {
        collectionId: collectionId.value,
        continueWatching: continueWatching.value,
        myList: myList.value,
        secondaryTitles: secondaryTitles.value,
        useContext: useContext.value,
        prependLiveElement: prependLiveElement.value,
        limit: props.section.metadata?.limit ?? null
      }
    : null

  emit('update', {
    ...props.section,
    type: sectionType.value[0],
    title: title.value || null,
    description: description.value || null,
    size: size.value[0],
    metadata
  } as PageSection)
}

watch(
  [
    sectionType,
    title,
    description,
    size,
    collectionId,
    continueWatching,
    myList,
    secondaryTitles,
    useContext,
    prependLiveElement
  ],
  emitUpdate
)

const confirm = useConfirm()

async function handleRemove() {
  const ok = await confirm({
    title: 'Fjern seksjonen?',
    description: 'Denne handlingen kan ikke angres.',
    confirmLabel: 'Fjern',
    intent: 'danger'
  })
  if (ok) emit('remove')
}
</script>

<template>
  <div class="gradient-border shadow-floating overflow-hidden rounded-2xl">
    <!-- Header -->
    <div class="bg-surface-raise flex items-start gap-4 px-5 py-4">
      <div
        class="drag-handle mt-0.5 flex shrink-0 cursor-grab items-center gap-1 active:cursor-grabbing"
      >
        <Icon name="tabler:grip-vertical" class="text-text-hint size-4" />
        <span class="text-caption-1 text-text-hint w-5 text-center">
          {{ index + 1 }}
        </span>
      </div>

      <div class="min-w-0 flex-1">
        <p class="text-title-3 text-text-default">
          {{ section.title || 'Uten tittel' }}
        </p>
        <p
          v-if="section.description"
          class="text-body-3 text-text-muted mt-0.5"
        >
          {{ section.description }}
        </p>

        <div
          class="bg-surface-indent border-border-1 text-caption-1 text-text-hint divide-border-1 mt-2 inline-flex items-center divide-x rounded-lg border"
        >
          <span class="flex items-center gap-1 px-2.5 py-1">
            <Icon
              :name="typeConfig[section.type].icon"
              class="text-text-muted size-3"
            />
            {{ typeConfig[section.type].label }}
          </span>
          <span class="px-2.5 py-1">{{ section.size }}</span>
          <span v-if="section.metadata" class="truncate px-2.5 py-1">
            {{ section.metadata.collectionId }}
          </span>
        </div>
      </div>

      <div class="flex shrink-0 items-center">
        <DesignButton
          variant="tertiary"
          size="small"
          @click="expanded = !expanded"
        >
          <Icon name="tabler:settings" class="size-4" />
        </DesignButton>
        <DesignButton
          variant="tertiary"
          intent="danger"
          size="small"
          @click="handleRemove"
        >
          <Icon name="tabler:trash" class="size-4" />
        </DesignButton>
      </div>
    </div>

    <!-- Config panel -->
    <Collapsible.Root v-model:open="expanded">
      <Collapsible.Content class="overflow-hidden">
        <div class="border-border-1 flex flex-col gap-5 border-t px-5 py-5">
          <!-- Innhold -->
          <fieldset>
            <legend class="text-title-3 text-text-default mb-3">Innhold</legend>
            <div class="grid grid-cols-2 gap-4">
              <DesignInput
                v-model="title"
                label="Tittel"
                placeholder="Seksjonstittel"
              />
              <DesignInput
                v-model="description"
                label="Beskrivelse"
                placeholder="Valgfri beskrivelse"
              />
            </div>
          </fieldset>

          <!-- Visning -->
          <fieldset>
            <legend class="text-title-3 text-text-default mb-3">Visning</legend>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-body-3 text-text-muted mb-1 block">
                  Type
                </label>
                <DesignSelect v-model="sectionType" :items="typeOptions" />
              </div>
              <div>
                <label class="text-body-3 text-text-muted mb-1 block">
                  Storrelse
                </label>
                <DesignSelect
                  v-model="size"
                  :items="sizeOptions[sectionType[0] as PageSection['type']]"
                />
              </div>
            </div>
          </fieldset>

          <!-- Datakilde -->
          <fieldset>
            <legend class="text-title-3 text-text-default mb-3">
              Datakilde
            </legend>
            <div class="grid grid-cols-2 gap-4">
              <DesignInput
                v-model="collectionId"
                label="Samling-ID"
                placeholder="f.eks. col-popular-shows"
              />
            </div>

            <div v-if="collectionId" class="mt-4">
              <p class="text-body-3 text-text-muted mb-2.5">Alternativer</p>
              <div
                class="bg-surface-indent divide-border-1 max-w-sm divide-y rounded-xl"
              >
                <div class="flex items-center justify-between px-4 py-2.5">
                  <span class="text-body-3 text-text-default">
                    Fortsett a se
                  </span>
                  <DesignSwitch v-model="continueWatching" />
                </div>
                <div class="flex items-center justify-between px-4 py-2.5">
                  <span class="text-body-3 text-text-default">Min liste</span>
                  <DesignSwitch v-model="myList" />
                </div>
                <div class="flex items-center justify-between px-4 py-2.5">
                  <span class="text-body-3 text-text-default">
                    Sekundaertitler
                  </span>
                  <DesignSwitch v-model="secondaryTitles" />
                </div>
                <div class="flex items-center justify-between px-4 py-2.5">
                  <span class="text-body-3 text-text-default">
                    Bruk kontekst
                  </span>
                  <DesignSwitch v-model="useContext" />
                </div>
                <div class="flex items-center justify-between px-4 py-2.5">
                  <span class="text-body-3 text-text-default">
                    Live-element forst
                  </span>
                  <DesignSwitch v-model="prependLiveElement" />
                </div>
              </div>
            </div>
          </fieldset>
        </div>
      </Collapsible.Content>
    </Collapsible.Root>
  </div>
</template>
