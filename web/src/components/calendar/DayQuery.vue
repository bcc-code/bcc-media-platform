<template>
    <div class="flex" v-if="fetching">
        <h1 class="text-gray mx-auto text-xl">Loading</h1>
    </div>
    <div v-else-if="data?.calendar?.day.entries.length">
        <div class="lg:grid grid-cols-2 px-4">
            <div
                v-for="entry in data.calendar.day.entries"
                class="flex gap-4 p-2 pl-4"
                :class="[
                    isNow(entry)
                        ? 'border-red border-l-4 bg-red bg-opacity-10'
                        : '',
                ]"
            >
                <div>
                    <h1 class="text-lg lg:text-xl font-semibold">
                        {{
                            isNow(entry)
                                ? $t("live.now")
                                : startTime(entry.start)
                        }}
                    </h1>
                    <p class="text-md lg:text-lg text-gray">
                        {{ duration(entry) }}
                    </p>
                </div>
                <div>
                    <h1 class="text-lg lg:text-xl font-semibold">
                        {{ entry.title }}
                    </h1>
                    <p class="text-md lg:text-lg text-primary">
                        {{ entry.description }}
                    </p>
                </div>
            </div>
        </div>
        <p class="text-gray text-center">
            {{ $t("calendar.timeTableIsLocalTime") }}
        </p>
    </div>
    <div v-else class="flex p-4">
        <h1 class="text-xl mx-auto text-gray">
            {{ $t("calendar.noScheduledEvents") }}
        </h1>
    </div>
</template>
<script lang="ts" setup>
import { useGetCalendarDayQuery } from "@/graph/generated"
import { computed, ref, watch } from "vue"
import { toISOStringWithTimezone } from "@/utils/time"

const now = new Date()

const props = defineProps<{
    day: Date
}>()

const selectedDay = ref(props.day)

watch(
    () => props.day,
    () => {
        selectedDay.value = props.day
    }
)

const dateInLocale = computed(() => {
    return toISOStringWithTimezone(selectedDay.value)
})

const { data, fetching } = useGetCalendarDayQuery({
    variables: {
        day: dateInLocale,
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
