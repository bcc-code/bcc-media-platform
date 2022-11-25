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
                props: true,
            },
            {
                name: "episode-collection-page",
                path: "episode/:collection/:episodeId",
                component: () => import("@/pages/episode/Episode.vue"),
                props: true,
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
    {
        name: "not-found",
        path: "/:pathMatch(.*)*",
        component: () => import("@/components/NotFound.vue"),
        props: {
            title: "Page not found",
        },
    },
    {
        name: "auth-redirect",
        path: "/r/:code",
        component: () => import("@/pages/redirect/Redirect.vue"),
        props: true,
    },
] as RouteRecordRaw[]
