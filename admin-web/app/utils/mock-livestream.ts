export interface LivestreamConfig {
  liveOnline: boolean
  livestreamUrl: string
  npawEnabled: boolean
  updatedAt: string
  updatedBy: string
}

export const mockLivestream: LivestreamConfig = {
  liveOnline: true,
  livestreamUrl: 'https://live.bcc.media/live/index.m3u8',
  npawEnabled: true,
  updatedAt: '2026-08-21T07:12:00Z',
  updatedBy: 'Marit Solberg'
}
