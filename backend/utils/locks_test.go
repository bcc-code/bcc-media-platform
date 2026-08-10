package utils

import (
	"strconv"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func heldLockCount() int {
	locksMu.Lock()
	defer locksMu.Unlock()
	return len(locks)
}

func TestLockExcludesConcurrentHoldersOfTheSameKey(t *testing.T) {
	var concurrent, maxConcurrent atomic.Int32

	var wg sync.WaitGroup
	for range 10 {
		wg.Add(1)
		go func() {
			defer wg.Done()

			unlock := Lock("same-key")
			defer unlock()

			n := concurrent.Add(1)
			for {
				m := maxConcurrent.Load()
				if n <= m || maxConcurrent.CompareAndSwap(m, n) {
					break
				}
			}
			time.Sleep(time.Millisecond)
			concurrent.Add(-1)
		}()
	}
	wg.Wait()

	assert.Equal(t, int32(1), maxConcurrent.Load(), "more than one goroutine held the same key at once")
}

func TestLockDoesNotSerialiseDistinctKeys(t *testing.T) {
	const n = 8
	var wg sync.WaitGroup
	release := make(chan struct{})

	// Every goroutine takes a different key and holds it until released. If
	// distinct keys blocked each other this would deadlock rather than finish.
	for i := range n {
		wg.Add(1)
		go func() {
			defer wg.Done()
			unlock := Lock("distinct-" + strconv.Itoa(i))
			defer unlock()
			<-release
		}()
	}

	assert.Eventually(t, func() bool { return heldLockCount() >= n }, time.Second, time.Millisecond,
		"distinct keys did not acquire concurrently")
	close(release)
	wg.Wait()
}

// The table used to only ever grow: keys include per-user values, so a process
// accumulated one mutex for every distinct key it had ever seen.
func TestLockReleasesEntriesWhenNoLongerHeld(t *testing.T) {
	before := heldLockCount()

	var wg sync.WaitGroup
	for i := range 100 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			unlock := Lock("transient-" + strconv.Itoa(i))
			unlock()
		}()
	}
	wg.Wait()

	assert.Equal(t, before, heldLockCount(), "lock table grew after every lock was released")
}

func TestUnlockIsIdempotent(t *testing.T) {
	unlock := Lock("idempotent")
	unlock()
	assert.NotPanics(t, unlock, "a second unlock should be a no-op, not a double-unlock panic")
}
