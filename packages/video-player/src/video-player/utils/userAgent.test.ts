import { afterEach, describe, expect, it, vi } from "vitest"
import { isSmartTV } from "./userAgent"

function stubUserAgent(value: string | undefined): void {
    if (value === undefined) {
        vi.stubGlobal("navigator", undefined)
        return
    }
    vi.stubGlobal("navigator", { userAgent: value })
}

describe("isSmartTV", () => {
    afterEach(() => {
        vi.unstubAllGlobals()
    })

    it.each([
        ["Mozilla/5.0 (SMART-TV; Linux; Tizen 2.3) AppleWebKit/538.1"],
        ["Mozilla/5.0 (SmartTV; Linux) AppleWebKit"],
        ["Mozilla/5.0 (Linux; Tizen 6.0)"],
        ["Mozilla/5.0 (Web0S; Linux/SmartTV) AppleWebKit"],
        ["Mozilla/5.0 (WebOS; Linux/SmartTV)"],
        ["Mozilla/5.0 HbbTV/1.4.1 (; Sony; KDL55W815B; ; sony.com)"],
        ["Mozilla/5.0 (X11; Linux i686) Chrome/41 GoogleTV"],
        ["Mozilla/5.0 (X11; Linux) AppleTV5,3"],
        ["Mozilla/5.0 (X11; Linux) CrKey/1.36"],
    ])("recognizes smart-TV UA %#", (ua) => {
        stubUserAgent(ua)
        expect(isSmartTV()).toBe(true)
    })

    it.each([
        // standard desktop / mobile UAs
        ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15"],
        ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"],
        ["Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) AppleWebKit/605.1.15"],
        ["Mozilla/5.0 (Linux; Android 14; Pixel 8)"],
    ])("does not falsely match desktop / mobile UA %#", (ua) => {
        stubUserAgent(ua)
        expect(isSmartTV()).toBe(false)
    })

    it("returns false when navigator is undefined (SSR)", () => {
        stubUserAgent(undefined)
        expect(isSmartTV()).toBe(false)
    })
})
