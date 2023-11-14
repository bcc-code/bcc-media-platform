
'use strict';
let _bootTimestamp = Date.now();
const https = require('https');
const keepAliveAgent = new https.Agent({ keepAlive: true });
const path = require('path');
const qsParser = require('querystring');
let _isFirstRequest = true;
const { readFileSync } = require('fs');

const config = JSON.parse(readFileSync('./config.json'));

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
            data.split("\n").forEach((elem) => {
                if (elem.startsWith("#EXT-X-I-FRAME-STREAM-INF")) {
                    // Debug. Remove I-Frame playlists
                    return;
                }
                if (elem.startsWith("#")) {
                    if (elem.indexOf("URI") != -1) { //URI component inline
                        var uriComponents = elem.substring(elem.indexOf("URI")).split("\"");
                        uriComponents[1] = signed(dir, uriComponents[1], request);
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
                    body.push(signed(dir, elem, request));
                }
            });

            response.body = body.join('\n')
            let bodyModificationTime = Date.now() - bodyModificationStart
            response.headers["x-ag-stats"] = [
                {
                    key: 'x-ag-stats',
                    value: JSON.stringify({
                        timeSinceBoot,
                        isFirstRequest,
                        fetchTime,
                        bodyReadTime,
                        bodyModificationTime
                    })
                }
            ];
            response.headers["X-Manifest-Cache"] = [
                {
                    key: 'X-Manifest-Cache',
                    value: resp.headers["x-cache"]
                }
            ];

            response.headers["X-AG-Debug"] = [
                {
                    key: 'X-AG-Debug',
                    value: request.querystring
                }
            ];

            console.log({
                timeSinceBoot,
                isFirstRequest,
                fetchTime,
                bodyReadTime,
                bodyModificationTime
            })

            /*response.headers["Content-Encoding"] = [{
                    key: 'Content-Encoding',
                    value: 'gzip'
            }];*/
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


function signed(dir, file, request) {
    let fileWithoutQuery = file
    let originalQueryString = ''
    //console.log(file)
    if (file.indexOf('?') !== -1) {
        originalQueryString = file.substring(file.indexOf("?"))
        fileWithoutQuery = file.substring(0, file.indexOf("?"))
    }

    let parsedQs = qsParser.parse(request.querystring);
    let policy = parsedQs["EncodedPolicy"];

    if (fileWithoutQuery.endsWith(".m3u8")) {
        if (originalQueryString === '') {
            return file + '?' + request.querystring
        } else {
            return file + '&' + request.querystring
        }
    }

    if (originalQueryString === '') {
        return file + '?' + policy
    } else {
        return file + '&' + policy
    }
}
