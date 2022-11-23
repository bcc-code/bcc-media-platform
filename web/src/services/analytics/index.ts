import { ready, load, track, identify, page as rpage } from "rudder-sdk-js"
import { ref } from "vue"
import { AgeGroup, Events, IdentifyData, Page } from "./events"
export * from "./events"

const isLoading = ref(true)

ready(() => {
    isLoading.value = false
})

load(
    import.meta.env.VITE_RUDDERSTACK_WRITE_KEY,
    import.meta.env.VITE_RUDDERSTACK_DATA_PLANE_URL
)

export const getAgeGroup = (age?: number): AgeGroup => {
    const breakpoints: {
        [key: number]: AgeGroup
    } = {
        "9": "< 10",
        "12": "10 - 12",
        "18": "13 - 18",
        "25": "19 - 25",
        "36": "26 - 36",
        "50": "37 - 50",
        "64": "51 - 64",
    }

    if (age) {
        for (const [bp, v] of Object.entries(breakpoints)) {
            if (age <= parseInt(bp)) {
                return v
            }
        }
        return "65+"
    }
    return "UNKNOWN"
}

class Analytics {
    private initialized = false

    public setUser(user: IdentifyData) {
        this.initialized = true
        identify(user.id, user)
    }

    public track<T extends keyof Events>(event: T, data: Events[T]) {
        if (!this.initialized) return
        track(event, data, undefined, undefined)
    }

    public page(data: {
        id: Page
        title: string
        meta?: {
            setting?: "webSettings"
        }
    }) {
        if (!this.initialized) return
        rpage(data)
    }
}

export const analytics = new Analytics()
