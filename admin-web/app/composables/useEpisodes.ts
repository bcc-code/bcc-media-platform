import { useQuery } from '@urql/vue'
import { graphql } from '~/api'

const GetEpisodesDocument = graphql(`
  query GetEpisodes($filter: String!) {
    preview {
      collection(filter: $filter) {
        items {
          id
          title
          collection
        }
      }
    }
  }
`)

export function useEpisodes(filter: MaybeRef<string> = '') {
  const result = useQuery({
    query: GetEpisodesDocument,
    variables: computed(() => ({
      filter: toValue(filter)
    }))
  })

  const episodes = computed(
    () =>
      result.data.value?.preview.collection.items.filter(
        (item) => item.collection === 'episodes'
      ) ?? []
  )

  return {
    episodes,
    fetching: result.fetching,
    error: result.error
  }
}
