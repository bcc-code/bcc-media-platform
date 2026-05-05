package main

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

func TestCleanPlaylist_BareURIWithQuery(t *testing.T) {
	in := "#EXTM3U\n#EXT-X-VERSION:3\nseg-0001.ts?Policy=abc&Signature=xyz\n"
	want := "#EXTM3U\n#EXT-X-VERSION:3\nseg-0001.ts?" + Placeholder + "\n"
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_BareURIWithoutQuery(t *testing.T) {
	in := "#EXTM3U\nseg-0001.ts\nseg-0002.ts\n"
	want := "#EXTM3U\nseg-0001.ts?" + Placeholder + "\nseg-0002.ts?" + Placeholder + "\n"
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_URIAttributeWithQuery(t *testing.T) {
	in := `#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud",NAME="en",URI="audio/en.m3u8?Signature=abc"
`
	want := `#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud",NAME="en",URI="audio/en.m3u8?` + Placeholder + `"
`
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_URIAttributeWithoutQuery(t *testing.T) {
	in := `#EXT-X-MAP:URI="init.mp4"
`
	want := `#EXT-X-MAP:URI="init.mp4?` + Placeholder + `"
`
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_AbsoluteURI(t *testing.T) {
	in := "#EXTM3U\nhttps://cdn.example.com/path/seg.ts?EncodedPolicy=foo\n"
	want := "#EXTM3U\nhttps://cdn.example.com/path/seg.ts?" + Placeholder + "\n"
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_PreservesNonURILines(t *testing.T) {
	in := "#EXTM3U\n#EXT-X-VERSION:3\n#EXTINF:6.0,\n\nseg.ts\n"
	got := string(cleanPlaylist([]byte(in)))
	if !strings.Contains(got, "#EXTM3U\n") {
		t.Errorf("expected #EXTM3U preserved, got:\n%s", got)
	}
	if !strings.Contains(got, "#EXT-X-VERSION:3\n") {
		t.Errorf("expected #EXT-X-VERSION preserved, got:\n%s", got)
	}
	if !strings.Contains(got, "#EXTINF:6.0,\n") {
		t.Errorf("expected #EXTINF preserved, got:\n%s", got)
	}
	if !strings.Contains(got, "\n\n") {
		t.Errorf("expected blank line preserved, got:\n%s", got)
	}
	if !strings.Contains(got, "seg.ts?"+Placeholder+"\n") {
		t.Errorf("expected seg.ts annotated, got:\n%s", got)
	}
}

func TestCleanPlaylist_CRLF(t *testing.T) {
	in := "#EXTM3U\r\nseg.ts?Policy=x\r\n"
	want := "#EXTM3U\r\nseg.ts?" + Placeholder + "\r\n"
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_Idempotent(t *testing.T) {
	in := "#EXTM3U\nseg.ts?Policy=x\n#EXT-X-MAP:URI=\"init.mp4\"\n"
	once := cleanPlaylist([]byte(in))
	twice := cleanPlaylist(once)
	if string(once) != string(twice) {
		t.Fatalf("not idempotent\nfirst:\n%s\nsecond:\n%s", once, twice)
	}
}

func TestCleanPlaylist_MultipleURIAttributes(t *testing.T) {
	in := `#EXT-X-KEY:METHOD=AES-128,URI="key.bin",IV=0x1234
`
	want := `#EXT-X-KEY:METHOD=AES-128,URI="key.bin?` + Placeholder + `",IV=0x1234
`
	got := string(cleanPlaylist([]byte(in)))
	if got != want {
		t.Fatalf("got:\n%q\nwant:\n%q", got, want)
	}
}

func TestCleanPlaylist_Replacement(t *testing.T) {
	cleaned := cleanPlaylist([]byte("#EXTM3U\nseg.ts?Policy=x\n"))
	final := strings.ReplaceAll(string(cleaned), Placeholder, "jwt=THE.TOKEN")
	want := "#EXTM3U\nseg.ts?jwt=THE.TOKEN\n"
	if final != want {
		t.Fatalf("got:\n%q\nwant:\n%q", final, want)
	}
}

// TestCleanPlaylist_RealMaster uses a real master playlist captured from
// cdn-test.bcc.media (multi-CDN Fastly-style FS-Policy / FS-Signature /
// FS-Key-Id query strings). Verifies that every signed query is stripped, the
// placeholder is in place, and a final substitution produces a coherent body.
func TestCleanPlaylist_RealMaster(t *testing.T) {
	in, err := os.ReadFile(filepath.Join("testdata", "master_input.m3u8"))
	if err != nil {
		t.Fatalf("read fixture: %v", err)
	}

	cleaned := cleanPlaylist(in)
	got := string(cleaned)

	for _, fragment := range []string{"FS-Policy=", "FS-Signature=", "FS-Key-Id="} {
		if strings.Contains(got, fragment) {
			t.Errorf("expected %q to be stripped from cleaned output", fragment)
		}
	}

	// Every URI in the master should reference one of the variant playlists.
	uriRefs := regexp.MustCompile(`index_\d+(?:_0)?\.m3u8`).FindAllString(string(in), -1)
	if len(uriRefs) == 0 {
		t.Fatal("no URIs found in fixture; fixture is broken")
	}
	placeholderCount := strings.Count(got, "?"+Placeholder)
	if placeholderCount != len(uriRefs) {
		t.Errorf("got %d placeholders, expected one per URI (%d)", placeholderCount, len(uriRefs))
	}

	// Spot-check: each variant URI should be followed by ?__PROXY_AUTH__.
	for _, ref := range uriRefs {
		if !strings.Contains(got, ref+"?"+Placeholder) {
			t.Errorf("expected %q to be followed by placeholder", ref)
		}
	}

	// Round-trip with master-playlist substitution (jwt=...).
	subbed := strings.ReplaceAll(got, Placeholder, "jwt=THE.TOKEN")
	for _, ref := range uriRefs {
		if !strings.Contains(subbed, ref+"?jwt=THE.TOKEN") {
			t.Errorf("expected %q to be followed by jwt=THE.TOKEN after substitution", ref)
		}
	}

	// And confirm structural HLS tags survive.
	for _, tag := range []string{"#EXTM3U", "#EXT-X-VERSION:6", "#EXT-X-INDEPENDENT-SEGMENTS", "#EXT-X-STREAM-INF", "#EXT-X-I-FRAME-STREAM-INF", "#EXT-X-MEDIA"} {
		if !strings.Contains(got, tag) {
			t.Errorf("expected tag %q preserved", tag)
		}
	}
}
