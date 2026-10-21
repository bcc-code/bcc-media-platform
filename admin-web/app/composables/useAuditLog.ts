// Read-only audit log of admin API write actions. Superuser only.
import { useQuery } from '@urql/vue'
import type { MaybeRefOrGetter } from 'vue'
import { graphql } from '~/api'
import type { AuditLogFilter } from '~/api/graphql'

export type { AuditLogEntryFieldsFragment as AuditLogItem } from '~/api/graphql'

export const auditLogPageSize = 50

graphql(`
  fragment AuditLogEntryFields on AuditLogEntry {
    id
    createdAt
    action
    arguments
    authMethod
    userId
    userEmail
    apiKeyId
    apiKeyName
    userHeader
    success
    error
  }
`)

const GetAuditLogDocument = graphql(`
  query GetAuditLog($first: Int, $offset: Int, $filter: AuditLogFilter) {
    access {
      auditLog(first: $first, offset: $offset, filter: $filter) {
        total
        items {
          ...AuditLogEntryFields
        }
      }
    }
  }
`)

const GetAuditLogActionsDocument = graphql(`
  query GetAuditLogActions {
    access {
      auditLogActions
    }
  }
`)

export function useAuditLog(
  page: MaybeRefOrGetter<number>,
  filter: MaybeRefOrGetter<AuditLogFilter>
) {
  const result = useQuery({
    query: GetAuditLogDocument,
    variables: computed(() => ({
      first: auditLogPageSize,
      offset: toValue(page) * auditLogPageSize,
      filter: toValue(filter)
    })),
    requestPolicy: 'cache-and-network'
  })

  const entries = computed(() => result.data.value?.access.auditLog.items ?? [])
  const total = computed(() => result.data.value?.access.auditLog.total ?? 0)

  return {
    entries,
    total,
    fetching: result.fetching,
    error: result.error,
    refetch: () => result.executeQuery({ requestPolicy: 'network-only' })
  }
}

export function useAuditLogActions() {
  const result = useQuery({ query: GetAuditLogActionsDocument })
  return {
    actions: computed(() => result.data.value?.access.auditLogActions ?? [])
  }
}
