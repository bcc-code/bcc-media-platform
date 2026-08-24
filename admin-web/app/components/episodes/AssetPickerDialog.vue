<script setup lang="ts">
const props = defineProps<{
  /** Episode being edited, so its own video is not shown as "in use". */
  currentEpisodeId?: string
}>()

const emit = defineEmits<{
  select: [assetId: string]
}>()

const open = defineModel<boolean>('open', { default: false })

const { assets, linkedEpisode } = useAssets()

const query = ref('')

watch(open, (isOpen) => {
  if (isOpen) query.value = ''
})

interface AssetOption {
  asset: Asset
  takenBy: Episode | undefined
}

const options = computed<AssetOption[]>(() => {
  const q = query.value.trim().toLowerCase()
  return (
    assets.value
      .filter(
        (a) =>
          !q ||
          a.name.toLowerCase().includes(q) ||
          a.mediabankenId.toLowerCase().includes(q)
      )
      .map((asset) => {
        const linked = linkedEpisode(asset.id)
        return {
          asset,
          takenBy: linked?.id === props.currentEpisodeId ? undefined : linked
        }
      })
      // Files not yet used come first — that is what she is usually looking for.
      .sort((a, b) => {
        if (!!a.takenBy === !!b.takenBy) {
          return b.asset.arrivedAt.localeCompare(a.asset.arrivedAt)
        }
        return a.takenBy ? 1 : -1
      })
  )
})

function choose(assetId: string) {
  emit('select', assetId)
  open.value = false
}
</script>

<template>
  <DesignDialog
    v-model:open="open"
    title="Velg video"
    description="Filer som har kommet inn fra eksportsystemet."
  >
    <template #default="{ initialFocus }">
      <div class="flex flex-col gap-4">
        <DesignInput
          :ref="initialFocus"
          v-model="query"
          placeholder="Søk på navn eller Mediabanken-ID..."
          icon="tabler:search"
        />

        <div class="flex max-h-96 flex-col gap-1 overflow-y-auto">
          <p
            v-if="options.length === 0"
            class="text-body-3 text-text-hint py-8 text-center"
          >
            Ingen filer matcher søket.
          </p>

          <button
            v-for="{ asset, takenBy } in options"
            :key="asset.id"
            type="button"
            class="hover:bg-surface-indent flex cursor-pointer items-center gap-3 rounded-xl px-3 py-2.5 text-left"
            @click="choose(asset.id)"
          >
            <Icon name="tabler:movie" class="text-text-hint size-5 shrink-0" />
            <span class="min-w-0 flex-1">
              <span class="text-title-3 text-text-default block truncate">
                {{ asset.name }}
              </span>
              <span class="text-caption-1 text-text-muted block truncate">
                {{ asset.mediabankenId }} &middot;
                {{ formatDuration(asset.duration) }}
              </span>
            </span>
            <DesignBadge v-if="takenBy" variant="warning">
              Brukt av {{ takenBy.title }}
            </DesignBadge>
            <DesignBadge v-else variant="success">Ledig</DesignBadge>
          </button>
        </div>
      </div>
    </template>
  </DesignDialog>
</template>
