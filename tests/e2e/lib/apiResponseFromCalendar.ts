import { title } from "process";
import { query } from "./api";
import { api } from "./config";
import { client } from "./directus";

export async function createCalendarentry(args: { title: string, start: Date, end: Date }) {
    const calendarentries = await client.items("calendarentries").createOne({
        status: "published",
        translations: [
            { title: args.title, description: "test", languages_code: "no" }
        ],
        start: args.start.toISOString(),
        end: args.end.toISOString(),
        image_from_link: false,
    })

    return calendarentries
}

export async function getCalendarDay(date: Date) {
    const queryString =
        `
        query($date: Date!) {
            calendar {
                day(day: $date) {
                    entries {
                        start
                        end
                        title
                    }
                }
            }
        }
    `;

    const apiResponse = await query(queryString, {
        date: date.toISOString(),
    })

    return apiResponse
}

export async function getCalendarPeriod(start: Date, end: Date) {
    const queryString = `
        query($start: Date!, $end: Date!) {
            calendar {
                period(from: $start, to: $end) {
                    activeDays
                }
            }
        }
    `;

    const apiResponse = await query(queryString, {
        start: start.toISOString(),
        end: end.toISOString()
    })

    return apiResponse

}