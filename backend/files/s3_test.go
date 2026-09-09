package files

import (
	"bytes"
	"io"
	"os"
	"strings"
	"testing"
	"testing/iotest"
)

func TestGetImageDimensions(t *testing.T) {
	// Use fixtures rather than importing encoders here: encoder imports would
	// register decoders and hide missing registrations in production code.
	for _, format := range []string{"jpeg", "png", "gif"} {
		t.Run(format, func(t *testing.T) {
			data, err := os.ReadFile("testdata/dimensions." + format)
			if err != nil {
				t.Fatal(err)
			}
			for _, chunked := range []bool{false, true} {
				var reader io.Reader = bytes.NewReader(data)
				if chunked {
					reader = iotest.OneByteReader(reader)
				}
				width, height, err := getImageDimensions(reader)
				if err != nil {
					t.Fatalf("chunked=%v: unexpected error: %v", chunked, err)
				}
				if width != 7 || height != 11 {
					t.Errorf("chunked=%v: dimensions = %dx%d, want 7x11", chunked, width, height)
				}
			}
		})
	}
}

func TestGetImageDimensionsInvalidInput(t *testing.T) {
	for _, tc := range []struct {
		name   string
		reader io.Reader
	}{
		{"empty", strings.NewReader("")},
		{"text", strings.NewReader("this is not an image")},
		{"truncated JPEG", bytes.NewReader([]byte{0xff, 0xd8, 0xff})},
		{"truncated PNG", strings.NewReader("\x89PNG\r\n\x1a\n")},
		{"truncated GIF", strings.NewReader("GIF89a")},
		{"reader error", iotest.ErrReader(io.ErrUnexpectedEOF)},
	} {
		t.Run(tc.name, func(t *testing.T) {
			width, height, err := getImageDimensions(tc.reader)
			if err == nil {
				t.Fatal("expected an error")
			}
			if width != 0 || height != 0 {
				t.Errorf("dimensions = %dx%d, want 0x0 on error", width, height)
			}
		})
	}
}
