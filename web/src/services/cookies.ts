import { ref, watch } from "vue"
import { webViewMain } from "@/services/webviews/mainHandler"

const preferences = ref<boolean>()
const statistics = ref<boolean>()
const accepted = ref<boolean>()

try {
    preferences.value = localStorage.getItem("cookies.preferences") !== "false"

    statistics.value = localStorage.getItem("cookies.statistics") !== "false"

    accepted.value = localStorage.getItem("cookies.accepted") === "true"

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
} catch { }


export const useCookies = () => {
    if (webViewMain) {
        return {
            preferences: ref(true),
            statistics: ref(true),
            accepted: ref(true),
        }
    }
    return {
        preferences,
        statistics,
        accepted,
    }
}
