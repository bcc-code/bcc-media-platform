export const getWeek = (initial: Date) => {
    const week: Date[] = []
    for (let i = 1; i <= 7; i++) {
        const day = new Date(initial)
        day.setDate(day.getDate() - initial.getDay() + i)
        week.push(day)
    }
    return week
}

export const getMonth = (initial: Date) => {
    const weeks: Date[][] = []
    initial.getMonth()

    const date = new Date(initial)

    date.setDate(1)
    while (date.getMonth() === initial.getMonth()) {
        weeks.push(getWeek(date))
        date.setDate(date.getDate() + 7)
    }
    return weeks
}

