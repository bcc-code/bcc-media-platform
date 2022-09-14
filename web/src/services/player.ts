import config from "@/config";
import { PlayerFactory } from "bccm-video-player";
import "@/../node_modules/bccm-video-player/build/style.css"
import Auth from "./auth";

export default new PlayerFactory({
    endpoint: config.api.url,
    tokenFactory: Auth.getToken
})
