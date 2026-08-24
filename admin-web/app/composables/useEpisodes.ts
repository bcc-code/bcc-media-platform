const episodes = ref<Episode[]>([...mockEpisodes])

export function useEpisodes() {
  function add(episode: Episode) {
    episodes.value.unshift(episode)
  }

  function update(id: string, data: Partial<Episode>) {
    const index = episodes.value.findIndex((e) => e.id === id)
    if (index !== -1) {
      episodes.value[index] = { ...episodes.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    episodes.value = episodes.value.filter((e) => e.id !== id)
  }

  /** Episodes that cannot be published yet because no video has arrived. */
  const missingVideo = computed(() =>
    episodes.value.filter((e) => e.assetId === null)
  )

  return { episodes, add, update, remove, missingVideo }
}
