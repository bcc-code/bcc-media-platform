<script setup lang="ts">
import { VueDraggable } from 'vue-draggable-plus'

const props = defineProps<{
  collection?: Collection
}>()

const emit = defineEmits<{
  submit: [data: Collection]
  delete: []
}>()

const isEditing = computed(() => !!props.collection)

const { resolveRef, matchesForQuery } = useCollections()

const name = ref(props.collection?.name ?? '')
const filterType = ref<CollectionFilterType>(
  props.collection?.filterType ?? 'select'
)
const numberInTitles = ref(props.collection?.numberInTitles ?? false)
const itemRefs = ref<string[]>([...(props.collection?.itemRefs ?? [])])
const query = ref<CollectionQuery>({
  ...emptyQuery,
  ...(props.collection?.query ?? {})
})
const isAdvanced = ref(props.collection?.advancedType !== null)
const advancedType = ref<string[]>([
  props.collection?.advancedType ?? 'continue_watching'
])

const pickerOpen = ref(false)
const submitted = ref(false)

const targetOptions = (
  Object.keys(collectionTargetLabels) as CollectionTarget[]
).map((t) => ({ label: collectionTargetLabels[t], value: t }))

const orderOptions = (
  Object.keys(collectionOrderLabels) as CollectionQuery['orderBy'][]
).map((o) => ({ label: collectionOrderLabels[o], value: o }))

const statusItems = [
  { label: 'Publisert', value: 'published' },
  { label: 'Ikke oppført', value: 'unlisted' },
  { label: 'Utkast', value: 'draft' },
  { label: 'Arkivert', value: 'archived' }
]

const modeItems = [
  { label: 'Håndplukket', value: 'select', icon: 'tabler:hand-click' },
  { label: 'Spørring', value: 'query', icon: 'tabler:filter' }
]

const pickedItems = computed(() =>
  itemRefs.value.map((ref) => ({ ref, item: resolveRef(ref) }))
)

const queryMatches = computed(() => matchesForQuery(query.value))

// Bound through strings because the select works on string arrays.
const targetModel = computed({
  get: () => [query.value.target],
  set: (value: string[]) => {
    query.value = { ...query.value, target: value[0] as CollectionTarget }
  }
})

const orderModel = computed({
  get: () => [query.value.orderBy],
  set: (value: string[]) => {
    query.value = {
      ...query.value,
      orderBy: value[0] as CollectionQuery['orderBy']
    }
  }
})

const statusModel = computed({
  get: () => query.value.status as string[],
  set: (value: string[]) => {
    query.value = { ...query.value, status: value as Status[] }
  }
})

const titleContains = computed({
  get: () => query.value.titleContains ?? '',
  set: (value: string) => {
    query.value = { ...query.value, titleContains: value || null }
  }
})

const publishedWithinDays = computed({
  get: () => query.value.publishedWithinDays?.toString() ?? '',
  set: (value: string) => {
    query.value = {
      ...query.value,
      publishedWithinDays: value.trim() ? parseInt(value) : null
    }
  }
})

const limitModel = computed({
  get: () => query.value.limit?.toString() ?? '',
  set: (value: string) => {
    query.value = {
      ...query.value,
      limit: value.trim() ? parseInt(value) : null
    }
  }
})

const errors = computed(() => {
  if (!submitted.value) return {}
  return {
    name: !name.value.trim() ? 'Navn er påkrevd' : undefined,
    items:
      filterType.value === 'select' &&
      !isAdvanced.value &&
      itemRefs.value.length === 0
        ? 'Legg til minst ett element'
        : undefined
  }
})

const hasErrors = computed(() => Object.values(errors.value).some(Boolean))

function addItem(itemRef: string) {
  if (!itemRefs.value.includes(itemRef)) itemRefs.value.push(itemRef)
}

function removeItem(itemRef: string) {
  itemRefs.value = itemRefs.value.filter((r) => r !== itemRef)
}

function handleSubmit() {
  submitted.value = true
  if (hasErrors.value) return

  emit('submit', {
    id: props.collection?.id ?? `col-${crypto.randomUUID().slice(0, 8)}`,
    name: name.value.trim(),
    filterType: filterType.value,
    advancedType: isAdvanced.value
      ? (advancedType.value[0] as CollectionAdvancedType)
      : null,
    numberInTitles: numberInTitles.value,
    itemRefs: filterType.value === 'select' ? [...itemRefs.value] : [],
    query: filterType.value === 'query' ? { ...query.value } : null
  })
}

const confirm = useConfirm()

async function handleDelete() {
  const ok = await confirm({
    title: 'Slett samlingen?',
    description: 'Seksjoner som bruker den vil stå uten innhold.',
    confirmLabel: 'Slett',
    intent: 'danger'
  })
  if (ok) emit('delete')
}
</script>

