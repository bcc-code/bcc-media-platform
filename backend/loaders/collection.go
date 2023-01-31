package loaders

import (
	"context"
	"log"
	"sync"
	"time"
)

// Collection is a collection of loaders or other advanced structures
type Collection[K comparable, V any] struct {
	values  *sync.Map
	expiry  time.Duration
	janitor *janitor
}

// NewCollection of loaders or other structures
func NewCollection[K comparable, V any](expiration time.Duration) *Collection[K, V] {
	col := &Collection[K, V]{
		values:  &sync.Map{},
		expiry:  expiration,
		janitor: newJanitor(context.Background(), time.Minute),
	}

	col.janitor.run(col.DeleteExpired)

	return col
}

type entry[K comparable, V any] struct {
	Key       K
	Value     V
	ExpiresAt time.Time
	OnDelete  func()
}

// Keys returns all keys
func (c Collection[K, V]) Keys() []K {
	var keys []K
	c.values.Range(func(key any, value any) bool {
		k, _ := key.(K)
		keys = append(keys, k)
		return true
	})
	return keys
}

// Set a key to specified value
func (c Collection[K, V]) Set(key K, value V, opts ...any) {
	e := &entry[K, V]{
		Key:       key,
		Value:     value,
		ExpiresAt: time.Now().Add(c.expiry),
	}
	for _, opt := range opts {
		switch v := opt.(type) {
		case onDelete:
			e.OnDelete = v
		}
	}
	c.values.Store(key, e)
}

// Get a value by the specified key
func (c Collection[K, V]) Get(key K) (value V, ok bool) {
	v, ok := c.values.Load(key)
	if !ok {
		return value, false
	}
	e, _ := v.(*entry[K, V])
	if e.ExpiresAt.Before(time.Now()) {
		c.values.Delete(key)
		if e.OnDelete != nil {
			e.OnDelete()
		}
		return value, false
	}
	e.ExpiresAt = time.Now().Add(c.expiry)
	return e.Value, true
}

// Delete the specified key (&entry)
func (c Collection[K, V]) Delete(key K) {
	v, ok := c.values.LoadAndDelete(key)
	if !ok {
		return
	}
	e, _ := v.(*entry[K, V])
	c.values.Delete(key)
	if e.OnDelete != nil {
		e.OnDelete()
	}
}

// DeleteExpired entries
func (c Collection[K, V]) DeleteExpired() {
	log.Print("Deleting expired entries from cache")
	var deleteKeys []K
	c.values.Range(func(key any, value any) bool {
		e, _ := value.(*entry[K, V])
		if e.ExpiresAt.Before(time.Now()) {
			deleteKeys = append(deleteKeys, e.Key)
		}
		return true
	})
	for _, k := range deleteKeys {
		c.Delete(k)
	}
}

type onDelete func()

// WithOnDelete tells the collection to run this function when entry is deleted
func WithOnDelete(cb func()) any {
	return onDelete(cb)
}
