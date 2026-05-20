import { createToaster } from '@ark-ui/vue'

export const useToast = () => {
  return useState('toaster', () =>
    createToaster({
      placement: 'bottom-end',
      overlap: false,
      gap: 12,
      duration: 5000
    })
  )
}
