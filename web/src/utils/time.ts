export const secondsToTime = (seconds: number) => {
    let str = ""
    const hours = Math.floor(seconds / 3600)
    if (hours) {
        str += hours + ":"
    }

    const minutes = Math.floor((seconds % 3600) / 60)
    if (minutes || hours) {
        str += minutes.toString().padStart(2, "0") + ":"
    }

    const s = Math.floor((seconds % 3600) % 60)
    str += s.toString().padStart(2, "0")

    return str
}

export const percentageWidth = (duration: number, progress: number) => {
    return "width: " + (progress / duration) * 100 + "%"
}

export const toISOStringWithTimezone = (date: Date) => {
    const tzOffset = -date.getTimezoneOffset()
    const diff = tzOffset >= 0 ? "+" : "-"
    const pad = (n: number) => `${Math.floor(Math.abs(n))}`.padStart(2, "0")
    return (
        date.getFullYear() +
        "-" +
        pad(date.getMonth() + 1) +
        "-" +
        pad(date.getDate()) +
        "T" +
        pad(date.getHours()) +
        ":" +
        pad(date.getMinutes()) +
        ":" +
        pad(date.getSeconds()) +
        diff +
        pad(tzOffset / 60) +
        ":" +
        pad(tzOffset % 60)
    )
}
