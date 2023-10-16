import config from "@/config"
import { PlayerFactory } from "bccm-video-player"
import "bccm-video-player/css"
import Auth from "./auth"
import { current } from "./app"
import { ref, watch } from "vue"

const playerFactory = ref(
    new PlayerFactory({
        endpoint: config.api.url + "/query",
        tokenFactory: Auth.getToken,
        application: current.value,
    })
)

export default playerFactory

watch(current, (app) => {
    playerFactory.value = new PlayerFactory({
        endpoint: config.api.url + "/query",
        tokenFactory: Auth.getToken,
        application: app,
    })
})
