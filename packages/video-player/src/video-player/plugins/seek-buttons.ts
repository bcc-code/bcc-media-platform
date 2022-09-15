import videojs, { VideoJsPlayer } from "video.js"

const Button = videojs.getComponent("Button")

export class SeekForwardButton extends Button {
    constructor(player: VideoJsPlayer, options = {}) {
        super(player, options)
        this.player_ = player
        this.addClass("vjs-seek-forward-control")
    }

    handleClick(_e: videojs.EventTarget.Event) {
        this.player_.currentTime(this.player_.currentTime() + 15)
    }
}

export class SeekBackwardButton extends Button {
    constructor(player: VideoJsPlayer, options = {}) {
        super(player, options)
        this.player_ = player
        this.addClass("vjs-seek-backward-control")
    }

    handleClick(_e: videojs.EventTarget.Event) {
        this.player_.currentTime(this.player_.currentTime() - 15)
    }
}
