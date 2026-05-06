import videojs from "video.js"
import type { Player } from ".."
import type { Event } from "video.js/dist/types/event-target"

const Button = videojs.getComponent("Button")

export class DismissControlBarButton extends Button {
    constructor(player: Player, options = {}) {
        super(player, options)
        this.player_ = player
        // @ts-ignore Types are outdated
        this.controlText("Hide controls")
        this.addClass("vjs-dismiss-control")
    }

    handleClick(_e: Event) {
        this.player_.userActive(false)
    }
}
