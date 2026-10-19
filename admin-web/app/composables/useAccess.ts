// API keys and role grants for the admin API. Superuser only; the API rejects
// everyone else.
import { useMutation, useQuery } from '@urql/vue'
import { graphql } from '~/api'
import type { ApiKeyInput, PermissionInput } from '~/api/graphql'

export type {
  ApiKeyFieldsFragment as ApiKeyItem,
  PermissionFieldsFragment as PermissionItem
} from '~/api/graphql'

graphql(`
  fragment PermissionFields on Permission {
    resource
    level
    forcedFilter {
      search {
        group
        types
      }
    }
  }
`)

graphql(`
  fragment ApiKeyFields on ApiKey {
    id
    name
    prefix
    createdAt
    expiresAt
    revokedAt
    permissions {
      ...PermissionFields
    }
  }
`)

const GetApiKeysDocument = graphql(`
  query GetApiKeys {
    access {
      apiKeys {
        ...ApiKeyFields
      }
    }
  }
`)

const GetRolesDocument = graphql(`
  query GetRoles {
    access {
      roles {
        id
        name
        permissions {
          ...PermissionFields
        }
      }
    }
  }
`)

const CreateApiKeyDocument = graphql(`
  mutation CreateApiKey($input: ApiKeyInput!) {
    access {
      createApiKey(input: $input) {
        key
        apiKey {
          ...ApiKeyFields
        }
      }
    }
  }
`)

const UpdateApiKeyDocument = graphql(`
  mutation UpdateApiKey($id: ID!, $input: ApiKeyInput!) {
    access {
      updateApiKey(id: $id, input: $input) {
        ...ApiKeyFields
      }
    }
  }
`)

const RevokeApiKeyDocument = graphql(`
  mutation RevokeApiKey($id: ID!) {
    access {
      revokeApiKey(id: $id)
    }
  }
`)

const SetRolePermissionsDocument = graphql(`
  mutation SetRolePermissions($roleId: ID!, $permissions: [PermissionInput!]!) {
    access {
      setRolePermissions(roleId: $roleId, permissions: $permissions) {
        id
        name
        permissions {
          ...PermissionFields
        }
      }
    }
  }
`)

// Typename hints so the document cache refetches lists after mutations that
// return no entity (revoke) or a new one (create).
const apiKeyContext = { additionalTypenames: ['ApiKey'] }
const roleContext = { additionalTypenames: ['Role'] }

export function useApiKeys() {
  const result = useQuery({ query: GetApiKeysDocument, context: apiKeyContext })

  const apiKeys = computed(() => result.data.value?.access.apiKeys ?? [])

  const create = useMutation(CreateApiKeyDocument)
  const update = useMutation(UpdateApiKeyDocument)
  const revoke = useMutation(RevokeApiKeyDocument)

  return {
    apiKeys,
    fetching: result.fetching,
    error: result.error,
    refetch: () => result.executeQuery({ requestPolicy: 'network-only' }),
    async create(input: ApiKeyInput) {
      const res = await create.executeMutation({ input }, apiKeyContext)
      return { key: res.data?.access.createApiKey.key, error: res.error }
    },
    async update(id: string, input: ApiKeyInput) {
      const res = await update.executeMutation({ id, input }, apiKeyContext)
      return { error: res.error }
    },
    async revoke(id: string) {
      const res = await revoke.executeMutation({ id }, apiKeyContext)
      return { error: res.error }
    }
  }
}

export function useRoles() {
  const result = useQuery({ query: GetRolesDocument, context: roleContext })

  const roles = computed(() => result.data.value?.access.roles ?? [])

  const setPermissions = useMutation(SetRolePermissionsDocument)

  return {
    roles,
    fetching: result.fetching,
    error: result.error,
    async setPermissions(roleId: string, permissions: PermissionInput[]) {
      const res = await setPermissions.executeMutation(
        { roleId, permissions },
        roleContext
      )
      return { error: res.error }
    }
  }
}
