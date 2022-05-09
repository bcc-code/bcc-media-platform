
export function getStatusFromOld(status: number): string {
    switch (status) {
        case 0: return "draft"
        case 1: return "published"
        default: "draft"
    }
}

export function getStatusFromNew(status: string): number {
    switch (status) {
        case "published": return 1
        default: return 0
    }
}