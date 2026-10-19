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

type Level = AccessLevel | 'none'

interface Row {
  level: Level
  group: string
  types: SearchType[]
}

const levelItems = [
  { label: 'Ingen', value: 'none' },
  { label: accessLevelLabels.read, value: 'read' },
  { label: accessLevelLabels.write, value: 'write' }
]

function rowsFrom(permissions: PermissionInput[]) {
  return Object.fromEntries(
    adminResources.map(({ value }) => {
      const p = permissions.find((p) => p.resource === value)
      return [
        value,
        {
          level: p?.level ?? 'none',
          group: p?.forcedFilter?.search?.group ?? '',
          types: [...(p?.forcedFilter?.search?.types ?? [])]
        }
      ]
    })
  ) as Record<AdminResource, Row>
}

const rows = reactive(rowsFrom(model.value))

watch(
  rows,
  () => {
    model.value = adminResources.flatMap(({ value }) => {
      const row = rows[value]
      if (row.level === 'none') return []
      const input: PermissionInput = { resource: value, level: row.level }
      const group = row.group.trim()
      if (value === 'search' && (group || row.types.length)) {
        input.forcedFilter = {
          search: {
            group: group || undefined,
            types: row.types.length ? row.types : undefined
          }
        }
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
          Begrens søket. La feltene stå tomme for å søke i alt.
        </p>
        <DesignInput
          v-model="rows.search.group"
          label="Brukergruppe"
          placeholder="F.eks. bcc-members"
          helper-text="Søk som et medlem av denne gruppen: kun publisert og tilgjengelig innhold."
          :disabled="disabled"
        />
        <div class="flex flex-col gap-2">
          <label class="text-body-3 text-text-muted block">Typer</label>
          <DesignToggleChips
            v-model="typeChips"
            :items="searchTypeItems"
            :disabled="disabled"
          />
        </div>
      </div>
    </div>
  </div>
</template>
