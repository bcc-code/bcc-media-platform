const assets = ref<Asset[]>([...mockAssets])

export function useAssets() {
  const { episodes } = useEpisodes()

  function byId(id: string | null): Asset | undefined {
    if (!id) return undefined
    return assets.value.find((a) => a.id === id)
  }

  /**
   * Episodes own the link (`episodes.asset_id`), so "is this file in use?"
   * is derived rather than stored on the asset.
   */
  function linkedEpisode(assetId: string): Episode | undefined {
    return episodes.value.find((e) => e.assetId === assetId)
  }

  const unlinked = computed(() =>
    assets.value.filter((a) => !linkedEpisode(a.id))
  )

  return { assets, byId, linkedEpisode, unlinked }
}
