export type Brand = 'bcc' | 'play' | 'neutral'

export interface BrandInfo {
  value: Brand
  label: string
  description?: string
  swatch: { light: string; dark: string }
}

export const brands: BrandInfo[] = [
  {
    value: 'neutral',
    label: 'Neutral',
    description: 'Svart på hvitt',
    swatch: { light: '#333333', dark: '#ffffff' }
  },
  {
    value: 'play',
    label: 'Play',
    description: 'Litt mer lekent',
    swatch: { light: '#b3acff', dark: '#b3acff' }
  },
  {
    value: 'bcc',
    label: 'BCC',
    description: 'Litt mer offisielt',
    swatch: { light: '#004e48', dark: '#a0cec8' }
  }
]

export function useBrand() {
  const brand = useLocalStorage<Brand>('ui:brand', 'neutral')

  if (import.meta.client) {
    watchEffect(() => {
      document.documentElement.setAttribute('data-brand', brand.value)
    })
  }

  const current = computed(
    () => brands.find((b) => b.value === brand.value) ?? brands[0]!
  )

  return { brand, brands, current }
}
