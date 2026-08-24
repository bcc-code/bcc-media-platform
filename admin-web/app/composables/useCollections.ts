const collections = ref<Collection[]>([...mockCollections])

export interface CollectionItem {
  ref: string
  target: CollectionTarget
  label: string
  sublabel: string | null
  status: Status
  publishDate: string | null
}

export function useCollections() {
  const { pages } = usePages()
  const { episodes } = useEpisodes()
  const { shows } = useShows()
  const { seasons } = useSeasons()

  function add(collection: Collection) {
    collections.value.unshift(collection)
  }

  function update(id: string, data: Partial<Collection>) {
    const index = collections.value.findIndex((c) => c.id === id)
    if (index !== -1) {
      collections.value[index] = { ...collections.value[index]!, ...data }
    }
  }

  function remove(id: string) {
    collections.value = collections.value.filter((c) => c.id !== id)
  }

  function byId(id: string | null): Collection | undefined {
    if (!id) return undefined
    return collections.value.find((c) => c.id === id)
  }

  /** Everything that can be dropped into a hand-picked collection. */
  function itemsFor(target: CollectionTarget): CollectionItem[] {
    switch (target) {
      case 'episodes':
        return episodes.value.map((e) => ({
          ref: `episodes:${e.id}`,
          target,
          label: e.title,
          sublabel: e.season
            ? `${e.season.show.title} S${e.season.number}E${e.number}`
            : 'Frittstående',
          status: e.status,
          publishDate: e.publishDate
        }))
      case 'shows':
        return shows.value.map((s) => ({
          ref: `shows:${s.id}`,
          target,
          label: s.title,
          sublabel: `${s.seasonCount} sesonger`,
          status: s.status,
          publishDate: null
        }))
      case 'seasons':
        return seasons.value.map((s) => ({
          ref: `seasons:${s.id}`,
          target,
          label: `${s.show.title} — Sesong ${s.number}`,
          sublabel: s.title,
          status: s.status,
          publishDate: null
        }))
      case 'pages':
        return pages.value.map((p) => ({
          ref: `pages:${p.id}`,
          target,
          label: p.title,
          sublabel: p.code,
          status: p.status,
          publishDate: null
        }))
    }
  }

  const allItems = computed<CollectionItem[]>(() => [
    ...itemsFor('episodes'),
    ...itemsFor('shows'),
    ...itemsFor('seasons'),
    ...itemsFor('pages')
  ])

  function resolveRef(itemRef: string): CollectionItem | undefined {
    return allItems.value.find((i) => i.ref === itemRef)
  }

  /** Runs a query against the mock data so the editor can preview matches. */
  function matchesForQuery(query: CollectionQuery): CollectionItem[] {
    let items = itemsFor(query.target)

    if (query.status.length > 0) {
      items = items.filter((i) => query.status.includes(i.status))
    }

    if (query.titleContains?.trim()) {
      const needle = query.titleContains.trim().toLowerCase()
      items = items.filter((i) => i.label.toLowerCase().includes(needle))
    }

    if (query.publishedWithinDays !== null) {
      const cutoff = Date.now() - query.publishedWithinDays * 86400000
      items = items.filter((i) =>
        i.publishDate ? new Date(i.publishDate).getTime() >= cutoff : false
      )
    }

    items = [...items].sort((a, b) => {
      if (query.orderBy === 'title_asc') return a.label.localeCompare(b.label)
      const at = a.publishDate ? new Date(a.publishDate).getTime() : 0
      const bt = b.publishDate ? new Date(b.publishDate).getTime() : 0
      return query.orderBy === 'publish_date_asc' ? at - bt : bt - at
    })

    return query.limit !== null ? items.slice(0, query.limit) : items
  }

  /** Which sections reference a collection — shown before deleting one. */
  function usedBy(collectionId: string) {
    return pages.value.flatMap((page) =>
      page.sections
        .filter((s) => s.collectionId === collectionId)
        .map((section) => ({ page, section }))
    )
  }

  return {
    collections,
    add,
    update,
    remove,
    byId,
    itemsFor,
    resolveRef,
    matchesForQuery,
    usedBy
  }
}
