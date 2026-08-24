const pages = ref<Page[]>([...mockPages])

export function usePages() {
  function add(page: Page) {
    pages.value.unshift(page)
  }

  function update(id: string, data: Partial<Page>) {
    const index = pages.value.findIndex((p) => p.id === id)
    if (index !== -1) {
      pages.value[index] = { ...pages.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    pages.value = pages.value.filter((p) => p.id !== id)
  }

  function setSections(id: string, sections: PageSection[]) {
    update(id, { sections })
  }

  return { pages, add, update, remove, setSections }
}
