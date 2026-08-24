const config = ref<LivestreamConfig>({ ...mockLivestream })

export function useLivestream() {
  function update(data: Partial<LivestreamConfig>) {
    config.value = {
      ...config.value,
      ...data,
      updatedAt: new Date().toISOString(),
      updatedBy: 'Deg'
    }
  }

  return { config, update }
}
