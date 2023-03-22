
# Status tests
Available: Possible to get info from API
- [x] status "published": available
- [x] status "unlisted": available
- [x] status "draft": unavailable
- [x] status "archive": unavailable

# Availability dates

`available_from` tests, let `available_to` be null.
- [x] if available_from in future: not available
- [x] if available_from in the past: available
- [x] if available_from null: available

`available_to` tests, let `available_from` be null.
- [x] if available_to in future: available
- [x] if available_to in the past: not available
- [x] if available_to null: available

testing both:
- [x] if available_from in future && available_to in the past: not available
- [x] if available_from in future && available_to in the future: not available
- [x] if available_from in the past && available_to in the past: not available


# Publish date

`publish_date`, for episodes that are available and status: published
- [x] if publish_date in future: episode.streams[] should be empty, or give error
- [x] if publish_date in the past: episode.streams[] should contain an item with a url
- [x] if publish_date in the future: episode.title should be retrievable

# Calendar

Date format: 2023-03-10T00:00:00Z

Calendar entries
- Store variables for title, start, end, etc.
- Create entry for a specific date with the title, start, end, etc.
- Run graphql query for `day(day: $date)` with the same date
- Assert that an entry exists with the same data in the graphql response

Calendar periods
- Create array with a few different days within a month.
- Iterate through the array, create calendar entries for them, data doesnt matter.
- Run graphql query for `period(from: $from, to: $to)`
- Assert that the `data.calendar.period.activeDays` array contains the exact same days as in step 1.