package utils

import (
	"github.com/samber/lo/parallel"
	"github.com/stretchr/testify/assert"
	"strconv"
	"testing"
	"time"
)

func TestLock(t *testing.T) {
	lockKey := "lock"

	running := 0

	parallel.Times(10, func(index int) bool {
		lock := Lock(lockKey + strconv.Itoa(10%2))
		lock.Lock()

		running++
		time.Sleep(time.Millisecond * 10)
		assert.LessOrEqual(t, running, 2)
		running--
		lock.Unlock()

		return true
	})
}
