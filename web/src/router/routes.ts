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
                component: () => import("@/pages/page/Page.vue"),
                props: true,
            },
            {
                name: "front-page",
                path: "",
                component: () => import("@/pages/page/Page.vue"),
                props: {
                    pageId: "frontpage",
                },
            },
            {
                name: "episode-page",
                path: "episode/:episodeId",
                component: () => import("@/pages/episode/Episode.vue"),
            },
            {
                name: "calendar",
                path: "/calendar",
                component: () => import("@/pages/calendar/Calendar.vue"),
            },
            {
                name: "search",
                path: "/search",
                component: () => import("@/pages/search/Search.vue"),
            },
            {
                name: "live",
                path: "/live",
                component: () => import("@/pages/live/Live.vue"),
            },
        ],
    },
] as RouteRecordRaw[]
