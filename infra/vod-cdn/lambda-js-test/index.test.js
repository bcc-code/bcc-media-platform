const { handler, signed, stripSignatureParams } = require('../lambda-js/index'); // Path to your Lambda function file
const zlib = require('zlib');

const config = require('./config.json');

describe('Lambda@Edge function', () => {
    let event;
    let context;
    let callback;

    beforeEach(() => {
        event = {
            Records: [
                {
                    cf: {
                        request: {
                            uri: config.TEST_URI,
                            querystring: config.TEST_QUERY,
                        },
                    },
                },
            ],
        };
        context = {};
        callback = jest.fn();
    });

    it('should call the callback with the correct response', (done) => {

        handler(event, context, (_, v) => {
            console.log('callback called with ', v);
            // decompress
            try {
                const body = Buffer.from(v.body, 'base64');
                console.log('body: ', body);
                const decompressed = zlib.gunzipSync(body).toString('utf8');
                console.log('decompressed body: ', decompressed);
                callback(null, v)
                expect(decompressed).toContain("URI");
                expect(decompressed).toContain("#EXTINF:5.760");
                expect(callback).toHaveBeenCalledWith(null, expect.objectContaining({
                    status: expect.any(Number),
                    headers: expect.objectContaining({
                        "access-control-allow-origin": expect.arrayContaining([{ "key": "Access-Control-Allow-Origin", "value": "*" }]),
                        "content-type": expect.arrayContaining([{ "key": "Content-Type", "value": expect.any(String) }]),
                        "server": expect.arrayContaining([{ "key": "Server", "value": expect.any(String) }]),
                        "cache-control": expect.arrayContaining([{ key: 'Cache-Control', value: "no-store, max-age=0" }]),
                    }),
                    body: expect.any(String),
                }));
            } catch (e) {
                // fail test
                console.error('error: ', e);
                expect(true).toBe(false);
            }
            done();
        });
    });
});

describe('stripSignatureParams', () => {
    it('strips CloudFront signing params and preserves non-signing params', () => {
        const out = stripSignatureParams("Policy=a&Signature=b&Key-Pair-Id=c&m=42");
        expect(out).toBe("m=42");
    });

    it('strips Fastly signing params', () => {
        const out = stripSignatureParams("FS-Policy=a&FS-Signature=b&FS-Key-Id=c&audio-only=true");
        expect(out).toBe("audio-only=true");
    });

    it('strips Akamai AK-Signature-* params by prefix', () => {
        const out = stripSignatureParams("AK-Signature-V1=a&AK-Signature-V2=b&keep=1");
        expect(out).toBe("keep=1");
    });

    it('strips a stale EncodedPolicy', () => {
        const out = stripSignatureParams("EncodedPolicy=stale&aws.manifestfilter=v");
        expect(out).toBe("aws.manifestfilter=v");
    });

    it('returns empty string for empty input', () => {
        expect(stripSignatureParams("")).toBe("");
        expect(stripSignatureParams(undefined)).toBe("");
    });

    it('returns empty string when input is all signatures', () => {
        const out = stripSignatureParams("Policy=a&Signature=b&Key-Pair-Id=c");
        expect(out).toBe("");
    });
});

describe('signed', () => {
    // encodedPolicy is the already-decoded value of the request's EncodedPolicy
    // query parameter — i.e. the unwrapped CF triple as a query-string fragment.
    const encodedPolicy = "Policy=FRESH-POLICY&Signature=FRESH-SIG&Key-Pair-Id=FRESH-KEY";

    it('replaces stale CloudFront signing params on a media URI with the fresh triple', () => {
        const out = signed("/some/dir", "seg-0001.ts?Policy=STALE&Signature=STALE&Key-Pair-Id=STALE&m=42", encodedPolicy);
        // Non-signing param preserved.
        expect(out).toContain("m=42");
        // Fresh values present, stale absent.
        expect(out).toContain("Policy=FRESH-POLICY");
        expect(out).toContain("Signature=FRESH-SIG");
        expect(out).toContain("Key-Pair-Id=FRESH-KEY");
        expect(out).not.toContain("STALE");
        // No duplicate keys.
        expect(out.match(/(^|[?&])Policy=/g).length).toBe(1);
        expect(out.match(/(^|[?&])Signature=/g).length).toBe(1);
        expect(out.match(/(^|[?&])Key-Pair-Id=/g).length).toBe(1);
    });

    it('strips Fastly signing residue on a media URI', () => {
        const out = signed("/some/dir", "seg.ts?FS-Policy=x&FS-Signature=y&FS-Key-Id=z", encodedPolicy);
        expect(out).not.toContain("FS-Policy");
        expect(out).not.toContain("FS-Signature");
        expect(out).not.toContain("FS-Key-Id");
        expect(out).toContain("Policy=FRESH-POLICY");
    });

    it('keeps the wrapped EncodedPolicy form on .m3u8 children and replaces a stale one', () => {
        const out = signed("/some/dir", "variant.m3u8?EncodedPolicy=STALE&m=7", encodedPolicy);
        expect(out).toContain("m=7");
        // Exactly one EncodedPolicy, and it carries the fresh wrapped value.
        expect(out.match(/(^|[?&])EncodedPolicy=/g).length).toBe(1);
        expect(out).toContain("EncodedPolicy=" + encodeURIComponent(encodedPolicy));
        // Unwrapped CF triple must NOT leak onto the .m3u8 URI.
        expect(out).not.toContain("Policy=FRESH-POLICY&Signature=FRESH-SIG");
        expect(out).not.toContain("STALE");
    });

    it('handles a URI with no pre-existing query string', () => {
        const out = signed("/some/dir", "seg.ts", encodedPolicy);
        expect(out).toBe("seg.ts?" + encodedPolicy);
    });
});


