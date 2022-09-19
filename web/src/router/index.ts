import { createRouter, createWebHistory } from "vue-router"
import routes from "./routes"

const router = createRouter({
    history: createWebHistory(),
    routes: routes,
})

router.beforeEach(async (to) => {
    
})

export default router
