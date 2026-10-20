<script setup lang="ts">
import type {
  AccessLevel,
  AdminResource,
  PermissionInput,
  SearchType
} from '~/api/graphql'

defineProps<{
  disabled?: boolean
}>()

const model = defineModel<PermissionInput[]>({ required: true })

const { t } = useI18n()
const { adminResources, levelItems, searchTypeItems } = useAccessMeta()

type Level = AccessLevel | 'none'

interface Row {
  level: Level
  group: string
  types: SearchType[]
  groups: string[]
}

function rowsFrom(permissions: PermissionInput[]) {
  return Object.fromEntries(
    adminResourceValues.map((value) => {
      const p = permissions.find((p) => p.resource === value)
      return [
        value,
        {
          level: p?.level ?? 'none',
          group: p?.scope?.search?.group ?? '',
          types: [...(p?.scope?.search?.types ?? [])],
          groups: (p?.scope?.episodeAccess?.groups ?? []).map(String)
        }
      ]
    })
  ) as Record<AdminResource, Row>
}

const rows = reactive(rowsFrom(model.value))

watch(
  rows,
  () => {
    model.value = adminResourceValues.flatMap((value) => {
      const row = rows[value]
      if (row.level === 'none') return []
      const input: PermissionInput = { resource: value, level: row.level }
      const group = row.group.trim()
      if (value === 'search' && (group || row.types.length)) {
        input.scope = {
          search: {
            group: group || undefined,
            types: row.types.length ? row.types : undefined
          }
        }
      }
      if (value === 'episodeAccess' && row.groups.length) {
        input.scope = { episodeAccess: { groups: row.groups } }
      }
      return [input]
    })
  },
  { deep: true }
)

const typeChips = computed({
  get: () => rows.search.types as string[],
  set: (value) => {
    rows.search.types = value as SearchType[]
  }
})
</script>

<template>
  <div class="border-border-1 flex flex-col rounded-xl border">
    <div
      v-for="(resource, i) in adminResources"
      :key="resource.value"
      class="flex flex-col gap-4 px-4 py-3"
      :class="{ 'border-border-1 border-t': i > 0 }"
    >
      <div class="flex items-center justify-between gap-4">
        <div>
          <p class="text-title-3 text-text-default">{{ resource.label }}</p>
          <p class="text-caption-1 text-text-muted mt-0.5">
            {{ resource.description }}
          </p>
        </div>
        <DesignSegmentGroup
          v-model="rows[resource.value].level"
          :items="levelItems"
          :class="{ 'pointer-events-none opacity-50': disabled }"
        />
      </div>

      <div
        v-if="resource.value === 'search' && rows.search.level !== 'none'"
        class="bg-surface-indent flex flex-col gap-4 rounded-xl p-4"
      >
        <p class="text-body-3 text-text-muted">
          {{ t('access.permissions.searchFilterHint') }}
        </p>
        <DesignInput
          v-model="rows.search.group"
          :label="t('access.permissions.groupLabel')"
          :placeholder="t('access.permissions.groupPlaceholder')"
          :helper-text="t('access.permissions.groupHelper')"
          :disabled="disabled"
        />
        <div class="flex flex-col gap-2">
          <label class="text-body-3 text-text-muted block">
            {{ t('access.permissions.typesLabel') }}
          </label>
          <DesignToggleChips
            v-model="typeChips"
            :items="searchTypeItems"
            :disabled="disabled"
          />
        </div>
      </div>

      <div
        v-if="
          resource.value === 'episodeAccess' &&
          rows.episodeAccess.level !== 'none'
        "
        class="bg-surface-indent flex flex-col gap-4 rounded-xl p-4"
      >
        <p class="text-body-3 text-text-muted">
          {{ t('access.permissions.episodeAccessHint') }}
        </p>
        <DesignTagsInput
          v-model="rows.episodeAccess.groups"
          :label="t('access.permissions.groupsLabel')"
          :placeholder="t('access.permissions.groupsPlaceholder')"
          :disabled="disabled"
        />
      </div>
    </div>
  </div>
</template>
