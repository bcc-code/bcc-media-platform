import type {
  AccessLevel,
  AdminResource,
  PermissionInput,
  SearchType
} from '~/api/graphql'

export const adminResources: {
  value: AdminResource
  label: string
  description: string
}[] = [
  {
    value: 'search',
    label: 'Søk',
    description: 'Søk i episoder, sesonger og serier'
  },
  {
    value: 'preview',
    label: 'Forhåndsvisning',
    description: 'Forhåndsvis innhold og mediefiler'
  },
  {
    value: 'statistics',
    label: 'Statistikk',
    description: 'Fremdrift og bruksstatistikk'
  },
  {
    value: 'episodes',
    label: 'Episoder',
    description: 'Import av tidsmetadata for episoder'
  },
  {
    value: 'mediaItems',
    label: 'Mediefiler',
    description: 'Import av tidsmetadata for mediefiler'
  }
]

export const accessLevelLabels: Record<AccessLevel, string> = {
  read: 'Lese',
  write: 'Skrive'
}

export const searchTypeItems: { label: string; value: SearchType }[] = [
  { label: 'Episoder', value: 'episode' },
  { label: 'Sesonger', value: 'season' },
  { label: 'Serier', value: 'show' }
]

export function resourceLabel(resource: AdminResource) {
  return adminResources.find((r) => r.value === resource)?.label ?? resource
}

export interface PermissionLike {
  resource: AdminResource
  level: AccessLevel
  forcedFilter?: {
    search?: {
      group?: string | null
      types?: SearchType[] | null
    } | null
  } | null
}

// Query results carry nulls and __typename; inputs must not.
export function toPermissionInputs(
  permissions: readonly PermissionLike[]
): PermissionInput[] {
  return permissions.map((p) => {
    const search = p.forcedFilter?.search
    const input: PermissionInput = { resource: p.resource, level: p.level }
    if (search && (search.group || search.types?.length)) {
      input.forcedFilter = {
        search: {
          group: search.group || undefined,
          types: search.types?.length ? [...search.types] : undefined
        }
      }
    }
    return input
  })
}

// Order-insensitive, so toggling a grant off and on again reads as unchanged.
export function samePermissions(a: PermissionInput[], b: PermissionInput[]) {
  const key = (list: PermissionInput[]) =>
    JSON.stringify(
      toPermissionInputs(list)
        .map((p) => ({
          ...p,
          forcedFilter: p.forcedFilter?.search
            ? {
                search: {
                  group: p.forcedFilter.search.group ?? null,
                  types: [...(p.forcedFilter.search.types ?? [])].sort()
                }
              }
            : null
        }))
        .sort((x, y) => x.resource.localeCompare(y.resource))
    )
  return key(a) === key(b)
}

export function permissionSummary(permissions: readonly PermissionLike[]) {
  if (permissions.length === 0) return 'Ingen tilgang'
  return permissions
    .map(
      (p) =>
        `${resourceLabel(p.resource)} (${accessLevelLabels[p.level].toLowerCase()})`
    )
    .join(', ')
}

export type ApiKeyStatus = 'active' | 'expired' | 'revoked'

export function apiKeyStatus(key: {
  expiresAt?: string | null
  revokedAt?: string | null
}): ApiKeyStatus {
  if (key.revokedAt) return 'revoked'
  if (key.expiresAt && new Date(key.expiresAt).getTime() <= Date.now())
    return 'expired'
  return 'active'
}

export const apiKeyStatusConfig: Record<
  ApiKeyStatus,
  { label: string; variant: 'success' | 'warning' | 'neutral' }
> = {
  active: { label: 'Aktiv', variant: 'success' },
  expired: { label: 'Utløpt', variant: 'warning' },
  revoked: { label: 'Tilbakekalt', variant: 'neutral' }
}

export function formatDate(value?: string | null) {
  if (!value) return '—'
  return new Date(value).toLocaleDateString('nb-NO', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}
