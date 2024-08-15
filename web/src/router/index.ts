import { useTitle } from '@/utils/title'
import { createRouter, createWebHistory } from 'vue-router'
import routes from './routes'

const router = createRouter({
    history: createWebHistory(),
    routes: routes,
})

const { setTitle } = useTitle()

router.beforeEach((to, from) => {
    setTitle('')
})

export default router
