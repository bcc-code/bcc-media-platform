# Search engine analysis

Findings from a review of `backend/search` (Elasticsearch 8.15). Each claim below was
verified either by reading the code or by running the analyzer/query against a local
Elasticsearch built from `backend/search/templates/indices.json.tmpl`.

Ordered roughly by impact on result quality.

---

## 1. Result sets depend on the shape of the `Accept-Language` header

`Languages` comes straight from `utils.ParseAcceptLanguage` (`cmd/api/main.go:365`), which
does not de-duplicate. A stock Chrome header on a Norwegian machine,
`nb-NO,nb;q=0.9,no;q=0.8,en-US;q=0.7,en;q=0.6`, parses to `["no","no","no","en","en"]`.

`main-elastic.json.tmpl` emits one block of clauses _per language entry_, so that user gets
27 `should` clauses instead of 11, with `prefix:title_no` repeated three times. Rendered
output:

```
LANGS [no]              -> 11 should clauses,  prefix title_no x1
LANGS [no no no en en]  -> 27 should clauses,  prefix title_no x3, prefix title_en x2
```

`bool.should` **sums** clause scores, and `prefix` is a constant-score query (always exactly
1.0). Measured against a document titled `Høstcamp`:

| query                       | score       |
| --------------------------- | ----------- |
| 1× `prefix title_no: hostc` | 1.0         |
| 3× `prefix title_no: hostc` | 3.0         |
| 1× prefix, `min_score: 3`   | **no hits** |
| 3× prefix, `min_score: 3`   | **1 hit**   |

So two users searching the same word get different _result sets_, decided by how redundant
their browser's language header happens to be.

**Fix:** `lo.Uniq` the language list before building the query (and preferably cap it to the
languages the index actually has analyzers for).

---

## 2. `min_score: 3` is doing the job of `minimum_should_match`

The bool query has `filter` + `should` and no `must`, so Elasticsearch defaults
`minimum_should_match` to 0 — every document passing the permission filters matches, at
score 0:

```
filter-only, no should match, no min_score  -> [('1', 0.0), ('2', 0.0)]
filter-only, no should match, min_score: 3  -> []
```

The hardcoded `min_score: 3` is the only thing excluding non-matches. That is fragile for two
reasons:

- BM25 scores are not normalised. A legitimate match on a common term (low IDF) can land
  under 3 and vanish; a weak match on a rare term sails over it.
- The threshold interacts with every boost and with the clause duplication in §1, so tuning
  any boost silently changes which documents are returned, not just their order.

**Fix:** set `"minimum_should_match": 1` on the bool query and drop (or drastically lower)
`min_score`.

---

## 3. The `minScore` GraphQL argument is accepted and then discarded

`search(queryString, first, offset, cursor, type, minScore)` plumbs `minScore` through
`searchResolver` → `common.SearchQuery.MinScore` (`graph/api/search-resolver.go:170`), and
`doElasticSearch` never reads the field. The template hardcodes `"min_score": 3`.

`web/src/graph/queries/search.graphql` declares `$minScore` and passes it, so the web client
believes it is tuning something it is not. The `cursor` argument is ignored the same way.

**Fix:** use `query.MinScore` in `elasticQueryParams` (with 3 as the default), or remove the
argument from the schema.

---

## 4. Prefix matching is broken for any capitalised query

`prefix` is a term-level query: it is **not** analysed. Every indexed term is lowercased, so:

```
prefix title_no "hostc"  -> 1 hit
prefix title_no "høstc"  -> 1 hit
prefix title_no "Høstc"  -> 0 hits
prefix title_no "det som" -> 0 hits   (no single term contains a space)
```

Mobile keyboards auto-capitalise the first letter, so a large share of real queries hit the
dead case. Multi-word queries never match a prefix clause at all.

Combined with §2: a prefix-only match scores 1.0 and the threshold is 3, so for a user with a
clean single-language header the prefix clauses can _never_ produce a result on their own.
They are effectively dead weight — the "høstcam" → "Høstcamp" test in `query_test.go` passes
because of `fuzziness: AUTO`, not because of the prefix clauses.

