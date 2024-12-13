import { Player } from 'bccm-video-player'
import { MaybeRef, onScopeDispose, ref, unref, watch } from 'vue'

export function usePlayerTime(player: MaybeRef<Player | null | undefined>) {
    const currentTime = ref(0)

    const onTimeUpdate = () => {
        const p = unref(player)
        const now = p?.currentTime()
        if (!now) return
        currentTime.value = now
    }

    watch(
        () => unref(player),
        (next, previous) => {
            previous?.off('timeupdate', onTimeUpdate)
            next?.on('timeupdate', onTimeUpdate)
        }
    )

    onScopeDispose(() => {
        unref(player)?.off('timeupdate', onTimeUpdate)
    })

    return {
        currentTime,
    }
}
