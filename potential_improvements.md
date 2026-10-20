# Potential improvements

## Debounce the `filter_dataset` refresh after episode access changes

`episodeAccess.grant` / `revoke` (`backend/graph/admin/episode_access.go`) refresh the `filter_dataset` materialized view in a detached goroutine on every call. Each refresh is `REFRESH ... CONCURRENTLY` and can be slow, and many changes in quick succession each start one; nothing debounces them.

Options:
- Publish a `view.refresh` event (`events.TypeRefreshView`) for the jobs worker instead. The admin `Resolver` needs a Pub/Sub topic for this; it has none yet.
- Debounce refreshes in the API process.
