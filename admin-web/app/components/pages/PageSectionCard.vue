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

const { collections } = useCollections()
const { messages } = useMessages()

const info = computed(() => sectionTypeInfo(props.section.type))

const sectionType = ref<string[]>([props.section.type])
const title = ref(props.section.title ?? '')
const description = ref(props.section.description ?? '')
const size = ref<string[]>([props.section.size])
const showTitle = ref(props.section.showTitle)
const needsAuthentication = ref(props.section.needsAuthentication)
const collectionId = ref<string[]>(
  props.section.collectionId ? [props.section.collectionId] : []
)
const limit = ref(props.section.limit?.toString() ?? '')
const secondaryTitles = ref(props.section.secondaryTitles)
const useContext = ref(props.section.useContext)
const prependLiveElement = ref(props.section.prependLiveElement)
const embedUrl = ref(props.section.embedUrl ?? '')
const messageId = ref<string[]>(
  props.section.messageId ? [props.section.messageId] : []
)
const achievementsSource = ref<string[]>([
  props.section.achievementsSource ?? 'all'
])

const typeOptions = sectionTypes.map((t) => ({
  label: t.label,
  value: t.type
}))

const selectedInfo = computed(() =>
  sectionTypeInfo(sectionType.value[0] as SectionType)
)

const sizeOptions = computed(() =>
  selectedInfo.value.sizes.map((s) => ({
    label: sectionSizeLabels[s],
    value: s
  }))
)

const collectionOptions = computed(() =>
  collections.value.map((c) => ({ label: c.name, value: c.id }))
)

const messageOptions = computed(() =>
  messages.value.map((m) => ({ label: m.title, value: m.id }))
)

const achievementOptions = [
  { label: 'Alle', value: 'all' },
  { label: 'Uferdige', value: 'unachieved' }
]

// Changing type can invalidate the chosen size.
watch(sectionType, () => {
  if (!selectedInfo.value.sizes.includes(size.value[0] as SectionSize)) {
    size.value = [selectedInfo.value.sizes[0]!]
  }
})

function emitUpdate() {
  const type = sectionType.value[0] as SectionType
  const needsCollection = sectionTypeInfo(type).needsCollection
  emit('update', {
    ...props.section,
    type,
    title: title.value || null,
    description: description.value || null,
    size: size.value[0] as SectionSize,
    showTitle: showTitle.value,
    needsAuthentication: needsAuthentication.value,
    collectionId: needsCollection ? (collectionId.value[0] ?? null) : null,
    limit: limit.value.trim() ? parseInt(limit.value) : null,
    secondaryTitles: secondaryTitles.value,
    useContext: useContext.value,
    prependLiveElement: prependLiveElement.value,
    embedUrl: type === 'WebSection' ? embedUrl.value || null : null,
    messageId: type === 'MessageSection' ? (messageId.value[0] ?? null) : null,
    achievementsSource:
      type === 'AchievementSection' ? (achievementsSource.value[0] ?? null) : null
  })
}

watch(
  [
    sectionType,
    title,
    description,
    size,
    showTitle,
    needsAuthentication,
    collectionId,
    limit,
    secondaryTitles,
    useContext,
    prependLiveElement,
    embedUrl,
    messageId,
    achievementsSource
  ],
  emitUpdate
)

