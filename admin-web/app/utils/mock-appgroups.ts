export interface ApplicationGroup {
  id: string
  label: string
}

export const mockApplicationGroups: ApplicationGroup[] = [
  { id: 'bccm', label: 'BCC Media' },
  { id: 'kids', label: 'Bible Kids' },
  { id: 'live', label: 'Live' },
  { id: 'play', label: 'Play' }
]

export function applicationGroupLabel(id: string): string {
  return mockApplicationGroups.find((g) => g.id === id)?.label ?? id
}
