<script setup lang="ts">
const props = defineProps<{
  currentEpisodeId?: string
}>()

const assetId = defineModel<string | null>({ required: true })

const { byId } = useAssets()

const asset = computed(() => byId(assetId.value))
const pickerOpen = ref(false)

const arrived = useTimeAgo(
  computed(() => asset.value?.arrivedAt ?? new Date().toISOString())
)
</script>

<template>
  <div class="flex flex-col gap-2">
    <label class="text-body-3 text-text-muted block">Video</label>

    <div
      v-if="asset"
      class="border-border-1 flex items-center gap-3 rounded-xl border px-4 py-3"
    >
      <Icon name="tabler:movie" class="text-text-hint size-5 shrink-0" />
      <div class="min-w-0 flex-1">
        <p class="text-title-3 text-text-default truncate">
          {{ asset.name }}
        </p>
        <p class="text-caption-1 text-text-muted truncate">
          {{ asset.mediabankenId }} &middot;
          {{ formatDuration(asset.duration) }} &middot; kom inn
          {{ arrived }}
        </p>
      </div>
      <DesignButton size="small" variant="secondary" @click="pickerOpen = true">
        Bytt
      </DesignButton>
      <DesignButton
        size="small"
        variant="tertiary"
        intent="danger"
        icon="tabler:x"
        aria-label="Fjern video"
        @click="assetId = null"
      />
    </div>

    <div
      v-else
      class="border-border-1 flex items-center gap-3 rounded-xl border border-dashed px-4 py-3"
    >
      <Icon name="tabler:movie-off" class="text-text-hint size-5 shrink-0" />
      <div class="flex-1">
        <p class="text-title-3 text-text-default">Ingen video valgt</p>
        <p class="text-caption-1 text-text-muted">
          Episoden kan ikke publiseres uten video.
        </p>
      </div>
      <DesignButton size="small" @click="pickerOpen = true">
        Velg video
      </DesignButton>
    </div>

    <AssetPickerDialog
      v-model:open="pickerOpen"
      :current-episode-id="props.currentEpisodeId"
      @select="assetId = $event"
    />
  </div>
</template>
