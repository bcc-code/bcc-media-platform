package notifications

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"strconv"
)

// ResolveTargets resolves targetIDs to device tokens
func (u *Utils) ResolveTargets(ctx context.Context, targetIDs []uuid.UUID) ([]common.Device, error) {
	targets, err := u.queries.GetTargets(ctx, targetIDs)
	if err != nil {
		return nil, err
	}

	var devices []common.Device
	for _, t := range targets {
		switch t.Type {
		case "usergroups":
			if lo.Contains(t.Codes, user.RoleBCCMember) {
				devices = append(devices)
			}
			ds, err := u.getTokensForGroups(ctx, t.Codes)
			if err != nil {
				return nil, err
			}
			devices = append(devices, ds...)
		}
	}
	return devices, nil
}

func (u *Utils) getTokensForGroups(ctx context.Context, codes []string) ([]common.Device, error) {
	groups, err := u.queries.GetRolesWithCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	var personIDs []string
	for _, g := range groups {
		if everyone := g.Code == user.RoleRegistered; everyone || g.Code == user.RoleBCCMember {
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
	profiles, err := u.queries.GetProfilesForUserIDs(ctx, personIDs)
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
