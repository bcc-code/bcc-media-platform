import { Player } from 'bccm-video-player'
import { MaybeRef, onScopeDispose, ref, unref, watch } from 'vue'

export function usePlayerTime(player: MaybeRef<Player | null | undefined>) {
    const currentTime = ref(0)

    const onTimeUpdate = (e: Event) => {
        const now = (e.target as HTMLVideoElement).currentTime
        if (!now) return
        currentTime.value = now
    }

    watch(
        () => unref(player),
        (next, previous) => {
            previous?.mediaEl.removeEventListener('timeupdate', onTimeUpdate)
            next?.mediaEl.addEventListener('timeupdate', onTimeUpdate)
        }
    )

    onScopeDispose(() => {
        unref(player)?.mediaEl.removeEventListener(
            'timeupdate',
            onTimeUpdate
        )
    })

    return {
        currentTime,
    }
}
