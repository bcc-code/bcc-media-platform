package search

import (
	"bytes"
	"context"
	"encoding/json"
	"html/template"
	"strconv"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/samber/lo"
)

type obj = map[string]any

// AdminFilter narrows an admin search. Add new filters as optional fields with a clause in clauses().
type AdminFilter struct {
	// Group restricts results to what a member of this usergroup can see in the app.
	Group *string
	// Types are search types ("episode", "season", "show"). Empty means all.
	Types []string
}

type AdminHit struct {
	Collection string
	ID         int
	Score      *float64
}

type AdminSearchResult struct {
	Total int
	Hits  []AdminHit
}

type adminQueryParams struct {
	elasticQueryParams
	Filters template.HTML
}

func (f AdminFilter) clauses(now int64) []any {
	clauses := []any{}
	if f.Group != nil {
		clauses = append(clauses, visibilityClauses([]string{*f.Group}, now)...)
	}
	return clauses
}

func (f AdminFilter) indices() (string, error) {
	if len(f.Types) == 0 {
		return typeToIndexMap[""], nil
	}
	var indices []string
	for _, t := range lo.Uniq(f.Types) {
		index, ok := typeToIndexMap[t]
		if !ok || t == "" || t == "any" {
			return "", merry.Errorf("unknown search type: %s", t)
		}
		indices = append(indices, index)
	}
	return strings.Join(indices, ","), nil
}

// visibilityClauses mirrors the filters in main-elastic.json.tmpl.
func visibilityClauses(roles []string, now int64) []any {
	roleTerms := lo.Map(roles, func(r string, _ int) any {
		return obj{"term": obj{"roles.keyword": r}}
	})
	return []any{
		obj{"term": obj{"published": true}},
		obj{"bool": obj{"should": roleTerms, "minimum_should_match": 1}},
		obj{"bool": obj{"should": []any{
			obj{"term": obj{"availableFrom": 0}},
			obj{"range": obj{"availableFrom": obj{"lt": now}}},
		}, "minimum_should_match": 1}},
		obj{"bool": obj{"should": []any{
			obj{"term": obj{"availableTo": 0}},
			obj{"range": obj{"availableTo": obj{"gt": now}}},
		}, "minimum_should_match": 1}},
		obj{"bool": obj{"must_not": []any{
			obj{"range": obj{"publishedOn": obj{"gt": now}}},
		}}},
	}
}

func renderAdminQuery(query string, filter AdminFilter, limit, offset int, languages []string, now int64) ([]byte, error) {
	filters, err := json.Marshal(filter.clauses(now))
	if err != nil {
		return nil, err
	}

	query = strings.ReplaceAll(query, "'", "")
	params := adminQueryParams{
		elasticQueryParams: elasticQueryParams{
			QueryString:  template.HTML(template.JSEscapeString(query)),
			TimeNow:      now,
			Offset:       offset,
			Limit:        limit,
			Languages:    languages,
			AuxLanguages: []string{"no", "de", "en"},
		},
		Filters: template.HTML(filters),
	}

	buf := &bytes.Buffer{}
	err = templates.ExecuteTemplate(buf, "admin-elastic.json.tmpl", params)
	return buf.Bytes(), err
}

// AdminSearch returns ranked references only; callers load the entities themselves.
func (service *Service) AdminSearch(ctx context.Context, query string, filter AdminFilter, limit, offset int, languages []string) (AdminSearchResult, error) {
	index, err := filter.indices()
	if err != nil {
		return AdminSearchResult{}, err
	}

	jsonQuery, err := renderAdminQuery(query, filter, limit, offset, languages, time.Now().Unix())
	if err != nil {
		return AdminSearchResult{}, err
	}

	res, err := service.elasticClient.Search().Index(index).Raw(bytes.NewReader(jsonQuery)).Do(ctx)
	if err != nil {
		return AdminSearchResult{}, err
	}

	result := AdminSearchResult{
		Total: int(res.Hits.Total.Value),
		Hits:  []AdminHit{},
	}
	for _, h := range res.Hits.Hits {
		collection, rawID, ok := strings.Cut(*h.Id_, "-")
		if !ok {
			return result, merry.Errorf("unexpected search document id: %s", *h.Id_)
		}
		id, err := strconv.Atoi(rawID)
		if err != nil {
			return result, err
		}
		hit := AdminHit{Collection: collection, ID: id}
		if h.Score_ != nil {
			score := float64(*h.Score_)
			hit.Score = &score
		}
		result.Hits = append(result.Hits, hit)
	}
	return result, nil
}
