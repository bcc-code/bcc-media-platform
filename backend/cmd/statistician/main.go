package main

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/sony/gobreaker"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/rs/zerolog"
	"github.com/samber/lo"
)

func chunkBy[T any](items []T, chunkSize int) [][]T {
	var _chunks = make([][]T, 0, (len(items)/chunkSize)+1)
	for chunkSize < len(items) {
		items, _chunks = items[chunkSize:], append(_chunks, items[0:chunkSize:chunkSize])
	}
	return append(_chunks, items)
}

type ageRange struct {
	Min       int
	Max       int
	GroupName string
}

func (a ageRange) Name() string {
	if len(a.GroupName) > 0 {
		return a.GroupName
	}

	return fmt.Sprintf("%d - %d", a.Min, a.Max)
}

func main() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	ctx := context.Background()
	config := getEnvConfig()
	db := mustConnectToDB(ctx, config.DB)

	queries := sqlc.New(db)

	authClient := auth0.New(config.Auth0)
	breaker := gobreaker.NewCircuitBreaker(gobreaker.Settings{
		Name: "Members",
	})
	membersClient := members.New(config.Members, authClient, breaker)

	//updateMemberData(ctx, *queries, *membersClient, db)
	//updateMemeberCountByAgeGroup(ctx, queries, membersClient, db)
	updateOrganization(ctx, queries, membersClient)
}

func updateMemeberCountByAgeGroup(ctx context.Context, queries *sqlc.Queries, membersClient *members.Client, db *sql.DB) {
	ageRanges := []ageRange{
		{Min: 0, Max: 9},
		{Min: 10, Max: 12},
		{Min: 13, Max: 18},
		{Min: 19, Max: 25},
		{Min: 26, Max: 36},
		{Min: 37, Max: 50},
		{Min: 51, Max: 64},
		{Min: 65, Max: 200, GroupName: "65+"},
	}

	for _, ar := range ageRanges {
		data, _ := membersClient.CountMembersByAgeGroupedByOrg(ctx, ar.Min, ar.Max)
		tx, err := db.Begin()
		defer tx.Rollback()

		if err != nil {
			log.L.Panic().Err(err).Msg("Members failed")
		}
		queriesTx := queries.WithTx(tx)

		for churchId, count := range data {
			err := queriesTx.InsertOrgCounts(ctx, sqlc.InsertOrgCountsParams{
				CountPersons: int32(count),
				OrgID:        int32(churchId),
				AgeGroup:     ar.Name(),
			})
			if err != nil {
				log.L.Panic().Err(err).Msg("Query failed")
			}
			fmt.Printf("A: %s O: %d C: %d\n", ar.Name(), churchId, count)
		}

		tx.Commit()
	}

}

func updateOrganization(ctx context.Context, queries *sqlc.Queries, membersClient *members.Client) {
	orgs, err := membersClient.GetOrgs(ctx, 0, 0)
	if err != nil {
		log.L.Panic().Err(err).Msg("Members failed")
	}

	for _, org := range orgs {
		err := queries.InsertOrg(ctx, sqlc.InsertOrgParams{
			OrgID: int32(org.OrgID),
			Name:  org.Name,
			Type:  org.Type,
		})
		if err != nil {
			log.L.Panic().Err(err).Msg("Query failed")
		}
		print(",")
	}
}

func updateMemberData(ctx context.Context, queries sqlc.Queries, membersClient members.Client, db *sql.DB) {
	memberIDs, err := queries.GetAllMemberIDs(ctx)
	if err != nil {
		log.L.Panic().Err(err).Msg("Query failed")
	}

	intMemberIDs := utils.MapWith(memberIDs, utils.AsInt)

	membersList, err := membersClient.RetrieveByIDs(ctx, intMemberIDs)
	if err != nil {
		log.L.Panic().Err(err).Msg("Members failed")
	}

	tx, err := db.Begin()
	if err != nil {
		log.L.Panic().Err(err).Msg("Members failed")
	}
	queriesTx := queries.WithTx(tx)

	for _, m := range membersList {

		church := lo.Filter(m.Affiliations, func(af members.Affiliation, _ int) bool {
			return af.OrgType == "Church" && af.Active
		})

		churchId := -1
		if len(church) > 0 {
			churchId = church[0].OrgID
		}

		ageGrpupMin := 0
		ageGroup := "unknown"

		// TODO: Generalize this in a function!!!!
		for minAge, group := range user.AgeGroups {
			// Note: Maps are not iterated in a sorted order so we have to find the lowed applicable
			if m.Age >= minAge && minAge > ageGrpupMin {
				ageGroup = group
				ageGrpupMin = minAge
			}
		}

		err := queriesTx.InsertMember(ctx, sqlc.InsertMemberParams{
			ID:       int32(m.PersonID),
			AgeGroup: ageGroup,
			Org:      int32(churchId),
		})
		if err != nil {
			log.L.Panic().Err(err).Msg("Members failed")
		}
		print(".")
	}
	println("#")
	err = tx.Commit()
	if err != nil {
		log.L.Panic().Err(err).Msg("Members failed")
	}
	println("!")
}