const missingSource = computed(() => {
  if (info.value.needsCollection) return !props.section.collectionId
  if (props.section.type === 'WebSection') return !props.section.embedUrl
  if (props.section.type === 'MessageSection') return !props.section.messageId
  return false
})

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

        <div class="mt-2 flex flex-wrap items-center gap-2">
          <span
            class="bg-surface-indent border-border-1 text-caption-1 text-text-hint divide-border-1 inline-flex items-center divide-x rounded-lg border"
          >
            <span class="flex items-center gap-1 px-2.5 py-1">
              <Icon :name="info.icon" class="text-text-muted size-3" />
              {{ info.label }}
            </span>
            <span class="px-2.5 py-1">
              {{ sectionSizeLabels[section.size] }}
            </span>
            <span v-if="section.collectionId" class="truncate px-2.5 py-1">
              {{ collectionName(section.collectionId) }}
            </span>
          </span>

          <DesignBadge v-if="missingSource" variant="warning">
            Mangler innhold
          </DesignBadge>
          <DesignBadge v-if="section.needsAuthentication" variant="neutral">
            Krever innlogging
          </DesignBadge>
        </div>
      </div>

      <div class="flex shrink-0 items-center">
        <DesignButton
          variant="tertiary"
          size="small"
          aria-label="Innstillinger"
          @click="expanded = !expanded"
        >
          <Icon name="tabler:settings" class="size-4" />
        </DesignButton>
        <DesignButton
          variant="tertiary"
          intent="danger"
          size="small"
          aria-label="Fjern seksjon"
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
                  Størrelse
                </label>
                <DesignSelect v-model="size" :items="sizeOptions" />
              </div>
            </div>
            <div
              class="bg-surface-indent divide-border-1 mt-4 max-w-sm divide-y rounded-xl"
            >
              <div class="flex items-center justify-between px-4 py-2.5">
                <span class="text-body-3 text-text-default">Vis tittel</span>
                <DesignSwitch v-model="showTitle" />
              </div>
              <div class="flex items-center justify-between px-4 py-2.5">
                <span class="text-body-3 text-text-default">
                  Krever innlogging
                </span>
                <DesignSwitch v-model="needsAuthentication" />
              </div>
            </div>
          </fieldset>

          <!-- Item sections -->
          <fieldset v-if="selectedInfo.needsCollection">
            <legend class="text-title-3 text-text-default mb-3">
              Datakilde
            </legend>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-body-3 text-text-muted mb-1 block">
                  Samling
                </label>
                <DesignSelect
                  v-model="collectionId"
                  :items="collectionOptions"
                  placeholder="Velg samling"
                />
              </div>
              <DesignInput
                v-model="limit"
                label="Maks antall"
                placeholder="Alle"
              />
            </div>

            <div
              class="bg-surface-indent divide-border-1 mt-4 max-w-sm divide-y rounded-xl"
            >
              <div class="flex items-center justify-between px-4 py-2.5">
                <span class="text-body-3 text-text-default">
                  Sekundærtitler
                </span>
                <DesignSwitch v-model="secondaryTitles" />
              </div>
              <div class="flex items-center justify-between px-4 py-2.5">
                <span class="text-body-3 text-text-default">Bruk kontekst</span>
                <DesignSwitch v-model="useContext" />
              </div>
              <div class="flex items-center justify-between px-4 py-2.5">
                <span class="text-body-3 text-text-default">
                  Live-element først
                </span>
                <DesignSwitch v-model="prependLiveElement" />
              </div>
            </div>
          </fieldset>

          <!-- WebSection -->
          <fieldset v-else-if="selectedInfo.type === 'WebSection'">
            <legend class="text-title-3 text-text-default mb-3">Nettside</legend>
            <DesignInput
              v-model="embedUrl"
              label="Adresse"
              type="url"
              placeholder="https://bcc.media/..."
            />
          </fieldset>

          <!-- MessageSection -->
          <fieldset v-else-if="selectedInfo.type === 'MessageSection'">
            <legend class="text-title-3 text-text-default mb-3">Melding</legend>
            <div class="max-w-sm">
              <DesignSelect
                v-model="messageId"
                :items="messageOptions"
                placeholder="Velg melding"
              />
            </div>
          </fieldset>

          <!-- AchievementSection -->
          <fieldset v-else-if="selectedInfo.type === 'AchievementSection'">
            <legend class="text-title-3 text-text-default mb-3">
              Prestasjoner
            </legend>
            <div class="max-w-sm">
              <DesignSelect
                v-model="achievementsSource"
                :items="achievementOptions"
              />
            </div>
          </fieldset>
        </div>
      </Collapsible.Content>
    </Collapsible.Root>
  </div>
</template>
