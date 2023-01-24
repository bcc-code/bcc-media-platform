import { TestFn } from "ava";
import { client, login } from "./client";

export const authed = (test: TestFn<unknown>) => {
    test.before("init auth", async () => {
        if (!await client.auth.token) {
            console.log("authenticate")
            await login()
        }
    })
}