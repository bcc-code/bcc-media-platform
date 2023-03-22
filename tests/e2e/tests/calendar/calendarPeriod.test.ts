import test from "ava"
import { faker } from "@faker-js/faker";
import { createCalendarentry, getCalendarPeriod } from "lib/apiResponseFromCalendar"
import { authed } from "lib/utils";

authed(test)

test("CalendarPeriods", async (t) => {

    const days = [
        {
            start: new Date("2024-05-01T04:00:00Z"),
            end: new Date("2024-05-01T09:00:00Z"),
        },
        {
            start: new Date("2024-05-05T12:00:00Z"),
            end: new Date("2024-05-05T15:00:00Z"),
        },
        {
            start: new Date("2024-05-12T09:00:00Z"),
            end: new Date("2024-05-12T18:00:00Z"),
        }

    ];

    for (var day of days) {

        await createCalendarentry({ title: faker.random.words(3), start: day.start, end: day.end });

    }

    let apiResponse = await getCalendarPeriod(new Date("2024-05-01T00:00:00Z"), new Date("2024-05-31T00:00:00Z"));

    for (let i = 0; i < days.length; i++) {

        t.is(apiResponse.data.calendar.period.activeDays[i].substring(0, 10), days[i].start.toISOString().substring(0, 10))

    }

})