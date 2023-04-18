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
                name: "video-page",
                path: "videos/:videoId",
                component: () => import("@/pages/episode/Video.vue"),
                props: true,
            },
            {
                name: "episode-lesson-page",
                path: "ep/:episodeId/lesson/:lessonId/:subRoute?",
                component: () => import("@/pages/episode/EpisodeLesson.vue"),
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
            {
                name: "series-redirect",
                path: "/series/:episodeId",
                component: () => import("@/pages/EpisodeRedirect.vue"),
                props: true,
            },
            {
                name: "program-redirect",
                path: "/program/:programId",
                component: () => import("@/pages/EpisodeRedirect.vue"),
                props: true,
            },
        ],
    },
    {
        name: "embed",
        path: "/embed",
        component: () => import("@/pages/embed/Embed.vue"),
        children: [
            {
                name: "lesson",
                path: "episode/:episodeId/lesson/:lessonId/:subRoute?",
                component: () => import("@/components/study/Lesson.vue"),
                props: true,
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
    {
        name: "login",
        path: "/login",
        component: () => import("@/pages/Login.vue"),
    },
] as RouteRecordRaw[]
