import videojs, { VideoJsPlayer } from "video.js"

const SeekBar = videojs.getComponent("SeekBar") as any as {
    new (player: VideoJsPlayer, options?: videojs.SliderOptions | undefined): videojs.SeekBar;
    prototype: videojs.SeekBar;
}

var oldGetPercent = SeekBar.prototype.getPercent

SeekBar.prototype.getPercent = function getPercent() {
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

var oldHandleMouseMove = SeekBar.prototype.handleMouseMove
SeekBar.prototype.handleMouseMove = function handleMouseMove(event) {
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
