export const getWeek = (initial: Date) => {
    const week: Date[] = []
    for (let i = 1; i <= 7; i++) {
        const day = new Date(initial)
        day.setDate(day.getDate() - initial.getDay() + i)
        week.push(day)
    }
    return week
}
