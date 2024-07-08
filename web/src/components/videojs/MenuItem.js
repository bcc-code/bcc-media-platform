import videojs from "video.js"

// Concrete classes
const VideoJsMenuItemClass = videojs.getComponent("MenuItem")

/**
 * Extend vjs menu item class.
 */
export default class ConcreteMenuItem extends VideoJsMenuItemClass {
    /**
     * Menu item constructor.
     *
     * @param {Player} player - vjs player
     * @param {Object} item - Item object
     */
    constructor(player, item, onClick) {
        super(player, {
            label: item.label,
            selectable: true,
            selected: item.selected || false,
        })
        this.item = item
        this.onClick = onClick
    }

    /**
     * Click event for menu item.
     */
    handleClick() {
        this.onClick(this.item)
    }
}
