import videojs from "video.js"
import type { Event } from 'video.js/dist/types/event-target'
import type { Player } from ".."

const Button = videojs.getComponent("Button")

export class SeekForwardButton extends Button {
    constructor(player: Player, options = {}) {
        super(player, options)
        this.player_ = player
        this.addClass("vjs-seek-forward-control")
    }

    handleClick(_e: Event) {
        this.player_.currentTime(this.player_.currentTime() + 15)
    }
}

export class SeekBackwardButton extends Button {
    constructor(player: Player, options = {}) {
        super(player, options)
        this.player_ = player
        this.addClass("vjs-seek-backward-control")
    }

    handleClick(_e: Event) {
        this.player_.currentTime(this.player_.currentTime() - 15)
    }
}
