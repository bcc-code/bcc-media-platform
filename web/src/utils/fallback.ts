export function fallback<T = any>(...args: T[]) {
    for (const arg of args) {
        if (arg) {
            return arg
        }
    }
    return null
}
