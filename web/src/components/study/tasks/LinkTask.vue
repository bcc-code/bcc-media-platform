<template>
    <div class="p-4 pb-0 w-full h-full">
        <div
            v-if="showNoLocalGroupFound"
            class="h-full flex flex-col justify-center items-center pb-8 embed:pb-52"
        >
            <h2 class="w-full text-white text-style-title-1 text-center">
                {{ t("lesson.noLocalGroupFound") }}
            </h2>
            <p
                v-if="task.description"
                class="text-style-body-1 text-label-3 text-center mt-2"
            >
                {{ t("contactLocalBukIfWrong") }}
            </p>
        </div>
        <div
            v-else
            class="h-full flex flex-col justify-center items-center pb-8 embed:pb-52"
        >
            <h2 class="w-full text-white text-style-title-1 text-center">
                {{ task.title }}
            </h2>
            <p
                v-if="task.description"
                class="text-style-body-1 text-label-3 text-center mt-2"
            >
                {{ task.description }}
            </p>
            <div class="flex mt-6 flex-grow max-h-48"></div>
            <div class="mx-12 cursor-pointer" @click="openLink">
                <a href="#" class="flex justify-center" v-if="task.link.image">
                    <img :src="task.link.image ?? ''" />
                </a>
                <h2 class="mt-2 text-style-title-2 text-on-tint text-center">
                    {{ task.link.title }}
                </h2>
                <h2 class="mt-1 text-style-caption-1 text-label-3 text-center">
                    {{ task.link.description }}
                </h2>
                <div class="mt-6 flex align-center justify-center">
                    <VButton @click="openLink" size="thin" color="secondary">
                        <svg
                            class="inline -mt-1"
                            width="25"
                            height="24"
                            viewBox="0 0 25 24"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M19.5 9C19.5 9.55229 19.9477 10 20.5 10C21.0523 10 21.5 9.55229 21.5 9V5C21.5 3.89543 20.6046 3 19.5 3H15.5C14.9477 3 14.5 3.44772 14.5 4C14.5 4.55228 14.9477 5 15.5 5L18.0858 5L11.7929 11.2929C11.4024 11.6834 11.4024 12.3166 11.7929 12.7071C12.1834 13.0976 12.8166 13.0976 13.2071 12.7071L19.5 6.41421V9Z"
                                fill="white"
                            />
                            <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M3.5 6C3.5 4.34315 4.84315 3 6.5 3H11.5C12.0523 3 12.5 3.44772 12.5 4C12.5 4.55228 12.0523 5 11.5 5H6.5C5.94772 5 5.5 5.44772 5.5 6V18C5.5 18.5523 5.94772 19 6.5 19H18.5C19.0523 19 19.5 18.5523 19.5 18V13C19.5 12.4477 19.9477 12 20.5 12C21.0523 12 21.5 12.4477 21.5 13V18C21.5 19.6569 20.1569 21 18.5 21H6.5C4.84315 21 3.5 19.6569 3.5 18V6Z"
                                fill="white"
                            />
                        </svg>

                        {{ t("buttons.goTo") }}
                    </VButton>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { VButton } from "@/components"
import {
    TaskFragment,
    useCompleteTaskMutation,
    useGetRedirectUrlQuery,
} from "@/graph/generated"
import { computed, onMounted, ref } from "vue"
import { useI18n } from "vue-i18n"
import { openInBrowser } from "@/services/webviews/mainHandler"

const { t } = useI18n()
const { executeMutation: completeTask } = useCompleteTaskMutation()

const showNoLocalGroupFound = ref(false)

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
}>()

const task = computed(() => {
    return (props.task.__typename == "LinkTask" ? props.task : undefined)!
})

console.log("href: " + location.href)
const isSpecialGreetingLink =
    task.value.link.url.indexOf(
        "lesson/2b4d070b-ac92-4c78-ac0b-26abe9de4b89"
    ) !== -1

const isRedirectLink =
    task.value.link.url.indexOf("/r/") !== -1 || isSpecialGreetingLink
let redirectCode: string | null = null

;(() => {
    if (!isRedirectLink) {
        return
    }
    if (isSpecialGreetingLink) {
        redirectCode = "pc23-greeting"
        return
    }
    const url = new URL(task.value.link.url) // https://something.com/r/something/blabla
    const pathSegments = url.pathname.split("/") // ["", "r", "something", "blabla"]
    redirectCode = pathSegments[2] // "something"
})()

const redirectQuery = useGetRedirectUrlQuery({
    pause: !isRedirectLink,
    variables: {
        code: redirectCode ?? "",
    },
})
console.log(task.value.title)

const openLink = async () => {
    const t = completeTask({ taskId: task.value.id })
    if (isRedirectLink) {
        console.log("redirectCode: " + redirectCode)
        const redirect = await redirectQuery
        console.log("redirect: " + JSON.stringify(redirect))
        const url = redirect.data.value?.redirect.url
        if (url == null) throw Error("Redirect url was null")
        await t
        openInBrowser(url.replace("https://t.me/+", "https://t.me/joinchat/"))
        return
    }
    if (task.value.link.url === "no-local-group-found") {
        showNoLocalGroupFound.value = true
        return
    }
    await t
    openInBrowser(
        task.value.link.url.replace("https://t.me/+", "https://t.me/joinchat/")
    )
}
onMounted(async () => {
    emit(`update:isDone`, true)
})
</script>
@/services/webviews/mainHandler
