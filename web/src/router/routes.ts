import { RouteRecordRaw } from "vue-router"

export default [
    {
        name: "main",
        path: "/",
        component: () => import("@/layout/StackedLayout.vue"),
        children: [
            {
                name: "webview",
                path: "/w/:code",
                component: () => import("@/pages/w.vue"),
                props: true,
            },
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
                name: "playlist-episode",
                path: "playlist/:playlistId/:episodeId",
                component: () => import("@/pages/episode/Episode.vue"),
                props: true,
            },
            {
                name: "search",
                path: "/search",
                component: () => import("@/pages/search/Search.vue"),
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
            {
                name: "shorts",
                path: "/shorts/:shortId",
                alias: "/short/:shortId",
                props: true,
                component: () => import("@/pages/shorts/Shorts.vue"),
            },
        ],
    },
    {
        name: "live",
        path: "/live",
        beforeEnter: () => {
            window.location.href = "https://live.bcc-connect.org"
        },
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
            {
                name: "comic",
                path: "comic/:comicId",
                component: () => import("@/components/comics/Comic.vue"),
                props: true,
            },
            {
                name: "quote-of-the-day",
                path: "quote-of-the-day",
                component: () =>
                    import("@/components/quotes/QuoteOfTheDay.vue"),
                props: true,
            },
        ],
    },
    {
        name: "delete-account",
        path: "/delete-account",
        component: () => import("@/pages/DeleteAccount.vue"),
        props: {
            title: "Delete my account",
        },
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
    {
        name: "embed-episode",
        path: "/embed/:episodeId",
        props: true,
        component: () => import("@/pages/EpisodeEmbed.vue"),
    },
    {
        name: "embed-episode-legacy",
        path: "/embed/legacy/episode/:legacyId",
        props: true,
        component: () => import("@/pages/EpisodeEmbed.vue"),
    },
    {
        name: "embed-episode-legacy",
        path: "/embed/legacy/program/:programId",
        props: true,
        component: () => import("@/pages/EpisodeEmbed.vue"),
    },
    {
        name: "web",
        path: "/web",
        component: () => import("@/pages/Web.vue"),
        children: [
            {
                name: "material-request",
                path: "material-request",
                component: () => import("@/pages/web/MaterialRequest.vue"),
            },
        ],
    },
] as RouteRecordRaw[]