**Fix:** add `"case_insensitive": true` to the prefix clauses, or replace them with
`match_bool_prefix` / `match_phrase_prefix`, which analyse the input and handle multi-word
input. Give them a boost that can actually clear the score floor.

---

## 5. Synonyms only work in Norwegian

`bcc_synonyms` sits **after** the stemmer in every analyzer except the Norwegian ones:

```
english_us_analyzer:  lowercase, english_stop, english_stemmer, bcc_synonyms, ascii_folding
german_analyzer:      ... german_stemmer, bcc_synonyms, ascii_folding
danish_analyzer:      ... danish_stemmer,  bcc_synonyms, ascii_folding
norwegian_analyzer:   ascii_folding, lowercase, bcc_synonyms, scandinavian_normalization, ...
```

Elasticsearch runs the synonym _rules_ through the preceding filter chain, so the rules get
stemmed too and partially still fire — but the output is unpredictable:

```
german_title_analyzer("brunstadfest") -> ['brunstadf', 'misjonsf']
norwegian_title_analyzer("maga")      -> ['magasin', 'magazin']
german_title_analyzer("maga")         -> ['magasinet', 'magazin']   # unstemmed output
```

The German expansion emits the _unstemmed_ `magasinet`, which will not match a German
document where that word was stemmed. The rule list is also being matched against stemmed
tokens, so adding a rule like `påskestevne => ...` later will silently not fire.

**Fix:** move `bcc_synonyms` to immediately after `lowercase` (before normalisation,
decompounding and stemming) in every analyzer, consistently.

---

## 6. Token explosion distorts BM25 scoring

`ascii_folding` uses `preserve_original: true` and sits alongside `scandinavian_normalization`,
the decompounder and synonym expansion. The combinations produce large numbers of duplicate
tokens at the same position, which inflate term frequency and shrink the field-length norm:

```
danish_title_analyzer("paaske")      -> 10 tokens: pask påsk pask pask påsk pask påsk pask pask påsk
norwegian_title_analyzer("Påskestevnet") -> ['paskestevn','pask','stevn','påskestevn','påsk','stevn']
norwegian_title_analyzer("Høstcamp")     -> ['hostcamp','camp','høstcamp','høst','camp']
```

Scandinavian normalisation already folds `å/æ/ø`, so `ascii_folding` on top of it is mostly
redundant and only generates the duplicates. With an absolute `min_score` floor (§2) this
directly changes which documents are returned.

**Fix:** drop `ascii_folding` from the Scandinavian analyzers (keep
`scandinavian_normalization`), or set `preserve_original: false` there. Add
`"only_longest_match": true` to the decompounders to reduce duplicate subwords.

---

## 7. Half the content languages have no analyzer at all

The index template defines analyzers for `en de no da fi nl es pl bg sl`. The production
documents (see the `Source` struct in `query_test.go`, generated from a real index dump)
contain `title_fr`, `title_hu`, `title_it`, `title_pt`, `title_ro`, `title_tr` — and the
mapped `es/pl/bg/sl` do not appear in the dump at all.

Unmapped language fields fall through to the `strings_as_keywords` dynamic template, which
gives them the **default `standard` analyzer**: no stemming, no ascii folding, no synonyms, no
`index_prefixes`. French, Hungarian, Italian, Portuguese, Romanian and Turkish search is
therefore exact-token-only.

Worse, a user whose `Accept-Language` is one of these gets primary clauses pointing at fields
with no analysis, and the only clauses with real recall are the `AuxLanguages` ones at boost
0.5/0.9 — which generally cannot clear `min_score: 3`. Those users can get **no results at
all** for queries that work fine in Norwegian.

**Fix:** add explicit mappings + analyzers for the languages actually present, and align the
mapped set with `AuxLanguages`.

---

## 8. Deleted content is never removed from the index

