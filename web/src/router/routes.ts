import { RouteRecordRaw } from "vue-router"

export default [
    {
        name: "main",
        path: "/",
        component: () => import("@/layout/StackedLayout.vue"),
        children: [
            {
                name: "page",
                path: ":pageId",
                component: () => import("@/pages/Page.vue"),
            },
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
            {
                name: "season-page",
                path: "season/:seasonId",
                component: () => import("@/pages/Season.vue")
            },
            {
                name: "show-page",
                path: "show/:showId",
                component: () => import("@/pages/Show.vue"),
            }
        ],
    },
] as RouteRecordRaw[]
