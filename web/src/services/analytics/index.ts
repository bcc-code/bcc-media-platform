import { ready, load, track, identify, page as rpage } from "rudder-sdk-js"
import { ref } from "vue"
import { AgeGroup, Events, IdentifyData, Page } from "./events"
export * from "./events"

import { useGetAnalyticsIdQuery } from "@/graph/generated"
import { useAuth } from "../auth"

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
        const data = Object.assign({}, user) as any
        delete data["id"]
        identify(user.id, data)
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

    public async initialize(idFactory: () => Promise<string | null>) {
        const { getClaims } = useAuth()
    
        let analyticsId = await idFactory()
        if (!analyticsId)
            analyticsId = "anonymous"
        
        const claims = getClaims();
    
        let ageGroup: AgeGroup = "UNKNOWN"
    
        const now = new Date();
        const birthDate = claims.birthDate
        if (birthDate) {
            const date = new Date(birthDate)
            
            const diff = now.getTime() - date.getTime();
    
            const diffDate = new Date(diff)
    
            ageGroup = getAgeGroup(diffDate.getFullYear() - 1970)
        }
    
        this.setUser({
            ageGroup,
            churchId: claims.churchId?.toString() ?? "0",
            country: claims.country ?? "unknown",
            gender: claims.gender ?? "unknown",
            id: analyticsId
        })
    }
}

export const analytics = new Analytics()
