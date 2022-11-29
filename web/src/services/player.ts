import config from "@/config"
import { PlayerFactory } from "bccm-video-player"
import "bccm-video-player/css"
import Auth from "./auth"

export default new PlayerFactory({
    endpoint: config.api.url + "/query",
    tokenFactory: Auth.getToken,
})
