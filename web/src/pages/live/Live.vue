<template>
    <section class="font-medium mx-auto">
        <div class="aspect-video w-full">
            <Player></Player>
        </div>
        <div>
            <div class="flex stroke-gray text-gray p-4 max-w-lg mx-auto">
                <ChevronLeft
                    class="h-12 w-12"
                    @click="incrementWeek(-1)"
                ></ChevronLeft>
                <p class="w-full text-center text-lg my-auto uppercase">
                    {{
                        week.some(
                            (i) =>
                                i.toLocaleDateString() ===
                                now.toLocaleDateString()
                        )
                            ? t("calendar.thisWeek")
                            : ""
                    }}
                </p>
                <ChevronRight
                    class="h-12 w-12"
                    @click="incrementWeek(1)"
                ></ChevronRight>
            </div>
            <div class="grid grid-cols-7">
                <div
                    v-for="day in week"
                    class="text-center cursor-pointer hover:bg-gray hover:bg-opacity-10 rounded-full"
                    @click="selected = day"
                >
                    <span class="align-middle text-gray">
                        {{ day.toDateString().substring(0, 1) }}
                    </span>
                    <div
                        class="h-8 aspect-square mx-auto rounded-full font-bold"
                        :class="[
                            day.toLocaleDateString() ===
                            now.toLocaleDateString()
                                ? 'text-red'
                                : '',
                            day.toLocaleDateString() ===
                            selected.toLocaleDateString()
                                ? 'outline outline-white outl ine-2 bg-gray bg-opacity-20'
                                : 'outline-none',
                        ]"
                    >
                        <span class="align-middle leading-8">{{
                            day.getDate()
                        }}</span>
                    </div>
                    <div class="flex p-2">
                        <div
                            class="h-2 w-2 rounded-full mx-auto"
                            :class="[
                                data?.calendar?.period.activeDays.some(
                                    (d) =>
                                        new Date(d).getDate() === day.getDate()
                                )
                                    ? 'bg-gray'
                                    : 'bg-none',
                            ]"
                        ></div>
                    </div>
                </div>
            </div>
            <hr class="opacity-10 m-4" />
            <DayQuery :day="selected"></DayQuery>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { ChevronLeft, ChevronRight } from "@/components/icons"
import Player from "@/components/live/Player.vue"
import { getWeek } from "@/utils/date"
import { computed, onMounted, ref } from "vue"
import { useGetLiveCalendarRangeQuery } from "@/graph/generated"
import DayQuery from "@/components/calendar/DayQuery.vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"

const { t } = useI18n()

const now = new Date()

const week = ref(getWeek(now))

const incrementWeek = (increment: number) => {
    const s = start.value
    s.setDate(s.getDate() + 7 * increment)
    week.value = getWeek(s)
}

const selected = ref(now)

const start = computed(() => {
    return week.value[0]
})

const end = computed(() => {
    return week.value[6]
})

const { data } = useGetLiveCalendarRangeQuery({
    variables: {
        start,
        end,
    },
})

const { setTitle } = useTitle()

onMounted(() => {
    setTitle(t("page.live"))
    analytics.page({
        id: "livestream",
        title: t("page.live"),
    })
})
</script>
