const fs = require('fs');
const https = require('https');
const { handler } = require('./index.js');

// Mock https.get to return our test manifest data
function mockHttpsGet(manifestData) {
    const originalGet = https.get;
    https.get = function(url, options, callback) {
        // Handle the case where options is the callback
        if (typeof options === 'function') {
            callback = options;
        }

        // Create a mock response object
        const mockResponse = {
            statusCode: 200,
            headers: { 'content-type': 'application/vnd.apple.mpegurl' },
            on: function(event, handler) {
                if (event === 'data') {
                    setTimeout(() => handler(manifestData), 0);
                } else if (event === 'end') {
                    setTimeout(handler, 0);
                }
                return this;
            }
        };

        setTimeout(() => callback(mockResponse), 0);
        return { on: () => {} }; // Mock request object
    };

    return () => { https.get = originalGet; }; // Return cleanup function
}

// Create a CloudFront event object
function createCloudFrontEvent(uri, querystring = '') {
    return {
        Records: [{
            cf: {
                request: {
                    uri: uri,
                    querystring: querystring
                }
            }
        }]
    };
}

async function testHandler(manifestData, querystring = '') {
    return new Promise((resolve, reject) => {
        const cleanup = mockHttpsGet(manifestData);

        try {
            const event = createCloudFrontEvent('/test/manifest.m3u8', querystring);
            const context = {};

            handler(event, context, (error, response) => {
                cleanup();

                if (error) {
                    reject(error);
                } else {
                    // Decompress the gzipped response body
                    const zlib = require('zlib');
                    const decompressed = zlib.gunzipSync(Buffer.from(response.body, 'base64')).toString();
                    resolve(decompressed);
                }
            });
        } catch (error) {
            cleanup();
            reject(error);
        }
    });
}

async function runTests() {
    console.log('Running audio-only manifest filtering tests using actual handler...');

    try {
        // Read test files
        const originalManifest = fs.readFileSync('./index.m3u8', 'utf8');
        const expectedManifest = fs.readFileSync('./index2.m3u8', 'utf8').trim();

        // Test 1: Normal processing (no audio-only filter)
        console.log('Running Test 1: Normal processing (no audio-only param)...');
        const normalResult = await testHandler(originalManifest, 'EncodedPolicy=test');

        // Verify that all video streams are preserved when audio-only is missing
        const normalLines = normalResult.trim().split('\n');
        const videoStreamCount = normalLines.filter(line =>
            line.includes('#EXT-X-STREAM-INF') && line.includes('avc1')).length;
        const originalVideoStreamCount = originalManifest.split('\n').filter(line =>
            line.includes('#EXT-X-STREAM-INF') && line.includes('avc1')).length;

        if (videoStreamCount === originalVideoStreamCount && videoStreamCount > 0) {
            console.log(`✓ Test 1: All ${videoStreamCount} video streams preserved when audio-only param is missing`);
        } else {
            console.log(`❌ Test 1: Expected ${originalVideoStreamCount} video streams, got ${videoStreamCount}`);
            throw new Error('Test 1 failed: Video streams not preserved');
        }

        // Test 2: Audio-only processing
        console.log('Running Test 2: Audio-only processing (audio-only=true)...');
        const audioOnlyResult = await testHandler(originalManifest, 'EncodedPolicy=test&audio-only=true');

        console.log('\n--- Expected Result ---');
        console.log(expectedManifest);

        console.log('\n--- Actual Result ---');
        console.log(audioOnlyResult.trim());

        // Compare results
        const expectedLines = expectedManifest.split('\n').filter(line => line.trim() !== '');
        const actualLines = audioOnlyResult.trim().split('\n').filter(line => line.trim() !== '');

        console.log('\n--- Comparison ---');
        console.log(`Expected lines: ${expectedLines.length}`);
        console.log(`Actual lines: ${actualLines.length}`);

        // Check if the key elements are present
        const hasAudioOnlyStream = actualLines.some(line =>
            line.includes('#EXT-X-STREAM-INF:BANDWIDTH=128000,CODECS="mp4a.40.2"'));
        const hasDefaultAudioUri = actualLines.some(line =>
            line.includes('audio_nor.m3u8'));
        const hasAllAudioTracks = expectedLines.filter(line =>
            line.includes('#EXT-X-MEDIA:TYPE=AUDIO')).length ===
            actualLines.filter(line => line.includes('#EXT-X-MEDIA:TYPE=AUDIO')).length;

        console.log(`Audio-only stream present: ${hasAudioOnlyStream}`);
        console.log(`Default audio URI present: ${hasDefaultAudioUri}`);
        console.log(`All audio tracks preserved: ${hasAllAudioTracks}`);

        if (hasAudioOnlyStream && hasDefaultAudioUri && hasAllAudioTracks) {
            console.log('\n✓ Test 2: Audio-only filtering works correctly!');
        } else {
            console.log('\n❌ Test 2: Audio-only filtering needs adjustment');

            // Show detailed comparison
            console.log('\n--- Line by Line Comparison ---');
            const maxLines = Math.max(expectedLines.length, actualLines.length);
            for (let i = 0; i < maxLines; i++) {
                const expected = expectedLines[i] || '<missing>';
                const actual = actualLines[i] || '<missing>';
                const match = expected === actual ? '✓' : '✗';
                console.log(`${match} ${i + 1}: Expected: ${expected}`);
                if (expected !== actual) {
                    console.log(`     Actual:   ${actual}`);
                }
            }
            throw new Error('Test 2 failed: Audio-only filtering not working');
        }

        // Test 3: Explicit audio-only=false processing
        console.log('Running Test 3: Explicit audio-only=false processing...');
        const audioOnlyFalseResult = await testHandler(originalManifest, 'EncodedPolicy=test&audio-only=false');

        // Verify that all video streams are preserved when audio-only=false
        const falseLines = audioOnlyFalseResult.trim().split('\n');
        const falseVideoStreamCount = falseLines.filter(line =>
            line.includes('#EXT-X-STREAM-INF') && line.includes('avc1')).length;

        if (falseVideoStreamCount === originalVideoStreamCount && falseVideoStreamCount > 0) {
            console.log(`✓ Test 3: All ${falseVideoStreamCount} video streams preserved when audio-only=false`);
        } else {
            console.log(`❌ Test 3: Expected ${originalVideoStreamCount} video streams, got ${falseVideoStreamCount}`);
            throw new Error('Test 3 failed: Video streams not preserved when audio-only=false');
        }

        console.log('\n🎉 All tests passed!');

    } catch (error) {
        console.error('Test failed with error:', error.message);
        console.error(error.stack);
        process.exit(1);
    }
}

// Run the tests
runTests();
