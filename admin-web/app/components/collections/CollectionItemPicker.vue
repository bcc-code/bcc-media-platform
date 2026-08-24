<script setup lang="ts">
const props = defineProps<{
  /** Already-picked refs, shown as added. */
  selected: string[]
}>()

const emit = defineEmits<{
  add: [itemRef: string]
}>()

const open = defineModel<boolean>('open', { default: false })

const { itemsFor } = useCollections()

const target = ref<CollectionTarget>('episodes')
const query = ref('')

watch(open, (isOpen) => {
  if (isOpen) query.value = ''
})

const targetItems = [
  { label: 'Episoder', value: 'episodes', icon: 'tabler:player-play' },
  { label: 'Serier', value: 'shows', icon: 'tabler:device-tv' },
  { label: 'Sesonger', value: 'seasons', icon: 'tabler:stack-2' }
]

const options = computed(() => {
  const needle = query.value.trim().toLowerCase()
  return itemsFor(target.value).filter(
    (i) =>
      !needle ||
      i.label.toLowerCase().includes(needle) ||
      (i.sublabel?.toLowerCase().includes(needle) ?? false)
  )
})

function isAdded(itemRef: string) {
  return props.selected.includes(itemRef)
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    title="Legg til innhold"
    description="Velg hva som skal ligge i samlingen"
  >
    <template #default="{ initialFocus }">
      <div class="flex flex-col gap-4">
        <DesignSegmentGroup v-model="target" :items="targetItems" />

        <DesignInput
          :ref="initialFocus"
          v-model="query"
          placeholder="Søk..."
          icon="tabler:search"
        />

        <div class="flex max-h-80 flex-col gap-1 overflow-y-auto">
          <p
            v-if="options.length === 0"
            class="text-body-3 text-text-hint py-8 text-center"
          >
            Ingen treff.
          </p>

          <button
            v-for="item in options"
            :key="item.ref"
            type="button"
            :disabled="isAdded(item.ref)"
            class="hover:bg-surface-indent flex cursor-pointer items-center gap-3 rounded-xl px-3 py-2.5 text-left disabled:cursor-not-allowed disabled:opacity-50"
            @click="emit('add', item.ref)"
          >
            <span class="min-w-0 flex-1">
              <span class="text-title-3 text-text-default block truncate">
                {{ item.label }}
              </span>
              <span
                v-if="item.sublabel"
                class="text-caption-1 text-text-muted block truncate"
              >
                {{ item.sublabel }}
              </span>
            </span>
            <DesignBadge v-if="isAdded(item.ref)" variant="neutral">
              Lagt til
            </DesignBadge>
            <Icon
              v-else
              name="tabler:plus"
              class="text-text-hint size-4 shrink-0"
            />
          </button>
        </div>
      </div>
    </template>
  </DesignDialog>
</template>
