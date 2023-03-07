// -------------------------------------
// Copied from author allisson:
// https://github.com/allisson/go-pglock
// -------------------------------------

package database

import (
	"context"
	"database/sql"
)

// Locker simple interface for reusing the lock elsewhere
type Locker interface {
	Lock(ctx context.Context) (bool, error)
	WaitAndLock(ctx context.Context) error
	Unlock(ctx context.Context) error
	Close() error
}

// Lock implements the Locker interface.
type Lock struct {
	id   int
	conn *sql.Conn
}

// Lock obtains exclusive session level advisory lock if available.
// It’s similar to WaitAndLock, except it will not wait for the lock to become available.
// It will either obtain the lock and return true, or return false if the lock cannot be acquired immediately.
func (l *Lock) Lock(ctx context.Context) (bool, error) {
	result := false
	sqlQuery := "SELECT pg_try_advisory_lock($1)"
	err := l.conn.QueryRowContext(ctx, sqlQuery, l.id).Scan(&result)
	return result, err
}

// WaitAndLock obtains exclusive session level advisory lock.
// If another session already holds a lock on the same resource identifier, this function will wait until the resource becomes available.
// Multiple lock requests stack, so that if the resource is locked three times it must then be unlocked three times.
func (l *Lock) WaitAndLock(ctx context.Context) error {
	sqlQuery := "SELECT pg_advisory_lock($1)"
	_, err := l.conn.ExecContext(ctx, sqlQuery, l.id)
	return err
}

// Unlock releases the lock.
func (l *Lock) Unlock(ctx context.Context) error {
	sqlQuery := "SELECT pg_advisory_unlock($1)"
	_, err := l.conn.ExecContext(ctx, sqlQuery, l.id)
	return err
}

// Close closes the DB connection, consequently releasing all locks.
func (l *Lock) Close() error {
	return l.conn.Close()
}
