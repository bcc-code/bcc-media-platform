import { sleep, check } from 'k6'
import http from 'k6/http'
import execution from "k6/execution"
import { pageQuery, setEpisodeProgressQuery } from "./queries.js";

export const options = {
    ext: {
        loadimpact: {
            distribution: { 'amazon:se:stockholm': { loadZone: 'amazon:se:stockholm', percent: 100 } },
            apm: [],
        },
    },
    thresholds: {},
    scenarios: {
        'page-load': {
            executor: 'ramping-vus',
            gracefulStop: '30s',
            stages: [
                { target: 30, duration: '20s' },
                { target: 30, duration: '60s' },
                { target: 0, duration: '5s'}
            ],
            gracefulRampDown: '30s',
            exec: 'pageload',
        },
    },
    url: __ENV.API_ENDPOINT,
    token: __ENV.ACCESS_TOKEN,
}

/**
 *
 * @param query {string}
 * @param variables {object}
 */
const request = (user, query, variables) => {
    return http.post(options.url, JSON.stringify({query, variables}), {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': options.token ? `Bearer ${options.token}` : undefined,
            'x-user-data': JSON.stringify(user),
        }})
}

const getUser = () => {
    const id = execution.vu.idInTest//*Math.floor(Math.random()*10000)
    const user = {
        PersonID: "test-" + id,
        DisplayName: "test-" + id,
        Email: "test-" + id + "@test.local",
        Roles: ["bcc-members"],
        Anonymous: false,
        request: function(query, vars) {
            return request(this, query, vars)
        }
    }
    return user
}

export function pageload() {
    const user = getUser()
    let response

    // Page Load
    response = user.request(pageQuery, {code: "frontpage", first: 30, sectionFirst: 20})

    check(response, {
        'error is null': r => !r.json()["errors"],
    })

    if (response.json()["errors"]) {
        console.log(response.json().errors)
        sleep(5)
    }

    const episodes = response.json()["data"]["page"]["sections"]["items"].reduce((a, b) => {
        if (b.items && b.items.items) {
            a.push(...b["items"]["items"])
        }
        return a
    }, []).filter(i => i["item"]["__typename"] === 'Episode')

    let i = 0

    for (const e of episodes) {
        if (i >= 10) {
            break
        }
        i++
        sleep(0.1)
        const progress = Math.floor(Math.random() * 100)
        const r = user.request(setEpisodeProgressQuery, {
            "id": e["id"],
            "progress": progress,
            "duration": e["item"]["duration"]
        })
        check(r, {
            'returned episode id is equal': r => r.json()["data"]["setEpisodeProgress"]["id"] === e.id
        })
    }

    response = user.request(`query {
        me {
            email
        }
    }`, {})

    check(response, {
        'email is email': r => r.json()["data"]["me"]["email"] === user.Email
    })

    // Automatically added sleep
    sleep(1)
}