<template>
  <div class="flex flex-col">
    <div class="flex flex-col gap-4 py-6">
      <DesignInput
        v-model="name"
        label="Navn"
        placeholder="Populære serier"
        required
        :invalid="!!errors.name"
        :error-text="errors.name"
      />
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <div class="flex flex-col gap-2">
        <label class="text-body-3 text-text-muted block">Innhold</label>
        <DesignSegmentGroup v-model="filterType" :items="modeItems" />
      </div>

      <!-- Hand-picked -->
      <template v-if="filterType === 'select'">
        <div class="flex items-center justify-between">
          <p class="text-body-3 text-text-muted">
            {{ itemRefs.length }} element{{ itemRefs.length === 1 ? '' : 'er' }}
            &middot; dra for å endre rekkefølge
          </p>
          <DesignButton
            size="small"
            variant="secondary"
            icon="tabler:plus"
            @click="pickerOpen = true"
          >
            Legg til
          </DesignButton>
        </div>

        <p v-if="errors.items" class="text-caption-1 text-semantic-error">
          {{ errors.items }}
        </p>

        <DesignEmptyState
          v-if="itemRefs.length === 0"
          icon="tabler:list-search"
          title="Ingen elementer"
          description="Legg til innhold for å bygge samlingen"
        />

        <VueDraggable
          v-else
          v-model="itemRefs"
          handle=".drag-handle"
          :animation="200"
          ghost-class="opacity-30"
          class="flex flex-col gap-2"
        >
          <div
            v-for="picked in pickedItems"
            :key="picked.ref"
            class="border-border-1 flex items-center gap-3 rounded-xl border px-3 py-2.5"
          >
            <Icon
              name="tabler:grip-vertical"
              class="drag-handle text-text-hint size-4 shrink-0 cursor-grab active:cursor-grabbing"
            />
            <span class="min-w-0 flex-1">
              <span class="text-title-3 text-text-default block truncate">
                {{ picked.item?.label ?? picked.ref }}
              </span>
              <span
                v-if="picked.item?.sublabel"
                class="text-caption-1 text-text-muted block truncate"
              >
                {{ picked.item.sublabel }}
              </span>
            </span>
            <DesignButton
              size="small"
              variant="tertiary"
              intent="danger"
              icon="tabler:x"
              aria-label="Fjern"
              @click="removeItem(picked.ref)"
            />
          </div>
        </VueDraggable>
      </template>

      <!-- Query -->
      <template v-else>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="text-body-3 text-text-muted mb-1 block">
              Hent fra
            </label>
            <DesignSelect v-model="targetModel" :items="targetOptions" />
          </div>
          <div>
            <label class="text-body-3 text-text-muted mb-1 block">
              Sortering
            </label>
            <DesignSelect v-model="orderModel" :items="orderOptions" />
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <DesignInput
            v-model="titleContains"
            label="Tittel inneholder"
            placeholder="Valgfritt"
          />
          <DesignInput
            v-model="publishedWithinDays"
            label="Publisert siste (dager)"
            placeholder="Alle"
          />
        </div>

        <div class="flex flex-col gap-2">
          <label class="text-body-3 text-text-muted block">Status</label>
          <DesignToggleChips v-model="statusModel" :items="statusItems" />
        </div>

        <div class="w-40">
          <DesignInput
            v-model="limitModel"
            label="Maks antall"
            placeholder="Alle"
          />
        </div>

        <div class="bg-surface-indent flex flex-col gap-2 rounded-xl p-4">
          <p class="text-caption-1 text-text-hint font-medium uppercase">
            Treff nå ({{ queryMatches.length }})
          </p>
          <p
            v-if="queryMatches.length === 0"
            class="text-body-3 text-text-hint"
          >
            Ingen treff med disse innstillingene.
          </p>
          <ul v-else class="flex flex-col gap-1">
            <li
              v-for="match in queryMatches.slice(0, 6)"
              :key="match.ref"
              class="text-body-3 text-text-default truncate"
            >
              {{ match.label }}
            </li>
            <li
              v-if="queryMatches.length > 6"
              class="text-caption-1 text-text-hint"
            >
              + {{ queryMatches.length - 6 }} til
            </li>
          </ul>
        </div>
      </template>
    </div>

    <div class="border-border-1 flex flex-col gap-4 border-t py-6">
      <div class="flex items-start justify-between gap-6">
        <div>
          <p class="text-title-3 text-text-default">Nummerer titlene</p>
          <p class="text-body-3 text-text-muted mt-1">
            Viser 1, 2, 3 … foran hvert element.
          </p>
        </div>
        <DesignSwitch v-model="numberInTitles" />
      </div>

      <div class="flex items-start justify-between gap-6">
        <div>
          <p class="text-title-3 text-text-default">Personlig samling</p>
          <p class="text-body-3 text-text-muted mt-1">
            Innholdet bestemmes per bruker, ikke av listen over.
          </p>
        </div>
        <DesignSwitch v-model="isAdvanced" />
      </div>

      <div v-if="isAdvanced" class="w-56">
        <DesignSelect
          v-model="advancedType"
          :items="[{ label: 'Fortsett å se', value: 'continue_watching' }]"
        />
      </div>
    </div>

    <div class="border-border-1 flex items-center gap-3 border-t pt-6">
      <DesignButton @click="handleSubmit">
        {{ isEditing ? 'Lagre endringer' : 'Opprett samling' }}
      </DesignButton>
      <DesignButton
        v-if="!isEditing"
        variant="secondary"
        @click="navigateTo('/collections')"
      >
        Avbryt
      </DesignButton>
      <div v-if="isEditing" class="ml-auto">
        <DesignButton
          variant="tertiary"
          intent="danger"
          icon="tabler:trash"
          @click="handleDelete"
        >
          Slett
        </DesignButton>
      </div>
    </div>

    <CollectionItemPicker
      v-model:open="pickerOpen"
      :selected="itemRefs"
      @add="addItem"
    />
  </div>
</template>
