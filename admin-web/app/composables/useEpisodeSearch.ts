// The one composable that talks to the real admin API. Currently unused —
// the episode pages run on mock data while the UX is being tried out — but
// kept as the working reference for the urql + codegen wiring.
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

export function useEpisodeSearch(filter: MaybeRef<string> = '') {
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
