// @ts-ignore
import MenuButton from "./MenuButton"
// @ts-ignore
import MenuItem from "./MenuItem"

export type MenuItem = {
    label: string
    value: string
    selected: boolean
}
export function createVjsMenuButton(
    player: any,
    config: {
        placement: number
        title: string
        id: string
        icon: string
        items: MenuItem[]
        onClick: (item: MenuItem) => void
    }
) {
    let _button = new MenuButton(player, config.title, config.id)

    const buttonInstance = player.controlBar.addChild(
        _button,
        {},
        config.placement
    )

    buttonInstance.menuButton_.$(".vjs-icon-placeholder").className +=
        ` ${config.icon}`
    buttonInstance.removeClass("vjs-hidden")

    const menuItems = config.items.map(
        (item) => new MenuItem(player, item, config.onClick)
    )
    _button.createItems = () => menuItems
    _button.update()
}
