<template>
    <div
        class="p-4 pb-0 w-full h-full flex flex-col items-center justify-center text-center pb-12 embed:min-h-screen embed:pb-64"
    >
        <img class="max-w-[33%]" src="/icons/study/competition_icon.png" />
        <p class="w-full text-white text-style-headline-1 mt-6">
            {{ t("competition.title") }}
        </p>
        <p
            class="text-style-body-1 text-label-3 mt-1"
            v-html="t('competition.description')"
        ></p>
        <div class="w-full mt-8">
            <p class="text-style-title-2">
                {{ t("competition.howDoesItWork") }}
            </p>
            <div class="mt-4 w-full flex items-center justify-start">
                <svg
                    width="32"
                    height="33"
                    viewBox="0 0 32 33"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        d="M16.7119 3.94141C19.9707 3.9507 23.1015 5.21121 25.4576 7.46259V5.21259C25.4576 4.87545 25.5916 4.55212 25.8299 4.31373C26.0683 4.07533 26.3917 3.94141 26.7288 3.94141C27.066 3.94141 27.3893 4.07533 27.6277 4.31373C27.8661 4.55212 28 4.87545 28 5.21259V10.9329C28 11.2701 27.8661 11.5934 27.6277 11.8318C27.3893 12.0702 27.066 12.2041 26.7288 12.2041H21.0085C20.6713 12.2041 20.348 12.0702 20.1096 11.8318C19.8712 11.5934 19.7373 11.2701 19.7373 10.9329C19.7373 10.5958 19.8712 10.2725 20.1096 10.0341C20.348 9.79567 20.6713 9.66174 21.0085 9.66174H24.0593C22.9004 8.4376 21.4553 7.52076 19.8541 6.9937C18.2529 6.46664 16.5457 6.34588 14.8863 6.6423C13.2268 6.93872 11.667 7.64301 10.3473 8.69182C9.02759 9.74063 7.98928 11.1011 7.32579 12.6507C6.6623 14.2004 6.39445 15.8907 6.54633 17.5696C6.6982 19.2484 7.26505 20.8632 8.19587 22.2687C9.12668 23.6741 10.3923 24.8261 11.8788 25.6211C13.3653 26.416 15.0261 26.829 16.7119 26.8228C17.049 26.8228 17.3723 26.9567 17.6107 27.1951C17.8491 27.4335 17.9831 27.7568 17.9831 28.0939C17.9831 28.4311 17.8491 28.7544 17.6107 28.9928C17.3723 29.2312 17.049 29.3651 16.7119 29.3651C13.3405 29.3651 10.1072 28.0258 7.72322 25.6419C5.33928 23.258 4 20.0247 4 16.6533C4 13.2819 5.33928 10.0486 7.72322 7.66462C10.1072 5.28069 13.3405 3.94141 16.7119 3.94141Z"
                        fill="#6EB0E6"
                    />
                    <path
                        d="M15.8152 12.7157C15.8556 12.693 15.9162 12.6816 15.9971 12.6816H17.4648C17.5052 12.6816 17.5376 12.6968 17.5618 12.727C17.5942 12.7497 17.6103 12.78 17.6103 12.8178V20.4904C17.6103 20.5282 17.5942 20.5622 17.5618 20.5925C17.5376 20.6152 17.5052 20.6266 17.4648 20.6266H16.0456C16.0052 20.6266 15.9688 20.6152 15.9364 20.5925C15.9122 20.5622 15.9001 20.5282 15.9001 20.4904V14.2706C15.9001 14.2555 15.892 14.2404 15.8758 14.2252C15.8596 14.2101 15.8435 14.2063 15.8273 14.2139L14.6264 14.5203L14.5779 14.5317C14.5052 14.5317 14.4688 14.4901 14.4688 14.4068L14.4324 13.4307C14.4324 13.3551 14.4688 13.3021 14.5415 13.2718L15.8152 12.7157Z"
                        fill="#6EB0E6"
                    />
                </svg>
                <div
                    class="pl-3 flex-1 text-left text-style-body-2 text-label-3"
                >
                    {{ t("competition.onlyOnce") }}
                </div>
            </div>
            <div class="mt-4 w-full flex items-center justify-start">
                <svg
                    width="32"
                    height="33"
                    viewBox="0 0 32 33"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        fill-rule="evenodd"
                        clip-rule="evenodd"
                        d="M22.3198 19.6055C24.5601 18.4095 24.5601 15.4694 22.3198 14.2734L13.1364 9.37119C10.8643 8.15829 8 9.64499 8 12.0372V21.8417C8 24.2339 10.8643 25.7206 13.1364 24.5077L22.3198 19.6055Z"
                        fill="white"
                    />
                </svg>

                <div
                    class="pl-3 flex-1 text-left text-style-body-2 text-label-3"
                >
                    {{ t("competition.watchNextBroadcast") }}
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import {
    TaskFragment,
    useCompleteTaskMutation,
    useSendTaskMessageMutation,
} from "@/graph/generated"
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"

const { t } = useI18n()

const props = defineProps<{
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "nextTask"): void
    (event: "update:isDone", val: boolean): void
}>()

const isDone = computed({
    get() {
        return props.isDone
    },
    set(value) {
        emit(`update:isDone`, value)
    },
})

isDone.value = true
</script>
