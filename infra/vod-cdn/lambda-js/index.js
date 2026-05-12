
'use strict';
let _bootTimestamp = Date.now();
const https = require('https');
const keepAliveAgent = new https.Agent({ keepAlive: true });
const path = require('path');
const qsParser = require('querystring');
let _isFirstRequest = true;
const { readFileSync } = require('fs');
const zlib = require('zlib');

const configPath = process.env.CONFIG_PATH || './config.json';
const config = JSON.parse(readFileSync(configPath));

/**
 * This lambda is expected to be used as a origin request handler with cloudfront.
 *
 * It requires that you pass in a "EncodedPolicy" query parameter.
 * Example: "?EncodedPolicy=Policy%3d...%26Signature%3d...%26Key-Pair-Id%3d...".
 * For child manifests, the EncodedPolicy will just be appended as-is,
 * but for any other urls (e.g. .mp4 files), the policy will be decoded and appended.
 */

exports.handler = (event, context, callback) => {
    let isFirstRequest = _isFirstRequest
    _isFirstRequest = false

    if (isFirstRequest) {
        console.log("is first request")
    }

    let timeSinceBoot = Date.now() - _bootTimestamp

    const request = event.Records[0].cf.request;
    const manifestDomain = config.MANIFEST_DOMAIN;

    let parsedQs = qsParser.parse(request.querystring);
    let isAudioOnly = parsedQs["audio-only"] === "true";

    // EncodedPolicy is the wrapped CloudFront signing triple this Lambda
    // re-emits onto every rewritten URI. When it's missing we have nothing
    // to inject, so the upstream manifest is forwarded unmodified rather
    // than rewritten with literal "undefined" in every URI.
    const encodedPolicy = parsedQs["EncodedPolicy"];
    const forwardAsIs = typeof encodedPolicy !== "string" || encodedPolicy === "";
    if (forwardAsIs) {
        console.log("missing EncodedPolicy on request, forwarding manifest as-is", request.uri);
    }

    //find dir for the m3u8
    let dir = path.dirname(request.uri);

    let querystring = (request.querystring) ? "?" + request.querystring : "";
    let beforeRequestTime = Date.now()

    https.get("https://" + manifestDomain + request.uri + querystring, { agent: keepAliveAgent }, (resp) => {
        let response = {}
        let fetchTime = Date.now() - beforeRequestTime;

        //use same status code
        response.status = resp.statusCode;

        //respond with a few headers
        response.headers = {
            "access-control-allow-origin": [{ "key": "Access-Control-Allow-Origin", "value": "*" }],
            "content-type": [{ "key": "Content-Type", "value": resp.headers["content-type"] || "text/html" }],
            "server": [{ "key": "Server", "value": resp.headers["server"] || "Server" }],
            "cache-control": [{ key: 'Cache-Control', value: "no-store, max-age=0" }],

        };

        //load response to <data>
        let data = "";
        let bodyReadStart = Date.now()
        resp.on('data', (chunk) => {
            data += chunk;
        });

        //create signed URL only for lines without initial #, or URI component
        let body = [];

        resp.on('end', () => {

            let bodyReadTime = Date.now() - bodyReadStart
            let bodyModificationStart = Date.now()

            let bodyString;
            if (forwardAsIs) {
                bodyString = data;
            } else {
                // Check if this is a main manifest (contains #EXT-X-STREAM-INF)
                let isMainManifest = data.includes("#EXT-X-STREAM-INF");
                let skipNextLine = false;

                data.split("\n").forEach((elem) => {
                    if (skipNextLine) {
                        skipNextLine = false;
                        return;
                    }

                    if (elem.startsWith("#EXT-X-I-FRAME-STREAM-INF")) {
                        // Debug. Remove I-Frame playlists
                        return;
                    }

                    // Audio-only filtering for main manifest only
                    if (isAudioOnly && isMainManifest && elem.startsWith("#EXT-X-STREAM-INF")) {
                        // Skip all video streams and replace with a single audio-only stream
                        skipNextLine = true;

                        // Add a single audio-only stream (only for the first video stream encountered)
                        if (!body.some(line => line.includes('CODECS="mp4a.40.2"') && !line.includes('avc1'))) {
                            body.push('#EXT-X-STREAM-INF:BANDWIDTH=128000,CODECS="mp4a.40.2",AUDIO="audio_0"');
                            // Find the default audio track URI from EXT-X-MEDIA entries
                            let defaultAudioUri = '';
                            data.split("\n").forEach(line => {
                                if (line.includes('#EXT-X-MEDIA:TYPE=AUDIO') && line.includes('DEFAULT=YES')) {
                                    let uriMatch = line.match(/URI="([^"]+)"/);
                                    if (uriMatch) {
                                        defaultAudioUri = uriMatch[1];
                                    }
                                }
                            });
                            body.push(signed(dir, defaultAudioUri || '', encodedPolicy));
                        }
                        return;
                    }

                    if (elem.startsWith("#")) {
                        if (elem.indexOf("URI") != -1) { //URI component inline
                            var uriComponents = elem.substring(elem.indexOf("URI")).split("\"");
                            uriComponents[1] = signed(dir, uriComponents[1], encodedPolicy);
                            body.push(elem.substring(0, elem.indexOf("URI")) + uriComponents.join("\""));
                        }
                        else {
                            body.push(elem);
                        }
                    }
                    else if (elem == "") {
                        body.push(elem);
                    }
                    else {
                        body.push(signed(dir, elem, encodedPolicy));
                    }
                });

                bodyString = body.join('\n');
            }
            console.log("gzipping body")
            let gzipStart = Date.now()
            response.body = zlib.gzipSync(bodyString).toString('base64')
            response.bodyEncoding = 'base64';
            let gzipTime = Date.now() - gzipStart


            response.headers["Content-Encoding"] = [{
                key: 'Content-Encoding',
                value: 'gzip'
            }];

            let bodyModificationTime = Date.now() - bodyModificationStart
            response.headers["x-ag-stats"] = [
                {
                    key: 'x-ag-stats',
                    value: JSON.stringify({
                        timeSinceBoot,
                        isFirstRequest,
                        fetchTime,
                        bodyReadTime,
                        bodyModificationTime,
                        gzipTime
                    })
                }
            ];
            response.headers["X-Manifest-Cache"] = [
                {
                    key: 'X-Manifest-Cache',
                    value: resp.headers["x-cache"]
                }
            ];
            console.log({
                timeSinceBoot,
                isFirstRequest,
                fetchTime,
                bodyReadTime,
                bodyModificationTime,
                gzipTime
            })
            callback(null, response);
        });
    }).on('error', (err) => {
        console.log(err)
        callback(
            null,
            {
                'status': '500',
                'statusDescrition': 'Server Error',
                'headers': {
                    'content-type': [{ 'key': 'Content-Type', 'value': 'text/plain' }]
                },
                'body': 'Error reading content \n\n' + err
            }
        );
    });

}

