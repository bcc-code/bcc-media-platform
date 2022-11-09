
export const getImageSize = (width: number) => {
    const breakpoints = [100, 200, 300, 420, 640, 720, 868, 1080]

    for (const bp of breakpoints) {
        if (width < bp) {
            return bp
        }
    }
    return 420
}
