
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