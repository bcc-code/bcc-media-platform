import config from "@/config"
import { createClient } from "@urql/vue"

export default createClient({
    url: config.api.url,
})
