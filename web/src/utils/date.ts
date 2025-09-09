export const getWeek = (initial: Date) => {
    const week: Date[] = []
    for (let i = 1; i <= 7; i++) {
        const day = new Date(initial)
        const d = initial.getDay() === 0 ? 7 : initial.getDay()
        day.setDate(day.getDate() - d + i)
        week.push(day)
    }
    return week
}

export const getMonth = (initial: Date) => {
    initial.getMonth()

    const date = new Date(initial)
    date.setDate(1)

    const days: Date[] = []

    while (date.getMonth() === initial.getMonth()) {
        days.push(new Date(date))
        date.setDate(date.getDate() + 1)
    }

    const sundays = days.filter((i) => i.getDay() % 7 === 0)

    const weeks = sundays.map((i) => getWeek(i))

    const index = sundays.length - 1

    const nextDay = new Date(sundays[index]!)
    nextDay.setDate(nextDay.getDate() + 1)

    if (nextDay.getMonth() === initial.getMonth()) {
        weeks.push(getWeek(nextDay))
    }

    return weeks
}
