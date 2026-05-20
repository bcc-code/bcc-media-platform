export interface Application {
  id: string
  code: string
  clientVersion: string
  livestreamEnabled: boolean
}

const codeLabels: Record<string, string> = {
  'bccm-mobile': 'BCC Media - Mobile',
  'bccm-web': 'BCC Media - Web',
  'bccm-tvos': 'BCC Media - tvOS',
  'kids-mobile': 'Bible Kids - Mobile',
  'kids-web': 'Bible Kids - Web',
  'kids-tvos': 'Bible Kids - tvOS',
  'live-mobile': 'Live - Mobile',
  'live-web': 'Live - Web',
  'live-tvos': 'Live - tvOS',
  'play-mobile': 'Play - Mobile',
  'play-web': 'Play - Web',
  'play-tvos': 'Play - tvOS'
}

export function applicationLabel(code: string): string {
  return codeLabels[code] ?? code
}

export const mockApplications: Application[] = [
  {
    id: '1',
    code: 'bccm-mobile',
    clientVersion: '4.2.0',
    livestreamEnabled: true
  },
  {
    id: '2',
    code: 'bccm-web',
    clientVersion: '2.1.0',
    livestreamEnabled: true
  },
  {
    id: '3',
    code: 'bccm-tvos',
    clientVersion: '3.0.1',
    livestreamEnabled: true
  },
  {
    id: '4',
    code: 'kids-mobile',
    clientVersion: '2.0.0',
    livestreamEnabled: false
  },
  {
    id: '5',
    code: 'kids-web',
    clientVersion: '1.5.0',
    livestreamEnabled: false
  },
  {
    id: '6',
    code: 'kids-tvos',
    clientVersion: '1.2.0',
    livestreamEnabled: false
  },
  {
    id: '7',
    code: 'live-mobile',
    clientVersion: '3.1.0',
    livestreamEnabled: true
  },
  {
    id: '8',
    code: 'live-web',
    clientVersion: '2.0.0',
    livestreamEnabled: true
  },
  {
    id: '9',
    code: 'live-tvos',
    clientVersion: '1.8.0',
    livestreamEnabled: true
  },
  {
    id: '10',
    code: 'play-mobile',
    clientVersion: '1.0.0',
    livestreamEnabled: false
  },
  {
    id: '11',
    code: 'play-web',
    clientVersion: '1.0.0',
    livestreamEnabled: false
  },
  {
    id: '12',
    code: 'play-tvos',
    clientVersion: '1.0.0',
    livestreamEnabled: false
  }
]
