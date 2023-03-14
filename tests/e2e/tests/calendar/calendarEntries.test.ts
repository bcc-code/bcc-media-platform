import test from "ava"
import { faker } from "@faker-js/faker";
import { createCalendarentry, getCalendarDay } from "lib/apiResponseFromCalendar"
import { authed } from "lib/utils";

authed(test)

test("CalendarEntries", async (t) => {

    const calendarData =
    {
        title: faker.random.words(5),
        start: new Date("2023-10-01T00:00:00Z"),
        end: new Date("2023-10-05T00:00:00Z")
    };

    await createCalendarentry({ title: calendarData.title, start: calendarData.start, end: calendarData.end });

    let apiResponse = await getCalendarDay(calendarData.start);

    let newestCalenderEntry = apiResponse.data.calendar.day.entries.find((entry) => entry.title == calendarData.title);

    t.is(newestCalenderEntry.title, calendarData.title, "Calendar's title can't be recived or checked a different title ")
    t.is(new Date(newestCalenderEntry.start).toISOString(), calendarData.start.toISOString(), "Calender's startDate can't be recived or checked a different date")
    t.is(new Date(newestCalenderEntry.end).toISOString(), calendarData.end.toISOString(), "Calender's endDate can't be recived or checked a different date")

})