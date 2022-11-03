<template>
    <section>
        <div>
            <div v-for="week in weeks" class="grid grid-cols-7">
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
                            day.getDate() === now.getDate() ? 'text-red' : '',
                            day.getDate() === selected
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
        </div>
    </section>
</template>
<script lang="ts" setup>
import { getMonth } from "@/utils/date"
import { computed, ref } from "vue"
import { useGetLiveCalendarRangeQuery } from "@/graph/generated"

const now = new Date()

const weeks = ref(getMonth(now))

const selected = ref(now.getDay())

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
</script>
