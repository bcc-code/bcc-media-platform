<script lang="ts" setup>
import { LessonProgressOverviewFragment } from '@/graph/generated'
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import Check from '../icons/Check.vue'

const props = defineProps<{
    episodeId: string
    lesson: LessonProgressOverviewFragment
}>()

const { t } = useI18n()

const total = computed(() => props.lesson.progress.alternativesTasksTotal)
const completed = computed(
    () => props.lesson.progress.alternativesTasksCompleted
)
const correct = computed(() => props.lesson.progress.alternativesTasksCorrect)

const dynamicClasses = computed(() => {
    const defaultState = !total.value || completed.value === 0
    const correctState =
        total.value && completed.value === total.value && correct.value > 0
    const incorrectState =
        total.value && completed.value === total.value && correct.value === 0

    return {
        'bg-separator-on-light border-separator-on-light': defaultState,
        'bg-primary border-primary': correctState,
        'bg-red border-red': incorrectState,
    }
})

const title = computed(() => {
    if (!completed.value) return t('lesson.studyAnswerTheQuiz')
    switch (correct.value) {
        case 0:
            return t('lesson.studyNoAnswersCorrect')
        case total.value:
            return t('lesson.studyAllAnswersCorrect')
        default:
            return t('lesson.studySomeAnswersCorrect', {
                correct: correct.value,
                total: total.value,
            })
    }
})

const subtitle = computed(() => {
    if (!completed.value) return t('lesson.studyAnswerTheQuizDescription')
    switch (correct.value) {
        case 0:
            return t('lesson.studyNoAnswersCorrectDescription')
        case total.value:
            return t('lesson.studyAllAnswersCorrectDescription')
        default:
            return t('lesson.studySomeAnswersCorrectDescription')
    }
})
</script>

