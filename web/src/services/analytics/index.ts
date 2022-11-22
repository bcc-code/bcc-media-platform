import { useAuth0 } from "@auth0/auth0-vue"
import { ready, load, track, identify } from "rudder-sdk-js"
import { ref } from "vue"
import { Events } from "./events"

const isLoading = ref(true)

ready(() => {
    isLoading.value = false
})

load(
    import.meta.env.VITE_RUDDERSTACK_WRITE_KEY,
    import.meta.env.VITE_RUDDERSTACK_DATA_PLANE_URL
)

export const event = <T extends keyof Events>(event: T, data: Events[T]) => {
    track(event, data)
}

export const initialize = (userId: string) => {
    identify(userId)
}
