import { afterEach, beforeEach, describe, expect, it, vi } from "vitest"
import {
    BW_STORAGE_KEY,
    readSavedBandwidth,
    writeSavedBandwidth,
} from "./bandwidth"

interface FakeStorage {
    store: Record<string, string>
    getItem: (k: string) => string | null
    setItem: (k: string, v: string) => void
    removeItem: (k: string) => void
    clear: () => void
}

function fakeStorage(): FakeStorage {
    const store: Record<string, string> = {}
    return {
        store,
        getItem: (k) => (k in store ? store[k] : null),
        setItem: (k, v) => {
            store[k] = String(v)
        },
        removeItem: (k) => {
            delete store[k]
        },
        clear: () => {
            for (const k of Object.keys(store)) delete store[k]
        },
    }
}

function throwingStorage(): FakeStorage {
    const base = fakeStorage()
    return {
        ...base,
        getItem: () => {
            throw new Error("unavailable")
        },
        setItem: () => {
            throw new Error("unavailable")
        },
    }
}

describe("readSavedBandwidth", () => {
    let storage: FakeStorage

    beforeEach(() => {
        storage = fakeStorage()
        vi.stubGlobal("localStorage", storage)
    })

    afterEach(() => {
        vi.unstubAllGlobals()
    })

    it("returns null when nothing is stored", () => {
        expect(readSavedBandwidth()).toBeNull()
    })

    it("returns the stored value parsed as a number", () => {
        storage.setItem(BW_STORAGE_KEY, "5000000")
        expect(readSavedBandwidth()).toBe(5_000_000)
    })

    it("returns null for non-numeric values", () => {
        storage.setItem(BW_STORAGE_KEY, "not a number")
        expect(readSavedBandwidth()).toBeNull()
    })

    it("returns null for zero or negative values", () => {
        storage.setItem(BW_STORAGE_KEY, "0")
        expect(readSavedBandwidth()).toBeNull()

        storage.setItem(BW_STORAGE_KEY, "-1000")
        expect(readSavedBandwidth()).toBeNull()
    })

    it("returns null when localStorage throws (private mode / blocked)", () => {
        vi.stubGlobal("localStorage", throwingStorage())
        expect(readSavedBandwidth()).toBeNull()
    })
})

describe("writeSavedBandwidth", () => {
    let storage: FakeStorage

    beforeEach(() => {
        storage = fakeStorage()
        vi.stubGlobal("localStorage", storage)
    })

    afterEach(() => {
        vi.unstubAllGlobals()
    })

    it("rounds to an integer string", () => {
        writeSavedBandwidth(123_456.78)
        expect(storage.store[BW_STORAGE_KEY]).toBe("123457")
    })

    it("does not write NaN", () => {
        writeSavedBandwidth(Number.NaN)
        expect(storage.store[BW_STORAGE_KEY]).toBeUndefined()
    })

    it("does not write Infinity", () => {
        writeSavedBandwidth(Number.POSITIVE_INFINITY)
        expect(storage.store[BW_STORAGE_KEY]).toBeUndefined()
    })

    it("does not write zero or negative values", () => {
        writeSavedBandwidth(0)
        writeSavedBandwidth(-5_000_000)
        expect(storage.store[BW_STORAGE_KEY]).toBeUndefined()
    })

    it("swallows localStorage errors silently", () => {
        vi.stubGlobal("localStorage", throwingStorage())
        expect(() => writeSavedBandwidth(5_000_000)).not.toThrow()
    })
})
