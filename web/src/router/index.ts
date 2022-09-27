import { createRouter, createWebHistory } from "vue-router"
import routes from "./routes"

const router = createRouter({
    history: createWebHistory(),
    routes: routes,
})

router.beforeEach(async (to) => {})

router.afterEach((to, from) => {
    const toDepth = to.path.split('/').length
    const fromDepth = from.path.split('/').length
    to.meta.transitionName = toDepth < fromDepth ? 'slide-right' : 'slide-left'
})

export default router
