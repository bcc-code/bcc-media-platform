import { definePanel } from "@directus/extensions-sdk"
import PanelComponent from "./panel.vue"

export default definePanel({
    id: "api-tools",
    name: "API Tools",
    icon: "box",
    description: "This panel is used for triggering admin functions.",
    component: PanelComponent,
    options: [
        // {
        // 	field: 'text',
        // 	name: 'Text',
        // 	type: 'string',
        // 	meta: {
        // 		interface: 'input',
        // 		width: 'full',
        // 	},
        // },
    ],
    minWidth: 12,
    minHeight: 8,
})
