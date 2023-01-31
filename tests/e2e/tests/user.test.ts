
import test from "ava"
import { randomUUID } from "crypto"
import { query } from "lib/api"

const genUserHeaders = () => {
    return {
        "user-data": JSON.stringify({
            Anonymous: false,
            ActiveBCC: true,
            PersonID: randomUUID(),
            Roles: ["bcc-members", "registered"]
        })
    }
}

test("user specific loads", async (t) => {

    t.timeout(300000, "timed out")
    const promises: Promise<any>[] = [];

    for (let i = 0; i < 10; i++) {
        await query(`query {
            application {
                page {
                    title
                    sections {
                        items {
                            ... on ItemSection {
                                items {
                                    items {
                                        title
                                        item {
                                            ... on Episode {
                                                season {
                                                    title
                                                    show {
                                                        title
                                                    }
                                                }
                                            }
                                            ... on Season {
                                                show {
                                                    title
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }`, {}, genUserHeaders())
    }

    await Promise.all(promises)

    t.assert(true)
})
