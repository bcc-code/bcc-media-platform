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
                props: true,
            },
            {
                name: "front-page",
                path: "",
                component: () => import("@/pages/Page.vue"),
                props: {
                    pageId: "frontpage",
                },
            },
            {
                name: "episode-page",
                path: "episode/:episodeId",
                component: () => import("@/pages/Episode.vue"),
            },
            {
                name: "season-page",
                path: "season/:seasonId",
                component: () => import("@/pages/Season.vue"),
            },
            {
                name: "show-page",
                path: "show/:showId",
                component: () => import("@/pages/Show.vue"),
            },
            {
                name: "calendar",
                path: "/calendar",
                component: () => import("@/pages/calendar/Calendar.vue"),
            },
            {
                name: "search",
                path: "/search",
                component: () => import("@/pages/search/Search.vue")
            }
        ],
    },
] as RouteRecordRaw[]
