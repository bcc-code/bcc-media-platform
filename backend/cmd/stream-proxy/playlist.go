package main

import (
	"strings"
)

// Placeholder is the literal string written into a cleaned playlist where the
// authentication query string used to be (or where it needs to be inserted on
// URI lines that had no existing query). The serving handler runs
// strings.ReplaceAll on the cached body, swapping this for either
// "jwt=<token>" or "EncodedPolicy=<policy>".
const Placeholder = "__PROXY_AUTH__"

// cleanPlaylist takes a raw .m3u8 body and returns a body where every URI has
// any existing query string replaced with `?__PROXY_AUTH__`, and every URI
// without a query string has `?__PROXY_AUTH__` appended.
//
// The cached form is JWT-independent: the same path always produces the same
// cleaned body regardless of which token requested it.
func cleanPlaylist(body []byte) []byte {
	stripped := stripQueries(body)
	return appendPlaceholders(stripped)
}

// stripQueries is a single linear byte scan that replaces every existing query
// string with `?__PROXY_AUTH__`. It does not differentiate between bare-line
// URIs and URI="..." attribute values: the terminator set (newline, carriage
// return, double quote) covers both contexts.
func stripQueries(body []byte) []byte {
	var b strings.Builder
	b.Grow(len(body))
	for i := 0; i < len(body); i++ {
		c := body[i]
		if c == '?' {
			b.WriteByte('?')
			b.WriteString(Placeholder)
			for i+1 < len(body) {
				next := body[i+1]
				if next == '\n' || next == '\r' || next == '"' {
					break
				}
				i++
			}
			continue
		}
		b.WriteByte(c)
	}
	return []byte(b.String())
}

// appendPlaceholders walks the body line-by-line and ensures every URI has the
// placeholder query string. After stripQueries, any URI that already had a
// query is now `<path>?__PROXY_AUTH__`; this pass takes care of the URIs that
// had no query at all.
//
// Targets:
//   - Bare-line URIs (lines not starting with '#' and non-blank).
//   - URI="..." attribute values inside tag lines (lines starting with '#').
//
// If a URI already contains `?__PROXY_AUTH__`, it is left alone.
func appendPlaceholders(body []byte) []byte {
	var out strings.Builder
	out.Grow(len(body) + 64)

	lines := strings.SplitAfter(string(body), "\n")
	for _, line := range lines {
		out.WriteString(processLine(line))
	}
	return []byte(out.String())
}

func processLine(line string) string {
	// Strip the trailing newline (may also have a CR) so we can manipulate the
	// content, and re-attach it at the end.
	core := line
	suffix := ""
	if strings.HasSuffix(core, "\r\n") {
		core, suffix = core[:len(core)-2], "\r\n"
	} else if strings.HasSuffix(core, "\n") {
		core, suffix = core[:len(core)-1], "\n"
	}

	if core == "" {
		return line
	}

	if strings.HasPrefix(core, "#") {
		return appendInsideURIAttr(core) + suffix
	}

	// Bare URI line.
	if strings.Contains(core, "?"+Placeholder) {
		return line
	}
	return core + "?" + Placeholder + suffix
}

// absolutizeURIs prepends `base` to every relative URI in the body. URIs that
// already start with http:// or https:// are left alone. `base` should end
// with `/`. This is used when serving variant playlists so segment URLs in
// the response point at the CDN instead of resolving against the proxy host.
func absolutizeURIs(body []byte, base string) []byte {
	var out strings.Builder
	out.Grow(len(body) + 128)
	for _, line := range strings.SplitAfter(string(body), "\n") {
		out.WriteString(absolutizeLine(line, base))
	}
	return []byte(out.String())
}

func absolutizeLine(line, base string) string {
	core := line
	suffix := ""
	if strings.HasSuffix(core, "\r\n") {
		core, suffix = core[:len(core)-2], "\r\n"
	} else if strings.HasSuffix(core, "\n") {
		core, suffix = core[:len(core)-1], "\n"
	}

	if core == "" {
		return line
	}

	if strings.HasPrefix(core, "#") {
		return absolutizeInsideURIAttr(core, base) + suffix
	}

	if isAbsoluteURI(core) {
		return line
	}
	return base + core + suffix
}

func absolutizeInsideURIAttr(line, base string) string {
	const marker = `URI="`
	var b strings.Builder
	i := 0
	for i < len(line) {
		idx := strings.Index(line[i:], marker)
		if idx < 0 {
			b.WriteString(line[i:])
			break
		}
		b.WriteString(line[i : i+idx+len(marker)])
		valueStart := i + idx + len(marker)
		end := strings.IndexByte(line[valueStart:], '"')
		if end < 0 {
			b.WriteString(line[valueStart:])
			break
		}
		value := line[valueStart : valueStart+end]
		if !isAbsoluteURI(value) {
			b.WriteString(base)
		}
		b.WriteString(value)
		b.WriteByte('"')
		i = valueStart + end + 1
	}
	return b.String()
}

func isAbsoluteURI(s string) bool {
	return strings.HasPrefix(s, "https://") || strings.HasPrefix(s, "http://")
}

// appendInsideURIAttr rewrites every URI="..." in a tag line so the inner
// value carries the placeholder. Other tag attributes are left alone.
func appendInsideURIAttr(line string) string {
	const marker = `URI="`
	var b strings.Builder
	i := 0
	for i < len(line) {
		idx := strings.Index(line[i:], marker)
		if idx < 0 {
			b.WriteString(line[i:])
			break
		}
		b.WriteString(line[i : i+idx+len(marker)])
		valueStart := i + idx + len(marker)
		end := strings.IndexByte(line[valueStart:], '"')
		if end < 0 {
			// Malformed tag — leave the rest as-is.
			b.WriteString(line[valueStart:])
			break
		}
		value := line[valueStart : valueStart+end]
		if strings.Contains(value, "?"+Placeholder) {
			b.WriteString(value)
		} else {
			b.WriteString(value)
			b.WriteString("?")
			b.WriteString(Placeholder)
		}
		b.WriteByte('"')
		i = valueStart + end + 1
	}
	return b.String()
}
