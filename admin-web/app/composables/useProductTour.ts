import type { TourStepDetails } from '@ark-ui/vue'

export function useProductTour(tourId: string, steps: TourStepDetails[]) {
  const seen = useLocalStorage(`tour:${tourId}:seen`, false)
  const tourRef = ref<{ start: () => void }>()

  function start() {
    tourRef.value?.start()
  }

  function startIfNew() {
    if (!seen.value) {
      nextTick(() => {
        start()
        seen.value = true
      })
    }
  }

  function reset() {
    seen.value = false
  }

  return {
    steps,
    tourRef,
    seen,
    start,
    startIfNew,
    reset
  }
}
