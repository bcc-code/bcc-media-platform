import { GetCalendarDayQuery, useGetCalendarDayQuery } from "@/graph/generated"
import { ref, Ref } from "vue"

const currentDay: Ref<
    NonNullable<GetCalendarDayQuery["calendar"]>["day"] | null
> = ref(null)

const load = async () => {
    const { executeQuery } = useGetCalendarDayQuery({
        variables: {
            day: new Date().toISOString(),
        },
    })

    currentDay.value = (await executeQuery()).data.value?.calendar?.day ?? null
}

export const useCalendar = () => ({
    load,
    currentDay,
})
