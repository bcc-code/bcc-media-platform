import videojs, { VideoJsPlayer } from "video.js"

const Button = videojs.getComponent("Button")

export class DismissControlBarButton extends Button {
    constructor(player: VideoJsPlayer, options = {}) {
        super(player, options)
        this.player_ = player
        this.controlText("Hide controls")
        this.addClass("vjs-dismiss-control")
    }

    handleClick(_e: videojs.EventTarget.Event) {
        this.player_.userActive(false)
    }
}
