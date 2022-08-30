import { RouteRecordRaw } from "vue-router"

export default [
    {
        name: "main",
        path: "/",
        component: () => import("@/layout/StackedLayout.vue"),
        children: [
            {
                name: "main-page",
                path: "",
                component: () => import("@/pages/Main.vue"),
            },
        ],
    },
] as RouteRecordRaw[]
