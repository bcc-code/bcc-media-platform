<template>
    <div
        class="flex items-center justify-start w-full cursor-pointer py-1 border-b border-separator-on-light px-4"
        @click="openLink"
    >
        <div class="flex items-center justify-start h-full pr-3">
            <svg
                width="24"
                height="25"
                viewBox="0 0 24 25"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M5 6.5H9C10.1046 6.5 11 7.39543 11 8.5V19.0585L10.5562 18.9105C9.74042 18.6386 8.88619 18.5 8.02633 18.5H5C4.44772 18.5 4 18.0523 4 17.5V7.5C4 6.94772 4.44772 6.5 5 6.5ZM12.3162 21.3946C12.111 21.463 11.889 21.463 11.6838 21.3946L9.9237 20.8079C9.3119 20.604 8.67123 20.5 8.02633 20.5H5C3.34315 20.5 2 19.1569 2 17.5V7.5C2 5.84315 3.34315 4.5 5 4.5H9C10.1947 4.5 11.2671 5.02376 12 5.85418C12.7329 5.02376 13.8053 4.5 15 4.5H19C20.6569 4.5 22 5.84315 22 7.5V17.5C22 19.1569 20.6569 20.5 19 20.5H15.9737C15.3288 20.5 14.6881 20.604 14.0763 20.8079L12.3162 21.3946ZM15 6.5H19C19.5523 6.5 20 6.94772 20 7.5V17.5C20 18.0523 19.5523 18.5 19 18.5H15.9737C15.1138 18.5 14.2596 18.6386 13.4438 18.9105L13 19.0585V8.5C13 7.39543 13.8954 6.5 15 6.5Z"
                    fill="white"
                />
            </svg>
        </div>
        <div
            class="inline-flex flex-col space-y-0.5 items-start justify-start flex-1 pr-4 py-2"
        >
            <p class="w-full text-style-title-3 text-label-1">
                {{ link.title }}
            </p>
            <p class="w-full text-style-caption-1 text-label-3">
                {{ link.description }}
            </p>
        </div>
        <div class="flex items-center justify-start h-full pl-3">
            <svg
                width="24"
                height="25"
                viewBox="0 0 24 25"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    d="M19 9.5C19 10.0523 19.4477 10.5 20 10.5C20.5523 10.5 21 10.0523 21 9.5V5.5C21 4.39543 20.1046 3.5 19 3.5H15C14.4477 3.5 14 3.94772 14 4.5C14 5.05228 14.4477 5.5 15 5.5L17.5858 5.5L11.2929 11.7929C10.9024 12.1834 10.9024 12.8166 11.2929 13.2071C11.6834 13.5976 12.3166 13.5976 12.7071 13.2071L19 6.91421V9.5Z"
                    fill="#707C8E"
                />
                <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M3 6.5C3 4.84315 4.34315 3.5 6 3.5H11C11.5523 3.5 12 3.94772 12 4.5C12 5.05228 11.5523 5.5 11 5.5H6C5.44772 5.5 5 5.94772 5 6.5V18.5C5 19.0523 5.44772 19.5 6 19.5H18C18.5523 19.5 19 19.0523 19 18.5V13.5C19 12.9477 19.4477 12.5 20 12.5C20.5523 12.5 21 12.9477 21 13.5V18.5C21 20.1569 19.6569 21.5 18 21.5H6C4.34315 21.5 3 20.1569 3 18.5V6.5Z"
                    fill="#707C8E"
                />
            </svg>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { LessonLinkFragment } from "@/graph/generated"
import { webViewMain, openInBrowser } from "@/services/webviews/mainHandler"

const props = defineProps<{ link: LessonLinkFragment }>()

const openLink = () => {
    if (webViewMain) {
        openInBrowser(props.link.url)
    } else {
        window.open(props.link.url, "_blank")?.focus()
    }
}
</script>
@/services/webviews/mainHandler
