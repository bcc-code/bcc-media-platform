export interface ConfirmOptions {
  title: string
  description?: string
  confirmLabel?: string
  cancelLabel?: string
  intent?: 'neutral' | 'danger'
}

interface ConfirmState {
  options: ConfirmOptions | null
  open: boolean
  resolve: ((value: boolean) => void) | null
}

export const useConfirmState = () =>
  useState<ConfirmState>('confirm', () => ({
    options: null,
    open: false,
    resolve: null
  }))

export const useConfirm = () => {
  const state = useConfirmState()
  return (options: ConfirmOptions): Promise<boolean> =>
    new Promise((resolve) => {
      state.value.resolve?.(false)
      state.value = { options, open: true, resolve }
    })
}
