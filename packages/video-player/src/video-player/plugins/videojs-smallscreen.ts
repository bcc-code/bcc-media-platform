import videojs from "video.js"
import debounce from "../utils/debounce.js"

videojs.registerPlugin("smallScreen", function (options) {
    var controlBarClickHandler = (e: any) => {
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
                this.controlBar
                    .el()
                    .removeEventListener("click", controlBarClickHandler)
                this.removeClass("vjs-smallscreen-ui")
            }
        }, 100)
    )
})
