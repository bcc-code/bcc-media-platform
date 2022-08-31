import { RouteRecordRaw } from "vue-router"

export default [
    {
        name: "main",
        path: "/",
        component: () => import("@/layout/StackedLayout.vue"),
        children: [
            {
                name: "front-page",
                path: "",
                component: () => import("@/pages/Front.vue"),
            },
            {
                name: "episode-page",
                path: "episode/:episodeId",
                component: () => import("@/pages/Episode.vue"),
            },
        ],
    },
] as RouteRecordRaw[]
