import settings from "@/services/settings"
import { computed, ref } from "vue"

const current = computed({
    get() {
        return settings.locale
    },
    set(v) {
        settings.locale = v
    }
})

const supported = ["en", "no"]

export default {
    supported,
    current,
}
