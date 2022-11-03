<template>
    <section class="font-medium">
        <div class="aspect-video w-full">
            <Player></Player>
        </div>
        <div>
            <div class="flex stroke-gray text-gray p-4">
                <ChevronLeft></ChevronLeft>
                <p class="w-full text-center">This week</p>
                <ChevronRight></ChevronRight>
            </div>
            <div class="grid grid-cols-7">
                <div
                    v-for="day in week"
                    class="text-center cursor-pointer hover:bg-gray hover:bg-opacity-10 rounded-full"
                    @click="selected = day.getDay()"
                >
                    <span class="align-middle text-gray">
                        {{ day.toDateString().substring(0, 1) }}
                    </span>
                    <div
                        class="h-8 aspect-square mx-auto rounded-full font-bold"
                        :class="[
                            day.getDay() === now.getDay() ? 'text-red' : '',
                            day.getDay() === selected
                                ? 'outline outline-white outline-2 bg-gray bg-opacity-20'
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
            <div class="columns-3 p-4">
                <div
                    v-for="entry in dayQuery.data.value?.calendar?.day.entries"
                    class="flex gap-4 border-l-4 p-2 pl-4"
                    :class="[
                        isNow(entry)
                            ? 'border-red bg-red bg-opacity-10'
                            : 'border-opacity-0',
                    ]"
                >
                    <div>
                        <h1 class="text-lg lg:text-xl">{{ isNow(entry) ? t("live.now") : startTime(entry.start) }}</h1>
                        <p class="text-sm lg:text-lg text-gray">{{ duration(entry) }}</p>
                    </div>
                    <div>
                        <h1 class="text-lg lg:text-xl">{{ entry.title }}</h1>
                        <p class="text-sm text-primary">{{}}</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { ChevronLeft, ChevronRight } from "@/components/icons"
import Player from "@/components/live/Player.vue"
import { getWeek } from "@/utils/date"
import { computed, ref } from "vue"
import {
    useGetLiveCalendarRangeQuery,
    useGetLiveCalendarDayQuery,
} from "@/graph/generated"
import { useI18n } from "vue-i18n"

const { t } = useI18n()

const now = new Date()

const week = getWeek(now)

const selected = ref(now.getDay())

const start = computed(() => {
    return week[0]
})

const end = computed(() => {
    return week[6]
})

const { data } = useGetLiveCalendarRangeQuery({
    variables: {
        start,
        end,
    },
})

const selectedDay = computed(() => {
    return week.find((i) => i.getDay() === selected.value) as Date
})

const dayQuery = useGetLiveCalendarDayQuery({
    variables: {
        day: selectedDay,
    },
})

const isNow = (entry: { start: string; end: string }) => {
    return new Date(entry.start) < now && new Date(entry.end) > now
}

const duration = (entry: { start: string; end: string }) => {
    const start = new Date(entry.start)
    const end = new Date(entry.end)
    const diff = Math.floor((end.getTime() - start.getTime()) / 1000)

    let str = ""
    const days = Math.floor(diff / 3600 / 24)
    if (days) {
        str += days + "d "
    }

    const hours = Math.floor((diff % (3600 * 24)) / 3600)
    if (hours) {
        str += hours + "h "
    }

    const minutes = Math.floor((diff % 3600) / 60)
    if (minutes) {
        str += minutes + "m "
    }

    return str
}

const startTime = (timestamp: string) => {
    const date = new Date(timestamp)

    return (
        date.getHours().toString().padStart(2, "0") +
        ":" +
        date.getMinutes().toString().padStart(2, "0")
    )
}
</script>
