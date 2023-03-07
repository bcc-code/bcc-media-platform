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
                { target: 100, duration: '50s' },
                { target: 100, duration: '60s' },
                { target: 0, duration: '20s'}
            ],
            gracefulRampDown: '30s',
            exec: 'pageload',
        },
        'user-data': {
            executor: 'ramping-vus',
            gracefulStop: '30s',
            stages: [
                { target: 100, duration: '50s' },
                { target: 100, duration: '60s' },
                { target: 0, duration: '20s'}
            ],
            gracefulRampDown: '30s',
            exec: 'userdata',
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
            'x-user-data': JSON.stringify({
                PersonID: user.PersonID,
                DisplayName: user.DisplayName,
                Email: user.Email,
                Roles: user.Roles,
                Anonymous: user.Anonymous,
            }),
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

const isSuccess = (v) => {
    if (v.errors) {
        console.log(v.errors)
        sleep(5)
        return false
    }
    return true
}

export function pageload() {
    const user = getUser()
    let response

    // Page Load
    response = user.request(pageQuery, {code: "frontpage", first: 30, sectionFirst: 20})

    isSuccess(response.json())

    check(response, {
        'error is null': r => !r.json()["errors"],
    })
    
    isSuccess(response.json())
}

export function userdata() {
    const user = getUser()

    let response = user.request(`query {
        me {
            email
        }
    }`, {})

    check(response, {
        'email is email': r => {
            try {
                return r.json()["data"]["me"]["email"] === user.Email
            } catch (e) {
                console.log(r.body.toString())
                return false
            }
        }
    })

    isSuccess(response.json())
}