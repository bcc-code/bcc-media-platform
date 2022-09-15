<template>
    <section>
        <div>
            <input class="bg-secondary" type="date" v-model="from" />
            <input class="bg-secondary" type="date" v-model="to" />
        </div>
        <div v-if="calendar">
            {{ calendar.period }}
            <div v-for="d in calendar.period.activeDays">{{ d }}</div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { useGetCalendarPeriodQuery } from "@/graph/generated"
import { computed, ref } from "vue"

const date = new Date()

const dateToString = (date: Date) => {
    return `${date.getFullYear()}-${(date.getMonth() + 1)
        .toString()
        .padStart(2, "0")}-${date.getDate().toString().padStart(2, "0")}`
}

const from = ref(dateToString(date))
date.setDate(date.getDate() + 7)
const to = ref(dateToString(date))

const fromString = computed(() => {
    return new Date(from.value).toISOString()
})

const toString = computed(() => {
    return new Date(to.value).toISOString()
})

const { data } = useGetCalendarPeriodQuery({
    variables: {
        from: fromString,
        to: toString,
    },
})

const calendar = computed(() => {
    return data.value?.calendar ?? null
})
</script>
