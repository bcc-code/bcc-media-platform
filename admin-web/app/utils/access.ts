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
  'mediaItems'
]

export const accessLevelValues: AccessLevel[] = ['read', 'write']

export const searchTypeValues: SearchType[] = ['episode', 'season', 'show']

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