```go
// backend/search/indexing.go:255
func (service *Service) DeleteModel(ctx context.Context, collection string, key string) error {
	if !lo.Contains(supportedCollections, collection) { // "shows" | "seasons" | "episodes"
		return nil
	}
	if index, ok := typeToIndexMap[collection]; ok {   // keys are "show" | "season" | "episode"
		_, err = service.elasticClient.Delete(index, collection+"-"+key).Do(ctx)
	}
	return err
}
```

`supportedCollections` is plural; `typeToIndexMap` is keyed singular. The lookup never
succeeds, so `Delete` is never called and the function returns `nil`. Every item deleted from
the CMS stays in the search index indefinitely, and will keep surfacing until the next full
reindex.

**Fix:** map plural collection → index explicitly, and add a test.

---

## 9. Unknown `type` silently searches every index in the cluster

`type` is an unvalidated `String` in the schema. `typeToIndexMap[*query.Type]` returns `""`
for anything outside `episode|season|show|any|""`, and `Index("")` resolves to all indices:

```
GET //_search  ->  hits from an unrelated index
```

**Fix:** make `type` a GraphQL enum, or fall back to `bccm-*` when the lookup misses.

---

## 10. Cross-index scoring is not comparable

The default `type: "any"` searches `bccm-*`. BM25 IDF is computed per shard, and shows,
seasons and episodes live in separate indices with wildly different document counts — a term
that is rare in `bccm-shows` and common in `bccm-episodes` scores very differently in each.
Mixed-type ranking is therefore skewed in a way that has nothing to do with relevance.

**Fix:** either send `search_type=dfs_query_then_fetch`, or merge the three into one index
with a `type` field (the filter work is already there).

---

## 11. Fields that are indexed but never searched

None of these are referenced anywhere in `backend/search/*.go` or
`main-elastic.json.tmpl`:

- `title_ngram`, `description_ngram`, `showTitle_ngram`, `seasonTitle_ngram`,
  `studyTopicTitle_ngram` and every per-field `.ngram` subfield
- the `complete` (completion suggester) subfield on all ten `title_*` fields — completion
  fields are held in JVM heap as FSTs
- `header`, `ageRating`

Separately, the `strings_as_keywords` dynamic template applies `copy_to: "{name}_ngram"` plus
an edge-ngram (`min_gram: 1`) subfield to **every** dynamically mapped string. Verified on a
freshly created index with two trivial documents:

```
objectID       -> text + .ngram + copy_to objectID_ngram
objectID_ngram -> text + .ngram + copy_to objectID_ngram_ngram
roles          -> text + .ngram + copy_to roles_ngram
roles_ngram    -> text + .ngram + copy_to roles_ngram_ngram
type_ngram     -> ...
```

In production this also covers `image` (a URL — edge-ngrammed from one character up) and all
unmapped `title_*`/`showTitle_*`/`seasonTitle_*` languages. Large amounts of index and heap
spent on fields no query touches.

`"_source": {"excludes": ["*_ngram"]}` is a no-op, since `copy_to` never writes to `_source`
in the first place.

**Fix:** drop the `ngram`/`complete` machinery (or start using it for autocomplete), and
restrict the dynamic template to `match: "*_ngram"`-free patterns — or set
`"dynamic": "strict"` and map fields explicitly.

---

## 12. `seasonTitle_*` is only reachable via the dead prefix clauses

Every `multi_match` covers `title_*`, `description_*`, `showTitle_*` and `tags`. `seasonTitle_*`
appears only in the `prefix` block, which per §4 almost never fires. Searching for a season's
name does not find its episodes.

Also note that `seasonTitle_es/pl/bg/sl` are the only `seasonTitle_*` fields in the mapping
without the `.ngram` subfield and `copy_to` — an inconsistency in the template.

---

## 13. Multi-word queries are pure OR

No `operator` or `minimum_should_match` on any `multi_match`, so `"det som endret alt"`
matches documents containing only `alt`:

