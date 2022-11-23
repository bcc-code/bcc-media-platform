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
                <div v-for="week in weeks" class="flex mx-auto w-full">
                    <div
                        v-for="day in week"
                        class="text-center cursor-pointer hover:bg-gray hover:bg-opacity-10 w-full align-middle"
                        @click="setDay(day)"
                    >
                        <div
                            class="h-8 aspect-square mx-auto rounded-full font-bold"
                            :class="[
                                day.getTime() === now.getTime()
                                    ? 'text-red'
                                    : day.getMonth() === month.getMonth()
                                    ? ''
                                    : 'text-gray',
                                day.getTime() === selected.getTime()
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
                                            new Date(d).getMonth() ===
                                                day.getMonth() &&
                                            new Date(d).getDate() ===
                                                day.getDate()
                                    )
                                        ? 'bg-gray'
                                        : 'bg-none',
                                ]"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>

            <DayQuery :day="selected"> </DayQuery>
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

const now = new Date()

const weeks = ref(getMonth(now))

const month = ref(now)

const selected = ref(now)

const incrementMonth = (increment: number) => {
    const date = new Date(month.value)
    date.setMonth(date.getMonth() + increment)
    month.value = date
    weeks.value = getMonth(date)
}

const start = computed(() => {
    return weeks.value[0][0]
})

const end = computed(() => {
    return weeks.value[weeks.value.length - 1][6]
})

const { data } = useGetLiveCalendarRangeQuery({
    variables: {
        start,
        end,
    },
})

const setDay = (day: Date) => {
    selected.value = day
    month.value = day
    weeks.value = getMonth(day)
}

const { setTitle } = useTitle()
const { t } = useI18n()

onMounted(() => {
    setTitle(t("page.calendar"))
    analytics.page({
        id: "calendar",
        title: t("page.calendar")
    })
})
</script>
