<template>
    <section>
        <div class="">
            <div class="max-w-lg mx-auto flex mb-4 stroke-white">
                <ChevronLeft
                    class="w-16 h-16 cursor-pointer rounded-full hover:bg-gray hover:bg-opacity-10"
                    @click="incrementMonth(-1)"
                ></ChevronLeft>
                <p
                    class="w-full text-center text-xl my-auto font-medium uppercase"
                >
                    {{
                        month.toLocaleString([current.code, "en"], {
                            month: "long",
                        })
                    }}
                    {{ month.getFullYear() }}
                </p>
                <ChevronRight
                    class="w-16 h-16 cursor-pointer rounded-full hover:bg-gray hover:bg-opacity-10"
                    @click="incrementMonth(1)"
                ></ChevronRight>
            </div>
            <div class="p-4 flex flex-col max-w-lg mx-auto">
                <div class="flex mb-4 w-full">
                    <div
                        v-for="day in weeks[0]"
                        class="text-center cursor-pointer hover:bg-gray hover:bg-opacity-10 rounded-full w-full"
                    >
                        <span class="align-middle text-gray">
                            {{ day.toDateString().substring(0, 1) }}
                        </span>
                    </div>
                </div>
                <div v-for="week in weeksComputed" class="flex mx-auto w-full">
                    <div
                        v-for="day in week"
                        class="relative text-center cursor-pointer hover:bg-gray hover:bg-opacity-10 w-full align-middle"
                        @click="setDay(day.date)"
                    >
                        <div class="w-full absolute top-0 z-0">
                            <div
                                class="bg-opacity-20 h-8 z-0"
                                :class="[
                                    day.in
                                        ? 'bg-gray'
                                        : day.start
                                        ? 'bg-gray ml-4 rounded-l-full'
                                        : day.end
                                        ? 'bg-gray mr-4 rounded-r-full'
                                        : '',
                                ]"
                            ></div>
                        </div>
                        <div
                            class="h-8 aspect-square mx-auto rounded-full font-bold z-10"
                            :class="[
                                day.date.getTime() === now.getTime()
                                    ? 'text-red'
                                    : day.date.getMonth() === month.getMonth()
                                    ? ''
                                    : 'text-gray',
                                day.date.getTime() === selected.getTime()
                                    ? 'outline outline-white outline-2 bg-gray bg-opacity-20'
                                    : 'outline-none',
                            ]"
                        >
                            <span class="align-middle leading-8">{{
                                day.date.getDate()
                            }}</span>
                        </div>
                        <div class="flex p-2">
                            <div
                                class="h-2 w-2 rounded-full mx-auto"
                                :class="[
                                    data?.calendar?.period.activeDays.some(
                                        (d) =>
                                            new Date(d).getMonth() ===
                                                day.date.getMonth() &&
                                            new Date(d).getDate() ===
                                                day.date.getDate()
                                    )
                                        ? 'bg-gray'
                                        : 'bg-none',
                                ]"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>

            <DayQuery class="max-w-screen-lg mx-auto" :day="selected">
            </DayQuery>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { getMonth } from "@/utils/date"
import { computed, onMounted, ref } from "vue"
import { useGetLiveCalendarRangeQuery } from "@/graph/generated"
import { ChevronLeft, ChevronRight } from "@/components/icons"
import DayQuery from "@/components/calendar/DayQuery.vue"
import { current } from "@/services/language"
import { useTitle } from "@/utils/title"
import { useI18n } from "vue-i18n"
import { analytics } from "@/services/analytics"
import { isoDate, isoDateString, toISOStringWithTimezone } from "@/utils/time"

const now = new Date()
const weeks = ref(getMonth(now))
const month = ref(now)
const selected = ref(now)

const weeksComputed = computed(() => {
    return mapDays(weeks.value)
})

const start = computed(() => {
    return toISOStringWithTimezone(weeks.value[0][0])
})

const end = computed(() => {
    const d = new Date(weeks.value[weeks.value.length - 1][6])
    d.setHours(23, 59, 59)
    return toISOStringWithTimezone(d)
})

const { data } = useGetLiveCalendarRangeQuery({
    variables: {
        start,
        end,
    },
})

const startEvent = (date: Date) => {
    const events = data.value?.calendar?.period.events ?? []
    const day = parseInt(isoDateString(date).substring(8, 10))
    for (const e of events) {
        const start = parseInt(
            isoDateString(new Date(e.start)).substring(8, 10)
        )
        if (start === day) {
            return e.start
        }
    }
    return false
}

const endEvent = (date: Date) => {
    const events = data.value?.calendar?.period.events ?? []
    const day = parseInt(isoDateString(date).substring(8, 10))
    for (const e of events) {
        const end = parseInt(isoDateString(new Date(e.end)).substring(8, 10))

        if (end === day) {
            return e.end
        }
    }
    return false
}

const inEvent = (date: Date) => {
    const events = data.value?.calendar?.period.events ?? []
    const day = parseInt(isoDateString(date).substring(8, 10))

    const dayYear = parseInt(isoDateString(date).substring(0, 4))

    const dayMonth = parseInt(isoDateString(date).substring(5, 7))

    for (const e of events) {
        const start = parseInt(
            isoDateString(new Date(e.start)).substring(8, 10)
        )

        let end = parseInt(isoDateString(new Date(e.end)).substring(8, 10))

        const endYear = parseInt(isoDateString(new Date(e.end)).substring(0, 4))

        const endMonth = parseInt(
            isoDateString(new Date(e.end)).substring(5, 7)
        )

        if (endYear != dayYear && endMonth != dayMonth) {
            end = 32
        }

        if (start < day && end > day) {
            return true
        }
    }

    return false
}

const mapDays = (weeks: Date[][]) => {
    return weeks.map((w) => {
        return w.map((date) => {
            const start = startEvent(date)
            const end = endEvent(date)
            return {
                date,
                start: start !== false,
                end: end !== false,
                in: inEvent(date) || (start && end && start !== end),
            }
        })
    })
}

const incrementMonth = (increment: number) => {
    const date = new Date(month.value)
    date.setMonth(date.getMonth() + increment)
    month.value = date
    weeks.value = getMonth(date)
}

const setDay = (day: Date) => {
    selected.value = day
    month.value = day
    weeks.value = getMonth(day)

    analytics.track("calendarday_clicked", {
        calendarView: "month",
        calendarDate: day.toISOString(),
        pageCode: "calendar",
    })
}

const { setTitle } = useTitle()
const { t } = useI18n()

onMounted(() => {
    weeks.value = getMonth(now)
    setTitle(t("page.calendar"))
    analytics.page({
        id: "calendar",
        title: t("page.calendar"),
    })
})
</script>
