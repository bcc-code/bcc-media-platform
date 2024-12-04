import videojs from "video.js"
import SeekBar from "video.js/dist/types/control-bar/progress-control/seek-bar"
import type { Player } from ".."

const PSeekBar = videojs.getComponent("SeekBar") as any as {
    new (player: Player, options?: Record<string, string> | undefined): SeekBar
    prototype: SeekBar
}

var oldGetPercent = PSeekBar.prototype.getPercent

PSeekBar.prototype.getPercent = function getPercent() {
    const liveTracker = this.player_.liveTracker
    if (liveTracker && liveTracker.isLive()) {
        return oldGetPercent.bind(this)()
    }
    // Allows for smooth scrubbing, when player can't keep up.
    // const time = (this.player_.scrubbing()) ?
    //   this.player_.getCache().currentTime :
    //   this.player_.currentTime()
    const time = this.player_.currentTime()
    const percent = time / this.player_.duration()
    return percent >= 1 ? 1 : percent
}

var oldHandleMouseMove = PSeekBar.prototype.handleMouseMove
PSeekBar.prototype.handleMouseMove = function handleMouseMove(event) {
    const liveTracker = this.player_.liveTracker
    if (liveTracker && liveTracker.isLive()) {
        return oldHandleMouseMove.bind(this, event)()
    }
    let newTime = this.calculateDistance(event) * this.player_.duration()
    if (newTime === this.player_.duration()) {
        newTime = newTime - 0.1
    }
    this.player_.currentTime(newTime)
    this.update()
}
