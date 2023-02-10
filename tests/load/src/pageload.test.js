import { sleep, check } from 'k6'
import http from 'k6/http'
import execution from "k6/execution"
import { pageQuery } from "./queries.js";

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
                { target: 20, duration: '10s' },
                { target: 50, duration: '60s' },
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
const request = (query, variables) => {
    const user = {
        PersonID: "test-" + execution.vu.idInTest,
        DisplayName: "test-" + execution.vu.idInTest,
        Email: "test-" + execution.vu.idInTest + "@test.local",
        Roles: ["bcc-members"],
        Anonymous: false,
    }

    return http.post(options.url, JSON.stringify({query, variables}), {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': options.token ? `Bearer ${options.token}` : undefined,
            'x-user-data': JSON.stringify(user),
        }})
}

export function pageload() {
    let response

    // Page Load
    response = request(pageQuery, {code: "frontpage", first: 30, sectionFirst: 20})

    check(response, {
        'error is null': r => !r.json()["errors"],
    })

    response = request(`query {
        me {
            email
        }
    }`, {})

    check(response, {
        'email is email': r => r.json()["data"]["me"]["email"] === "test-" + execution.vu.idInTest + "@test.local"
    })

    // Automatically added sleep
    sleep(1)
}
