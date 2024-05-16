const { handler } = require('../lambda-js/index'); // Path to your Lambda function file
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
    /* 
        it('should handle gzip errors', (done) => {
            const error = new Error('gzip error');
            zlib.gzip = jest.fn((data, cb) => cb(error));
    
            handler(event, context, callback);
    
            setImmediate(() => {
                expect(callback).toHaveBeenCalledWith(error);
                done();
            });
        }); */
});