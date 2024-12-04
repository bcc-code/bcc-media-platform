import videojs from "video.js"
import debounce from "../utils/debounce.js"
import { Player } from ".."

videojs.registerPlugin("smallScreen", function (this: Player) {
    const controlBarClickHandler = (e: any) => {
        this.userActive(!this.userActive())
        e.stopPropagation()
    }
    let isSmallScreen = false;

    this.on(
        "playerresize",
        debounce(() => {
            if (
                !isSmallScreen &&
                videojs.browser.TOUCH_ENABLED &&
                screen.width < 768
            ) {
                isSmallScreen = true
                // @ts-ignore Types are outdated
                this.controlBar
                    .el()
                    .addEventListener("click", controlBarClickHandler)
                this.addClass("vjs-smallscreen-ui")
            } else if (
                isSmallScreen &&
                screen.width >= 768 &&
                !this.isFullscreen()
            ) {
                isSmallScreen = false
                // @ts-ignore Types are outdated
                this.controlBar
                    .el()
                    .removeEventListener("click", controlBarClickHandler)
                this.removeClass("vjs-smallscreen-ui")
            }
        }, 100)
    )
})
