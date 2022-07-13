# Real time communication

## Current use cases

* Maintenance message
* Snack Bar
* APP Settings

## Requirements

The system must be able to fulfill it's core function even if the real time component is down.

For the purposes of this document the core functions are:

* Live playback
* Search
* VOD playback

## Proposed implementation

All actual data is delivered via the main API. This protects potential confidential informations
and at the same time allows any system to opt into polling the endpoint instead of using the Firestore.

How exactly the data is delivered there is up to each separate use case.

In addition we will establish a *public* Firestore document in the format:

```json
{
	"maintenanceMessage": "2022-07-13T12:03:50.000Z",
	"appConfig": "2022-07-13T12:03:50.000Z"
}
```

This serves only as a notification that *something* has changed in that area and that the app should
refresh the data. It is up to the application to act on the change notification.
(This could perhaps be configurable to enable data saving??)

## Exceptions

There may be exceptions where a real time information is wanted in the app that should be delivered
directly (people watching for example). This can be evaluated case-by-case and documents/collections
can be created to cover that need.

## General guideline

In general we should have a critical standpoint towards real-time things as often that is not actually needed.
For example showing what event is currently active and maybe enabling a special logo can be achieved
by the app reading the calendar and scheduling the change to happen at the appropriate time.

Maybe we should consider and additional document that allows us to schedule events in the app for such use cases?

