// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: statistician.sql

package sqlc

import (
	"context"

	"github.com/google/uuid"
	"github.com/lib/pq"
	null_v4 "gopkg.in/guregu/null.v4"
)

const getAllMemberIDs = `-- name: GetAllMemberIDs :many
SELECT user_id FROM users.profiles GROUP BY user_id
`

func (q *Queries) GetAllMemberIDs(ctx context.Context) ([]string, error) {
	rows, err := q.db.QueryContext(ctx, getAllMemberIDs)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []string
	for rows.Next() {
		var user_id string
		if err := rows.Scan(&user_id); err != nil {
			return nil, err
		}
		items = append(items, user_id)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const getLessonProgressGroupedByOrg = `-- name: GetLessonProgressGroupedByOrg :many
WITH counts AS (SELECT m.org_id, count(*) as cnt FROM users.taskanswers a
         LEFT JOIN users.profiles p on p.id = a.profile_id
         LEFT JOIN stats.members_data m ON p.user_id = text(m.id)
         WHERE a.task_id  IN (
             SELECT DISTINCT  ON (l.id)  t.id FROM tasks t
                    LEFT JOIN lessons l ON t.lesson_id = l.id AND l.status = 'published'
                WHERE t.status = 'published' AND l.id = $3::uuid
                ORDER BY l.id, t.sort DESC)
         AND org_id IS NOT NULL
         AND m.age_group = ANY($4::text[])
group by m.org_id), totals as (
    SELECT org_id, SUM(count_persons) cnt
    FROM stats.org_counts
	WHERE age_group = ANY($4::text[])
    group by org_id
)
SELECT c.org_id, o.name, o.type, c.cnt as answers, t.cnt as totals, round(cast((c.cnt::float/t.cnt) as numeric), 2)::float as perc FROM counts c
LEFT JOIN totals t ON c.org_id = t.org_id
LEFT JOIN stats.orgs o ON o.id = t.org_id
WHERE t.cnt >= $1::int AND t.cnt <= $2::int
ORDER BY perc DESC
`

type GetLessonProgressGroupedByOrgParams struct {
	MinSize   int32     `db:"min_size" json:"minSize"`
	MaxSize   int32     `db:"max_size" json:"maxSize"`
	LessonID  uuid.UUID `db:"lesson_id" json:"lessonId"`
	AgeGroups []string  `db:"age_groups" json:"ageGroups"`
}

type GetLessonProgressGroupedByOrgRow struct {
	OrgID   null_v4.Int    `db:"org_id" json:"orgId"`
	Name    null_v4.String `db:"name" json:"name"`
	Type    null_v4.String `db:"type" json:"type"`
	Answers int64          `db:"answers" json:"answers"`
	Totals  null_v4.Int    `db:"totals" json:"totals"`
	Perc    float64        `db:"perc" json:"perc"`
}

// counts generates a count per orgid and age group
//
//	SUB Query: Get the last task of the lesson
//
// totals: Sum age groups for the orgs
// Main Query: Calculate the % of answers per org for the task
func (q *Queries) GetLessonProgressGroupedByOrg(ctx context.Context, arg GetLessonProgressGroupedByOrgParams) ([]GetLessonProgressGroupedByOrgRow, error) {
	rows, err := q.db.QueryContext(ctx, getLessonProgressGroupedByOrg,
		arg.MinSize,
		arg.MaxSize,
		arg.LessonID,
		pq.Array(arg.AgeGroups),
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetLessonProgressGroupedByOrgRow
	for rows.Next() {
		var i GetLessonProgressGroupedByOrgRow
		if err := rows.Scan(
			&i.OrgID,
			&i.Name,
			&i.Type,
			&i.Answers,
			&i.Totals,
			&i.Perc,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const insertMember = `-- name: InsertMember :exec
INSERT INTO stats.members_data (id, age_group, org_id) VALUES ($1, $2, $3)
ON CONFLICT ON CONSTRAINT members_data_pk DO UPDATE SET
	age_group = $2, org_id = $3
`

type InsertMemberParams struct {
	ID       int32  `db:"id" json:"id"`
	AgeGroup string `db:"age_group" json:"ageGroup"`
	Org      int32  `db:"org" json:"org"`
}

func (q *Queries) InsertMember(ctx context.Context, arg InsertMemberParams) error {
	_, err := q.db.ExecContext(ctx, insertMember, arg.ID, arg.AgeGroup, arg.Org)
	return err
}

const insertOrg = `-- name: InsertOrg :exec
INSERT INTO stats.orgs(id, type, name)
VALUES (
	$1, $2, $3
) ON CONFLICT ON CONSTRAINT orgs_pk DO UPDATE SET
	name = $3
`

type InsertOrgParams struct {
	OrgID int32  `db:"org_id" json:"orgId"`
	Type  string `db:"type" json:"type"`
	Name  string `db:"name" json:"name"`
}

func (q *Queries) InsertOrg(ctx context.Context, arg InsertOrgParams) error {
	_, err := q.db.ExecContext(ctx, insertOrg, arg.OrgID, arg.Type, arg.Name)
	return err
}

const insertOrgCounts = `-- name: InsertOrgCounts :exec
insert into stats.org_counts(org_id, count_persons, age_group)
values (
	$1, $2, $3
) ON CONFLICT ON CONSTRAINT org_counts_pk DO UPDATE SET
	count_persons = $2
`

type InsertOrgCountsParams struct {
	OrgID        int32  `db:"org_id" json:"orgId"`
	CountPersons int32  `db:"count_persons" json:"countPersons"`
	AgeGroup     string `db:"age_group" json:"ageGroup"`
}

func (q *Queries) InsertOrgCounts(ctx context.Context, arg InsertOrgCountsParams) error {
	_, err := q.db.ExecContext(ctx, insertOrgCounts, arg.OrgID, arg.CountPersons, arg.AgeGroup)
	return err
}
