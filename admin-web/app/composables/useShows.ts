const shows = ref<Show[]>([...mockShows])

export function useShows() {
  function add(show: Show) {
    shows.value.unshift(show)
  }

  function update(id: string, data: Partial<Show>) {
    const index = shows.value.findIndex((s) => s.id === id)
    if (index !== -1) {
      shows.value[index] = { ...shows.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    shows.value = shows.value.filter((s) => s.id !== id)
  }

  return { shows, add, update, remove }
}
