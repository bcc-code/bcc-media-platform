class Progress {
    private static episodes: {
        [id: string]: number | null
    } = {}

    public static get(episode: { id: string; progress?: null | number }) {
        return (Progress.episodes[episode.id] ??= episode.progress ?? null)
    }

    public static set(id: string, progress: null | number) {
        Progress.episodes[id] = progress
    }
}

export const setProgress = Progress.set

export const getProgress = Progress.get