<template>
    <div class="w-full relative">
        <div
            :class="[
                'w-full rounded-xl border select-none cursor-pointer',
                dynamicClasses,
            ]"
        >
            <div v-if="total" class="p-3 flex items-center">
                <div class="flex-1 flex flex-col gap-0.5">
                    <p class="text-style-title-3 text-on-tint">
                        {{ title }}
                    </p>
                    <p class="text-style-caption-1 opacity-80">
                        {{ subtitle }}
                    </p>
                </div>
                <div class="pl-3">
                    <div
                        class="bg-separator-on-light rounded-full h-9 w-9 flex items-center justify-center border border-separator-on-light"
                    >
                        <svg
                            v-if="completed !== total"
                            width="8"
                            height="12"
                            viewBox="0 0 8 12"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M0.958984 0.897949L6.06103 5.99999L0.958984 11.102"
                                stroke="white"
                                stroke-width="1.53061"
                            />
                        </svg>
                        <Check v-else />
                    </div>
                </div>
            </div>
            <div v-else class="p-3 flex items-center">
                <div class="pr-3">
                    <svg
                        width="45"
                        height="44"
                        viewBox="0 0 45 44"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            d="M42.8571 22C42.8571 33.2711 33.7201 42.4081 22.449 42.4081C11.1779 42.4081 2.04082 33.2711 2.04082 22C2.04082 11.071 10.6315 2.14853 21.4286 1.61686C21.7666 1.60022 22.1068 1.5918 22.449 1.5918C22.7912 1.5918 23.1314 1.60022 23.4694 1.61686C34.2664 2.14853 42.8571 11.071 42.8571 22Z"
                            stroke="url(#paint0_linear_7747_133848)"
                            stroke-width="3.06122"
                        />
                        <mask id="path-3-inside-1_7747_133848" fill="white">
                            <path
                                fill-rule="evenodd"
                                clip-rule="evenodd"
                                d="M18.3674 15.3673C18.3674 15.5616 18.3829 15.7523 18.4127 15.9382C18.2339 15.8985 18.048 15.8775 17.8571 15.8775C16.4482 15.8775 15.3061 17.0197 15.3061 18.4286C15.3061 18.8945 15.431 19.3313 15.6492 19.7072C14.8043 20.2872 14.2855 21.1901 14.2855 22.5102C14.2855 25.2331 16.4931 26.5918 19.2161 26.5918H19.3878H20.7166V30.4716H22.7574V26.5918H23.9796H24.4898C27.3076 26.5918 29.5918 24.8178 29.5918 22C29.5918 20.588 29.0182 19.5662 28.0914 18.8981C28.3935 18.4789 28.5714 17.9643 28.5714 17.4081C28.5714 15.9993 27.4293 14.8571 26.0204 14.8571C25.8356 14.8571 25.6554 14.8768 25.4817 14.9141C25.259 13.1557 23.7577 11.7959 21.9388 11.7959C19.9663 11.7959 18.3674 13.3949 18.3674 15.3673Z"
                            />
                        </mask>
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M18.3674 15.3673C18.3674 15.5616 18.3829 15.7523 18.4127 15.9382C18.2339 15.8985 18.048 15.8775 17.8571 15.8775C16.4482 15.8775 15.3061 17.0197 15.3061 18.4286C15.3061 18.8945 15.431 19.3313 15.6492 19.7072C14.8043 20.2872 14.2855 21.1901 14.2855 22.5102C14.2855 25.2331 16.4931 26.5918 19.2161 26.5918H19.3878H20.7166V30.4716H22.7574V26.5918H23.9796H24.4898C27.3076 26.5918 29.5918 24.8178 29.5918 22C29.5918 20.588 29.0182 19.5662 28.0914 18.8981C28.3935 18.4789 28.5714 17.9643 28.5714 17.4081C28.5714 15.9993 27.4293 14.8571 26.0204 14.8571C25.8356 14.8571 25.6554 14.8768 25.4817 14.9141C25.259 13.1557 23.7577 11.7959 21.9388 11.7959C19.9663 11.7959 18.3674 13.3949 18.3674 15.3673Z"
                            fill="url(#paint1_linear_7747_133848)"
                        />
                        <path
                            d="M18.4127 15.9382L17.9702 17.9305L20.9045 18.5822L20.4277 15.6145L18.4127 15.9382ZM15.6492 19.7072L16.8043 21.3897L18.3639 20.319L17.4143 18.6828L15.6492 19.7072ZM20.7166 26.5918H22.7574V24.551H20.7166V26.5918ZM20.7166 30.4716H18.6758V32.5125H20.7166V30.4716ZM22.7574 30.4716V32.5125H24.7982V30.4716H22.7574ZM22.7574 26.5918V24.551H20.7166V26.5918H22.7574ZM28.0914 18.8981L26.4357 17.7048L25.2426 19.3604L26.898 20.5536L28.0914 18.8981ZM25.4817 14.9141L23.4571 15.1705L23.7365 17.3767L25.9106 16.9093L25.4817 14.9141ZM20.4277 15.6145C20.415 15.5353 20.4082 15.4528 20.4082 15.3673H16.3265C16.3265 15.6705 16.3508 15.9694 16.3977 16.2619L20.4277 15.6145ZM17.8571 17.9183C17.8981 17.9183 17.9357 17.9228 17.9702 17.9305L18.8552 13.9459C18.532 13.8742 18.1978 13.8367 17.8571 13.8367V17.9183ZM17.3469 18.4286C17.3469 18.1468 17.5754 17.9183 17.8571 17.9183V13.8367C15.3211 13.8367 13.2653 15.8926 13.2653 18.4286H17.3469ZM17.4143 18.6828C17.3719 18.6097 17.3469 18.5251 17.3469 18.4286H13.2653C13.2653 19.2639 13.4902 20.0528 13.8841 20.7316L17.4143 18.6828ZM16.3263 22.5102C16.3263 21.8172 16.5503 21.564 16.8043 21.3897L14.4942 18.0247C13.0584 19.0103 12.2447 20.5631 12.2447 22.5102H16.3263ZM19.2161 24.551C18.1633 24.551 17.4073 24.2848 16.9667 23.949C16.593 23.6641 16.3263 23.2501 16.3263 22.5102H12.2447C12.2447 24.4932 13.0818 26.12 14.4926 27.1953C15.8366 28.2195 17.5459 28.6326 19.2161 28.6326V24.551ZM19.3878 24.551H19.2161V28.6326H19.3878V24.551ZM20.7166 24.551H19.3878V28.6326H20.7166V24.551ZM22.7574 30.4716V26.5918H18.6758V30.4716H22.7574ZM22.7574 28.4308H20.7166V32.5125H22.7574V28.4308ZM20.7166 26.5918V30.4716H24.7982V26.5918H20.7166ZM23.9796 24.551H22.7574V28.6326H23.9796V24.551ZM24.4898 24.551H23.9796V28.6326H24.4898V24.551ZM27.551 22C27.551 23.4164 26.4758 24.551 24.4898 24.551V28.6326C28.1394 28.6326 31.6327 26.2191 31.6327 22H27.551ZM26.898 20.5536C27.2753 20.8255 27.551 21.2221 27.551 22H31.6327C31.6327 19.9539 30.7612 18.3068 29.2847 17.2425L26.898 20.5536ZM26.5306 17.4081C26.5306 17.5219 26.4957 17.6215 26.4357 17.7048L29.747 20.0913C30.2912 19.3362 30.6122 18.4067 30.6122 17.4081H26.5306ZM26.0204 16.8979C26.3022 16.8979 26.5306 17.1264 26.5306 17.4081H30.6122C30.6122 14.8721 28.5564 12.8163 26.0204 12.8163V16.8979ZM25.9106 16.9093C25.9442 16.9021 25.9807 16.8979 26.0204 16.8979V12.8163C25.6905 12.8163 25.3665 12.8514 25.0528 12.9189L25.9106 16.9093ZM21.9388 13.8367C22.7168 13.8367 23.3619 14.419 23.4571 15.1705L27.5064 14.6577C27.1562 11.8923 24.7986 9.75508 21.9388 9.75508V13.8367ZM20.4082 15.3673C20.4082 14.522 21.0934 13.8367 21.9388 13.8367V9.75508C18.8392 9.75508 16.3265 12.2678 16.3265 15.3673H20.4082Z"
                            fill="url(#paint2_linear_7747_133848)"
                            mask="url(#path-3-inside-1_7747_133848)"
                        />
                        <defs>
                            <linearGradient
                                id="paint0_linear_7747_133848"
                                x1="-18.3673"
                                y1="22"
                                x2="22.449"
                                y2="62.8163"
                                gradientUnits="userSpaceOnUse"
                            >
                                <stop stop-color="#70C5BD" />
                                <stop offset="1" stop-color="#FDCF48" />
                            </linearGradient>
                            <linearGradient
                                id="paint1_linear_7747_133848"
                                x1="6.63234"
                                y1="21.1338"
                                x2="24.9445"
                                y2="36.1421"
                                gradientUnits="userSpaceOnUse"
                            >
                                <stop stop-color="#70C5BD" />
                                <stop offset="1" stop-color="#FDCF48" />
                            </linearGradient>
                            <linearGradient
                                id="paint2_linear_7747_133848"
                                x1="6.63234"
                                y1="21.1338"
                                x2="24.9445"
                                y2="36.1421"
                                gradientUnits="userSpaceOnUse"
                            >
                                <stop stop-color="#70C5BD" />
                                <stop offset="1" stop-color="#FDCF48" />
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <div class="flex-1 flex flex-col">
                    <span class="text-style-title-3 text-on-tint">
                        {{ t('lesson.lessonActivityTitle') }}
                    </span>
                    <span
                        v-if="false"
                        class="text-style-caption-1 text-label-2"
                    >
                        {{
                            lesson.progress.completed +
                            '/' +
                            lesson.progress.total
                        }}
                    </span>
                </div>
                <div class="pl-3">
                    <div
                        class="bg-separator-on-light rounded-full h-9 w-9 flex items-center justify-center border border-separator-on-light"
                    >
                        <svg
                            width="8"
                            height="12"
                            viewBox="0 0 8 12"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M0.958984 0.897949L6.06103 5.99999L0.958984 11.102"
                                stroke="white"
                                stroke-width="1.53061"
                            />
                        </svg>
                    </div>
                </div>
            </div>
            <div
                class="shine-overlay absolute top-0 right-0 w-full h-full rounded-xl"
            />
        </div>
        <svg width="0" height="0">
            <defs>
                <clipPath id="myCurve" clipPathUnits="objectBoundingBox">
                    <path
                        d="M 0,1
              L .55, 1
              C .6 .5, .7 .3, .75 0
              L 1,0
              L 1,1
              Z"
                    />
                </clipPath>
            </defs>
        </svg>
    </div>
</template>

<style scoped>
.shine-overlay {
    clip-path: url(#myCurve);
    /*
    background-image: url("data:image/svg+xml,%3Csvg width='167' height='65' viewBox='0 0 167 65' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M48.5713 24.5C17.3713 50.5 3.57129 81.3333 0.571289 93.5H209.071V-25H88.5713C88.238 -19.3333 79.7713 -1.5 48.5713 24.5Z' fill='url(%23paint0_linear_7738_134762)' fill-opacity='0.1'/%3E%3Cdefs%3E%3ClinearGradient id='paint0_linear_7738_134762' x1='104.821' y1='-25' x2='104.821' y2='93.5' gradientUnits='userSpaceOnUse'%3E%3Cstop stop-color='%23CCDDFF'/%3E%3Cstop stop-color='%23EDF3FE'/%3E%3Cstop offset='1' stop-color='%23CCDDFF' stop-opacity='0'/%3E%3C/linearGradient%3E%3C/defs%3E%3C/svg%3E");
 */

    background: linear-gradient(
        180deg,
        rgba(204, 221, 255, 0.1) 0%,
        rgba(237, 243, 254, 0.1) 0%,
        rgba(204, 221, 255, 0) 100%
    );
}
</style>
