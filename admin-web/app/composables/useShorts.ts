const shorts = ref<Short[]>([...mockShorts])

export function useShorts() {
  const { episodes } = useEpisodes()
  const { byId: assetById } = useAssets()

  function add(short: Short) {
    shorts.value.unshift(short)
  }

  function update(id: string, data: Partial<Short>) {
    const index = shorts.value.findIndex((s) => s.id === id)
    if (index !== -1) {
      shorts.value[index] = { ...shorts.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    shorts.value = shorts.value.filter((s) => s.id !== id)
  }

  function episodeFor(short: Short): Episode | undefined {
    return episodes.value.find((e) => e.id === short.episodeId)
  }

  /** Only episodes that actually have a video can be clipped. */
  const clippableEpisodes = computed(() =>
    episodes.value.filter((e) => e.assetId !== null)
  )

  function episodeDuration(episodeId: string): number {
    const episode = episodes.value.find((e) => e.id === episodeId)
    return assetById(episode?.assetId ?? null)?.duration ?? 0
  }

  return {
    shorts,
    add,
    update,
    remove,
    episodeFor,
    clippableEpisodes,
    episodeDuration
  }
}
