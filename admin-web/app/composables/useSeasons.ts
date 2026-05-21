const seasons = ref<Season[]>([...mockSeasons])

export function useSeasons() {
  function add(season: Season) {
    seasons.value.unshift(season)
  }

  function update(id: string, data: Partial<Season>) {
    const index = seasons.value.findIndex((s) => s.id === id)
    if (index !== -1) {
      seasons.value[index] = { ...seasons.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    seasons.value = seasons.value.filter((s) => s.id !== id)
  }

  return { seasons, add, update, remove }
}
