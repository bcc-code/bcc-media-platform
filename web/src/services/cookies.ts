import { ref, watch } from "vue"

const preferences = ref(localStorage.getItem("cookies.preferences") !== "false")
const statistics = ref(localStorage.getItem("cookies.statistics") !== "false")
const accepted = ref(localStorage.getItem("cookies.accepted") === "true")

watch(
    () => [preferences.value, statistics.value, accepted.value],
    () => {
        localStorage.setItem(
            "cookies.preferences",
            preferences.value ? "true" : "false"
        )
        localStorage.setItem(
            "cookies.statistics",
            statistics.value ? "true" : "false"
        )
        localStorage.setItem(
            "cookies.accepted",
            accepted.value ? "true" : "false"
        )
    }
)

export const useCookies = () => {
    return {
        preferences,
        statistics,
        accepted,
    }
}
