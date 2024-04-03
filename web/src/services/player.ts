import config from "@/config"
import { PlayerFactory } from "bccm-video-player"
import "bccm-video-player/css"
import Auth from "./auth"
import { currentApp } from "./app"
import { ref, watch } from "vue"

const playerFactory = ref(
    new PlayerFactory({
        endpoint: config.api.url + "/query",
        tokenFactory: Auth.getToken,
        application: currentApp.value,
    })
)

export default playerFactory

watch(currentApp, (app) => {
    playerFactory.value = new PlayerFactory({
        endpoint: config.api.url + "/query",
        tokenFactory: Auth.getToken,
        application: app,
    })
})
