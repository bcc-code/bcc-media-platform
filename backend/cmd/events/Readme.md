# Events

`Events` is a service for handling arbitrary events that this system might care about
It can accept, and process simple events in multiple formats.

## POST

The preferred way of submitting events is in JSON format using the POST method.

The event wrapper should be constructed as following:

```
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "event.happened", // Arbitrary string, identifying the format of the data sent
	"data": {"A": "B", "C": 99 }, // Arbitrary json object containing the actual data
}
```

Some special types and data formats are specified in the section below.

### Bible Verse

```
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "bibleverse", // Arbitrary string, identifying the format of the data sent
	"data": {
		"edition": "NKJV", // Bible edition that the verse "belongs" to
		"verse": "Psa 1/2-3", // Format is defined in https://bcc-code.gitbook.io/bible-server/canonical-representation-of-verses
		"text": "I begynnelsen skapte Gud himmelen og jorden. Og jorden var øde og tom, og det var mørke over det store dyp, og Guds Ånd svevde over vannene. Da sa Gud: Det bli lys! Og det blev lys.", // Optional
		"readBy": "Max Mustermann" // Optional
	},
}
```

### Song

```
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "song", // Arbitrary string, identifying the format of the data sent
	"data": {
		"id": "HV123", // Do we have a canonical way of identifying songs?. Can be omitted if the song is not present in a songbook
		"title": "The title of the song" // Required if ID is not present
		"people": { // a map<string, string[]> where map<"Role", "Person name"[]>. The roles presented here are recommended but can be omitted if not relevant. New roles can be added freely but the name should be self-explanatory
			"textAuthors": ["Text Textington"],
			"melodyAuthors": ["Old Kligon folk melody"],
			"solists" ["Vocal: Sven Singer", "Piano: Kacey Keys"],
			"arrangedBy": ["Arry Arranger"],
		}
	},
}
```

### Speech

```
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "song", // Arbitrary string, identifying the format of the data sent
	"data": {
		"person": { // Required
			"fullName": "Toddy Talkative", // Required
			"personId": 1234, // Optional
			"church": "Svartskog", // Optional
		},
		"translator": { // Optional, for cases of the translator being on stage together with the speaker
			"fullName": "Tom Translator", // Required
			"personId": 1234, // Optional
			"church": "Svartskog", // Optional
		}
	},
}
```

### Generic Text
This is primarily meant for things like lower thirds


```
{
	"timestamp": "2009-11-11T08:00:00+09:00", // RFC3339 formatted
	"source": "some-system", // Arbitrary string identifying the source of the message, Informative
	"type": "song", // Arbitrary string, identifying the format of the data sent
	"data": {
		"text": "Lorem ipsum", // Required
		"format": "plain", // Optional, Defaults to "plain". Allowed: plain, html, markdown
	},
}
```

## GET

This is for cases where a POST request is not possible.

The basic format is as following:

```
	?timestamp=2009-11-11T08%3A00%3A00%2B09%3A00
	&source=some-system
	&type=some-type
	&data=<BASE64 ENCODED JSON STRING>
```

The constraints and requirements are the same as for the JSON version
