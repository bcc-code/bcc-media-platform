import { describe, expect, it } from "vitest"
import { toConfig, type NPAWOptions } from "./npaw"

const minimal: NPAWOptions = {
    appName: "test-app",
    tracking: {
        metadata: {},
    },
}

describe("toConfig", () => {
    it("emits stable defaults for minimal input", () => {
        expect(toConfig(minimal)).toEqual({
            "content.isLive": false,
            "content.id": undefined,
            "content.title": undefined,
            "content.program": undefined,
            "content.tvShow": undefined,
            "content.season": undefined,
            "content.episodeTitle": undefined,
            "user.obfuscateIp": true,
            "user.name": undefined,
            "app.name": "test-app",
            "app.releaseVersion": "",
            "parse.manifest": true,
            "content.customDimension.1": undefined,
            "content.customDimension.2": undefined,
        })
    })

    it("coerces isLive (only `true` survives — undefined / false / truthy non-bool become false)", () => {
        expect(
            toConfig({ ...minimal, tracking: { ...minimal.tracking, isLive: true } })["content.isLive"]
        ).toBe(true)
        expect(
            toConfig({ ...minimal, tracking: { ...minimal.tracking, isLive: false } })["content.isLive"]
        ).toBe(false)
        expect(
            toConfig({ ...minimal, tracking: { ...minimal.tracking, isLive: undefined } })["content.isLive"]
        ).toBe(false)
        // Non-strict-true falsy / truthy non-bool values coerce to false.
        // The `=== true` guard is intentional — protects against accidental
        // string/number values from untyped consumers.
        expect(
            toConfig({
                ...minimal,
                tracking: { ...minimal.tracking, isLive: 1 as unknown as boolean },
            })["content.isLive"]
        ).toBe(false)
    })

    it("falls back from showTitle to title for content.program", () => {
        const withBoth = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                metadata: { title: "Ep title", showTitle: "Show title" },
            },
        })
        expect(withBoth["content.program"]).toBe("Show title")

        const onlyTitle = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                metadata: { title: "Ep title" },
            },
        })
        expect(onlyTitle["content.program"]).toBe("Ep title")
    })

    it("formats season as `${seasonId} - ${seasonTitle}` when seasonId is present", () => {
        const result = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                metadata: { seasonId: "12", seasonTitle: "Spring 2025" },
            },
        })
        expect(result["content.season"]).toBe("12 - Spring 2025")
    })

    it("leaves content.season undefined when seasonId is missing (even if seasonTitle is set)", () => {
        const result = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                metadata: { seasonTitle: "Spring 2025" },
            },
        })
        expect(result["content.season"]).toBeUndefined()
    })

    it("spreads metadata.overrides last, allowing them to win over computed fields", () => {
        const result = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                metadata: {
                    title: "Original",
                    overrides: {
                        "content.title": "Overridden",
                        "content.customDimension.5": "extra",
                    },
                },
            },
        })
        expect(result["content.title"]).toBe("Overridden")
        expect(result["content.customDimension.5"]).toBe("extra")
    })

    it("maps tracking fields into custom dimensions", () => {
        const result = toConfig({
            ...minimal,
            tracking: {
                ...minimal.tracking,
                userId: "user-1",
                sessionId: "sess-2",
                ageGroup: "18-24",
            },
        })
        expect(result["user.name"]).toBe("user-1")
        expect(result["content.customDimension.1"]).toBe("sess-2")
        expect(result["content.customDimension.2"]).toBe("18-24")
    })
})
