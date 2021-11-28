package test

import (
  "testing"
  "github.com/stretchr/testify/assert"
)

func TestExample(t *testing.T) {
  t.Parallel()
  assert.Equal(t, "1", "1")
}
