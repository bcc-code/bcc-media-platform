import type { CombinedError } from '@urql/vue'

export interface GraphQLErrorMessage {
  title: string
  description: string
}

const knownStatuses = [400, 401, 403, 404, 408, 429, 500, 502, 503, 504]

export function useGraphQLError() {
  const { t } = useI18n()

  function formatGraphQLError(
    error: CombinedError | undefined | null
  ): GraphQLErrorMessage {
    const unknown = {
      title: t('errors.generic.title'),
      description: t('errors.generic.description')
    }

    if (!error) return unknown

    const status = error.response?.status as number | undefined
    if (status && knownStatuses.includes(status)) {
      return {
        title: t(`errors.http.${status}.title`),
        description: t(`errors.http.${status}.description`)
      }
    }

    if (error.networkError) {
      return {
        title: t('errors.network.title'),
        description: t('errors.network.description')
      }
    }

    // Messages from the API are passed through untranslated — they are
    // produced by the backend in whatever language it emits.
    if (error.graphQLErrors.length > 0) {
      return {
        title: t('errors.generic.title'),
        description: error.graphQLErrors[0]!.message
      }
    }

    return unknown
  }

  return { formatGraphQLError }
}
