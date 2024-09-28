import { defineInterface } from "@directus/extensions-sdk"
import InterfaceComponent from "./interface.vue"

export default defineInterface({
    id: "timedmetadata-tools",
    name: "Timed Metadata Tools",
    icon: "box",
    description: "Use this interface to import timedmetadata",
    component: InterfaceComponent,
    options: null,
    types: ["alias"],
    localTypes: ["presentation", "standard"],
    group: "presentation",
})