// Signing parameters the various CDN signers emit. Stripped from URIs in the
// upstream manifest before this Lambda appends its own auth — otherwise the
// rewritten URL carries both stale and fresh signing keys, which different CDN
// parsers resolve inconsistently and can produce 403s.
const STRIPPABLE_SIGNATURE_KEYS = new Set([
    "Policy", "Signature", "Key-Pair-Id",   // CloudFront
    "EncodedPolicy",                         // wrapped CloudFront (this repo)
    "FS-Policy", "FS-Signature", "FS-Key-Id" // Fastly
]);

function stripSignatureParams(queryString) {
    if (!queryString) return "";
    const parsed = qsParser.parse(queryString);
    for (const key of Object.keys(parsed)) {
        if (STRIPPABLE_SIGNATURE_KEYS.has(key) || key.startsWith("AK-Signature")) {
            delete parsed[key];
        }
    }
    return qsParser.stringify(parsed);
}

function signed(dir, file, encodedPolicy) {
    let fileWithoutQuery = file;
    let originalQuery = "";
    const qIdx = file.indexOf("?");
    if (qIdx !== -1) {
        originalQuery = file.substring(qIdx + 1);
        fileWithoutQuery = file.substring(0, qIdx);
    }

    const cleanedQuery = stripSignatureParams(originalQuery);

    let authFragment;
    if (fileWithoutQuery.endsWith(".m3u8")) {
        // Child manifests keep the wrapped form so the next origin-request
        // hits this Lambda again and can decode it.
        authFragment = "EncodedPolicy=" + encodeURIComponent(encodedPolicy);
    } else {
        // Media URIs get the unwrapped CF triple (Policy=…&Signature=…&Key-Pair-Id=…),
        // which is already in well-formed query-string shape inside EncodedPolicy.
        authFragment = encodedPolicy;
    }

    const finalQuery = cleanedQuery
        ? cleanedQuery + "&" + authFragment
        : authFragment;
    return fileWithoutQuery + "?" + finalQuery;
}

exports.stripSignatureParams = stripSignatureParams;
exports.signed = signed;
