package graph

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"github.com/vektah/gqlparser/v2/gqlerror"
	"gopkg.in/guregu/null.v4"
)

const (
	maxUserHeaderLen    = 256
	maxAuditErrorLen    = 1000
	maxAuditLogPageSize = 200
)

func truncate(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return string(r[:n])
}

func errUserHeaderRequired(ctx context.Context) *gqlerror.Error {
	return &gqlerror.Error{
		Path:    graphql.GetPath(ctx),
		Message: "the x-user header is required for this call",
		Extensions: map[string]interface{}{
			"code": "USER_HEADER_REQUIRED",
		},
	}
}

// AuditDirective implements @audit. API key calls must name the user in x-user; rejected calls are still recorded.
// A failed insert is logged but does not fail the call.
func (r *Resolver) AuditDirective(ctx context.Context, _ any, next graphql.Resolver) (any, error) {
	p := principalFromCtx(ctx)

	var res any
	var err error
	if p != nil && p.authMethod == model.AuditAuthMethodAPIKey && p.userHeader == "" {
		err = errUserHeaderRequired(ctx)
	} else {
		res, err = next(ctx)
	}

	fc := graphql.GetFieldContext(ctx)
	entry, buildErr := auditEntry(p, auditAction(fc), fc.Args, err)
	if buildErr != nil {
		log.L.Error().Err(buildErr).Str("action", entry.Action).Msg("Admin audit entry could not be built")
	}
	if insertErr := r.Queries.InsertAdminAuditLog(context.WithoutCancel(ctx), entry); insertErr != nil {
		log.L.Error().Err(insertErr).Str("action", entry.Action).Msg("Admin audit entry could not be saved")
	}
	return res, err
}

// auditAction is the field path by field name (not alias), e.g. access.createApiKey.
func auditAction(fc *graphql.FieldContext) string {
	var names []string
	for ; fc != nil; fc = fc.Parent {
		if fc.Field.Field != nil {
			names = append(names, fc.Field.Name)
		}
	}
	return strings.Join(lo.Reverse(names), ".")
}

func auditEntry(p *Principal, action string, args map[string]any, callErr error) (sqlc.InsertAdminAuditLogParams, error) {
	entry := sqlc.InsertAdminAuditLogParams{
		Action:    action,
		Arguments: json.RawMessage("{}"),
		Success:   callErr == nil,
	}
	if callErr != nil {
		entry.Error = null.StringFrom(truncate(callErr.Error(), maxAuditErrorLen))
	}
	if p != nil {
		entry.AuthMethod = string(p.authMethod)
		entry.UserID = p.userID
		entry.UserEmail = null.NewString(p.email, p.email != "")
		entry.ApiKeyID = p.apiKeyID
		entry.ApiKeyName = null.NewString(p.apiKeyName, p.apiKeyName != "")
		entry.UserHeader = null.NewString(p.userHeader, p.userHeader != "")
	}

	var err error
	if len(args) > 0 {
		var raw []byte
		if raw, err = json.Marshal(args); err == nil {
			entry.Arguments = raw
		}
	}
	return entry, err
}

func auditLogEntryToModel(e sqlc.UsersAdminAuditLog) *model.AuditLogEntry {
	out := &model.AuditLogEntry{
		ID:         fmt.Sprint(e.ID),
		CreatedAt:  e.CreatedAt.Format(time.RFC3339),
		Action:     e.Action,
		Arguments:  string(e.Arguments),
		AuthMethod: model.AuditAuthMethod(e.AuthMethod),
		UserEmail:  e.UserEmail.Ptr(),
		APIKeyName: e.ApiKeyName.Ptr(),
		UserHeader: e.UserHeader.Ptr(),
		Success:    e.Success,
		Error:      e.Error.Ptr(),
	}
	if e.UserID.Valid {
		out.UserID = lo.ToPtr(e.UserID.UUID.String())
	}
	if e.ApiKeyID.Valid {
		out.APIKeyID = lo.ToPtr(e.ApiKeyID.UUID.String())
	}
	return out
}

func parseOptionalUUID(raw *string) (uuid.NullUUID, error) {
	if raw == nil || *raw == "" {
		return uuid.NullUUID{}, nil
	}
	id, err := uuid.Parse(*raw)
	if err != nil {
		return uuid.NullUUID{}, fmt.Errorf("invalid id: %w", err)
	}
	return uuid.NullUUID{UUID: id, Valid: true}, nil
}

func (r *Resolver) listAuditLog(ctx context.Context, first, offset *int, filter *model.AuditLogFilter) (*model.AuditLogResult, error) {
	limit := min(max(lo.FromPtrOr(first, 50), 0), maxAuditLogPageSize)
	off := max(lo.FromPtrOr(offset, 0), 0)

	var action null.String
	var apiKeyID, userID uuid.NullUUID
	if filter != nil {
		if filter.Action != nil && *filter.Action != "" {
			action = null.StringFrom(*filter.Action)
		}
		var err error
		if apiKeyID, err = parseOptionalUUID(filter.APIKeyID); err != nil {
			return nil, err
		}
		if userID, err = parseOptionalUUID(filter.UserID); err != nil {
			return nil, err
		}
	}

	total, err := r.Queries.CountAdminAuditLog(ctx, sqlc.CountAdminAuditLogParams{Action: action, ApiKeyID: apiKeyID, UserID: userID})
	if err != nil {
		return nil, err
	}
	rows, err := r.Queries.ListAdminAuditLog(ctx, sqlc.ListAdminAuditLogParams{
		Action:   action,
		ApiKeyID: apiKeyID,
		UserID:   userID,
		Lim:      int32(limit),
		Off:      int32(off),
	})
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}
	return &model.AuditLogResult{
		Total: int(total),
		Items: lo.Map(rows, func(e sqlc.UsersAdminAuditLog, _ int) *model.AuditLogEntry { return auditLogEntryToModel(e) }),
	}, nil
}
