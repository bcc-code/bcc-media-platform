import config from '@/config'
import { PlayerFactory } from 'bccm-video-player'
import 'bccm-video-player/css'
import Auth from './auth'
import { currentApp } from './app'
import { current } from '@/services/language'
import { getFeatureFlags } from '@/services/feature-flags'
import { useSearch } from '@/utils/search'
import { ref, watch } from 'vue'

const { searchSessionId, sessionId } = useSearch()

const buildHeaders = () => {
    const headers: Record<string, string> = {
        'Accept-Language': current.value.code,
    }
    const flags = getFeatureFlags()
    if (flags) {
        headers['X-Feature-Flags'] = flags
    }
    if (sessionId) {
        headers['X-Session-Id'] = sessionId
    }
    if (searchSessionId.value) {
        headers['X-Search-Session-Id'] = searchSessionId.value
    }
    return headers
}

const playerFactory = ref(
    new PlayerFactory({
        endpoint: config.api.url + '/query',
        tokenFactory: Auth.getToken,
        application: currentApp.value,
        headersFactory: buildHeaders,
    })
)

export default playerFactory

watch(currentApp, (app) => {
    playerFactory.value = new PlayerFactory({
        endpoint: config.api.url + '/query',
        tokenFactory: Auth.getToken,
        application: app,
        headersFactory: buildHeaders,
    })
})
