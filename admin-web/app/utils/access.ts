import type {
  AccessLevel,
  AdminResource,
  PermissionInput,
  SearchType
} from '~/api/graphql'

/** Resource order as shown in the permission editor. Labels live in i18n. */
export const adminResourceValues: AdminResource[] = [
  'search',
  'preview',
  'statistics',
  'episodes',
  'mediaItems',
  'episodeAccess'
]

export const accessLevelValues: AccessLevel[] = ['read', 'write']

export const searchTypeValues: SearchType[] = ['episode', 'season', 'show']

export interface PermissionLike {
  resource: AdminResource
  level: AccessLevel
  scope?: {
    search?: {
      group?: string | null
      types?: SearchType[] | null
    } | null
    episodeAccess?: {
      // ID inputs are typed string | number.
      groups?: (string | number)[] | null
    } | null
  } | null
}

// Query results carry nulls and __typename; inputs must not.
export function toPermissionInputs(
  permissions: readonly PermissionLike[]
): PermissionInput[] {
  return permissions.map((p) => {
    const search = p.scope?.search
    const groups = p.scope?.episodeAccess?.groups
    const input: PermissionInput = { resource: p.resource, level: p.level }
    if (search && (search.group || search.types?.length)) {
      input.scope = {
        search: {
          group: search.group || undefined,
          types: search.types?.length ? [...search.types] : undefined
        }
      }
    }
    if (groups?.length) {
      input.scope = { episodeAccess: { groups: groups.map(String) } }
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
          scope: p.scope?.search
            ? {
                search: {
                  group: p.scope.search.group ?? null,
                  types: [...(p.scope.search.types ?? [])].sort()
                }
              }
            : p.scope?.episodeAccess
              ? {
                  episodeAccess: {
                    groups: (p.scope.episodeAccess.groups ?? [])
                      .map(String)
                      .sort()
                  }
                }
              : null
        }))
        .sort((x, y) => x.resource.localeCompare(y.resource))
    )
  return key(a) === key(b)
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

export const apiKeyStatusVariants: Record<
  ApiKeyStatus,
  'success' | 'warning' | 'neutral'
> = {
  active: 'success',
  expired: 'warning',
  revoked: 'neutral'
}