```
multi_match "alt kaffe" over [title_no, description_no] -> 1 hit (matched only "alt")
```

Longer, more specific queries therefore get _noisier_, not more precise.

**Fix:** `"minimum_should_match": "2<75%"` on the non-fuzzy clauses, and add a
`match_phrase` clause with a high boost so exact phrases win.

---

## 14. `fuzziness: AUTO` on descriptions is aggressive

The boost-2 clause applies `AUTO` fuzziness to both `title_*` and `description_*`. `AUTO`
allows 2 edits for terms over 5 characters, so a 6-character query matches a large set of
unrelated description terms. Fuzziness on long free-text fields is usually a recall tool, not
a default.

**Fix:** keep `AUTO` on titles, use `fuzziness: 0` or `AUTO:4,8` on descriptions, and consider
`prefix_length: 1` to stop the first character from mutating.

---

## 15. Pagination arithmetic is wrong

```go
// backend/search/query.go
searchResult.Page      = int(math.Ceil(float64(templateParams.Offset) / float64(templateParams.Limit)))
searchResult.PageCount = int(qResult.Hits.Total.Value) / templateParams.Limit
```

- `Page` should be `floor`, not `ceil`: offset 15 / limit 10 reports page 2, not page 1.
- `PageCount` truncates: 11 hits at limit 10 reports 1 page instead of 2.
- `Hits.Total` is capped at 10 000 by default (`track_total_hits`), and `Hits.Total.Relation`
  (`"gte"`) is ignored, so `hits` silently plateaus at 10 000.
- `first` is passed straight to `size` with no cap; `from + size > 10000` is a hard
  Elasticsearch error.

---

## 16. Reindex takes search down and runs one document per HTTP request

`ReindexElastic` deletes **all three** indices up front (`resetElasticIndexes`), then refills
them sequentially, one `client.Index(...)` call per document (`indexing.go:206`), printing a
`.` for each. During the run, search returns partial or empty results.

**Fix:** index into a new index and flip an alias (`bccm-episodes` → `bccm-episodes-v2`) so the
old data stays searchable, and use the bulk API.

---

## 17. Nil dereference in the season result mapper

```go
// graph/api/search-resolver.go:66
ShowTitle: *i.Show,
```

`i.Show` is only set when `hit.ShowTitle.GetValueOrNil(languages)` returns non-nil.
`seasonToSearchItem` deliberately indexes a season with `showTitle = nil` when the show loader
yields `nil` (a hidden or deleted show), so such a document produces a nil `i.Show` and panics
the whole search request.

`gqlEpisodeFromSearchResultItem` has the same shape at line 83: it checks `i.ShowID != nil`
but dereferences `*i.SeasonID`. Currently safe only because `episodeToSearchItem` always sets
both together.

---

## 18. Test coverage gaps

- `backend/search/query_test.go` only runs with `-elastic` and a local server plus the
  encrypted fixture, so none of it runs in CI.
- `Test_EensureExistingGoodResults` never asserts its `expectedShows`:

  ```go
  for _, result := range res.Result {
      if len(test.expectedShows) >= expectedCount { break }   // 0 >= 0 on the first iteration
      ...
  }
  ```

  The loop exits immediately and `expectedCount` is never compared to anything. Every
  `expectedShows` expectation in that table is currently unchecked.

---

## Suggested order of work

1. §8 (deleted items linger) and §17 (panic) — correctness bugs with user-visible effects.
2. §1 + §2 + §3 — de-duplicate languages, switch to `minimum_should_match`, honour `minScore`.
   These three together make relevance tuning predictable; everything else is guesswork until
   they are done.
3. §4 + §13 — fix prefix matching and multi-word precision.
4. §5 + §6 + §7 — analyzer chain: synonym position, token explosion, missing languages.
   Requires a reindex, so batch them.
5. §11 + §16 — index size and reindex downtime.
6. §18 — make the relevance tests runnable in CI before changing boosts further.
