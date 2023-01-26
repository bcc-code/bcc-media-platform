# statistician

Statistician is a tool for generating some statistics from the DB.
For now it is intended for local, one-off use, but may be extended into a full fledged service later.

This tool fetches information from the members api in order to generate the states and may cache them in
a local SQLite DB in order to enable repeat runs. Please note that this has GDPR implications and must be used with caution

## Commands

* study-progress-by-church <study-id>
