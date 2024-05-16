# Pubsub helper

This is just a simple helper, to set up a topic & push subscription
on the pubsub emulator, and then send some message.
Cleanup is done at the end so the program can be re-run w/o errors

## Running

```
env $(cat .env | xargs) go run .
```
