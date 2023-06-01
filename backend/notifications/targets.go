package notifications

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

// ResolveTargets resolves targetIDs to device tokens
func (u *Utils) ResolveTargets(ctx context.Context, targetIDs []uuid.UUID) ([]common.Device, error) {
	log.L.Debug().Int("targetCount", len(targetIDs)).Msg("Resolving targets")
	targets, err := u.queries.GetTargets(ctx, targetIDs)
	if err != nil {
		return nil, err
	}

	var devices []common.Device
	for _, t := range targets {
		switch t.Type {
		case "usergroups":
			ds, err := u.getTokensForGroups(ctx, t.Codes)
			if err != nil {
				return nil, err
			}
			log.L.Debug().Int("deviceCount", len(ds)).Msg("Resolved target, retrieved devices")
			devices = append(devices, ds...)
		}
	}
	return devices, nil
}

func (u *Utils) getTokensForGroups(ctx context.Context, codes []string) ([]common.Device, error) {
	apps, err := u.queries.ListApplications(ctx)
	if err != nil {
		return nil, err
	}
	defaultApp, _ := lo.Find(apps, func(i common.Application) bool {
		return i.Default
	})
	groups, err := u.queries.GetRolesWithCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	var personIDs []string
	for _, g := range groups {
		if everyone := g.Code == user.RoleRegistered; everyone || g.Code == user.RoleBCCMember {
			log.L.Debug().Bool("everyone", everyone).Msg("Retrieving members for notification targets")
			ids, err := u.queries.GetMemberIDs(ctx, everyone)
			if err != nil {
				return nil, err
			}
			personIDs = append(personIDs, ids...)
		}
		// In case someone has been explicitly been granted the bcc-members role
		if len(g.Emails) == 0 {
			continue
		}
		users, err := u.members.RetrieveByEmails(ctx, g.Emails)
		if err != nil {
			return nil, err
		}
		if users != nil {
			for _, u := range *users {
				personIDs = append(personIDs, strconv.Itoa(u.PersonID))
			}
		}
	}
	personIDs = lo.Uniq(personIDs)
	profiles, err := u.queries.ApplicationQueries(defaultApp.GroupID).GetProfilesForUserIDs(ctx, personIDs)
	if err != nil {
		return nil, err
	}
	devices, err := u.queries.GetDevices(ctx, lo.Map(profiles, func(i common.Profile, _ int) uuid.UUID {
		return i.ID
	}))
	if err != nil {
		return nil, err
	}
	return devices, nil
}
