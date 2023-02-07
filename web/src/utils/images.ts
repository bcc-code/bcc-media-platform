export const getImageSize = (width: number) => {
    const breakpoints = [80, 160, 320, 640, 960, 1280, 1920, 3640]

    for (const bp of breakpoints) {
        if (width < bp) {
            return bp
        }
    }
    return 3640
}
