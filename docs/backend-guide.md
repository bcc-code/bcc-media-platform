
## Implementing new backend features

Here's a general overview of the development process for a brand new feature:

1. Start in one end. Either the data/admin side or the API side.

- Create your data structure and admin interface for the feature via directus

2. Go to the other end:

- Define your graphql schema for how you want to expose the feature

3. Fill in between:

- Codegen the graphql resolvers
- Write sql queries to get the data you need.
- Write [dataloaders]() to get the data
  - To support dataloaders, think in batches when writing queries: Instead of `SELECT * FROM episodes where id = 'abc'`, think `SELECT * FROM episodes where id = ANY ('abc', 'abc2')`.
  
## Mediaitems

- A mediaitem is the base content type for every playable piece of content.
- Episodes, shorts, etc. are lightweight wrappers around mediaitems to aid discovery and display.
- Mediaitems aren't exposed by themselves, and is only available if an episode points to them.
- Shows and seasons are just for structuring and logic.
- Two episodes can point to the same mediaitem.
  - A use case for this is: Magazine during a conference should show under both "Magazine" and "Summer conference".
  - A mediaitem has a "primary episode id" to know which one to use in scenarios where we just want 1 thing per mediaitem (e.g. listing contributions).

## Pages, collections, etc

Pages are complex since they can contain so many things.

Here's an overview:

- Pages has sections with many different section types: ItemSection, AchievementSection, MessageSeciton, etc.
- The most common section type is ItemSection.
- ItemSections has many subtypes for the different styles: DefaultSection (horizontal thumbnail slider), PosterSection, GridSection, etc.
- ItemSections always source their items from a `collection`.
- Collections are built in admin, and can either be "select" or "query" (in other words: hand-picked or built via a query-builder.)
- When collections are "query"-based, the queries runs against a materialized view: `filter_dataset`
- `filter_dataset` contains all the possible items union'ed into a single view: episodes, shows,
- `filter_dataset` is a materialized view where tags, roles, etc. has been denormalized.
- `filter_dataset` is refreshed on an interval ([Here's the cloud scheduler job infra code.](https://github.com/bcc-code/bcc-media-platform/blob/9c5f277c54330d1ef052bf7a864156031c0484cf/infra/cloud-scheduler.tf#L10))

### Special collections

Collections also back personalized collections like "Continue watching", "shorts" (algorithm-based random shorts), and "My list".

These work exactly like other collections, but has an additional filtering step. Example for "my list":

- Get collection ids like normal, based on the configuration for the collection. This is cached. Let's say it returns IDs: 1,2,3,4,5
- Get all ids in this specific user's "my_list" (favorites): IDs are 1,3,8,10.
- You end up with IDs 1,3

### Adding new models to pages:

- Create your model and admin via directus
- Add the model to `filter_dataset`.
- Remember that we always diff local db when creating migrations, so you can edit the view locally via an SQL admin tool while working and create the migration later. It's also fine to write the migration manually.
- Remember to refresh the view since we dont do that automatically locally AFAIK.
  - Tip: In directus, under the "insights" tab, you can add the "API Tools" panel. This is a custom panel which has a button to trigger a refresh of the dataset.
- `filter_dataset` is just used for finding IDs. While resolving the collections, we need to map them to section items. This is done via `mapCollectionEntriesToSectionItems`.