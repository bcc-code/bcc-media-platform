import test from "ava"
import { faker } from "@faker-js/faker";
import { createCalendarentry, getCalendarDay } from "lib/apiResponseFromCalendar"
import { authed } from "lib/utils";

authed(test)

test("Calendar", async (t) => {
    const startdate = faker.date.recent(2);
    const enddate = faker.date.recent();
    const title = faker.random.words(5)
    await createCalendarentry({ title: title, start: startdate, end: enddate });
    let apiResponse = await getCalendarDay(startdate)
    console.log(JSON.stringify(apiResponse))
    // check if apiResponse contains an entry with the same title
})