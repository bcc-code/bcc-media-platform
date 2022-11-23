import { ready, load, track, identify, page as rpage } from "rudder-sdk-js"
import { ref } from "vue"
import { Events, IdentifyData, Page } from "./events"
export * from "./events"

const isLoading = ref(true)

ready(() => {
    isLoading.value = false
})

load(
    import.meta.env.VITE_RUDDERSTACK_WRITE_KEY,
    import.meta.env.VITE_RUDDERSTACK_DATA_PLANE_URL
)

export const event = <T extends keyof Events>(event: T, data: Events[T]) => {
    if (data) {
        track(event, data, undefined, undefined)
    } else {
        track(event)
    }
}

export const page = (data: {
    id: Page
    title: string
    meta?: {
        setting?: "webSettings"
    }
}) => {
    rpage(data)
}

export const initialize = async (data: IdentifyData) => {
    identify(data.id, data)
}
