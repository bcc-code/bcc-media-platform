import config from "@/config";
import { PlayerFactory } from "btv-video-player";
import "@/../node_modules/btv-video-player/build/style.css"
import Auth from "./auth";

export default new PlayerFactory({
    endpoint: config.api.url,
    tokenFactory: Auth.getToken
})