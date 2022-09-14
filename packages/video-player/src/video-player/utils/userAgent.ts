
import UAParser from 'ua-parser-js';

const _ua = new UAParser().getResult();

/*

To simulate Samsung SmartTV, pass this in the constructor: 
Mozilla/5.0 (SMART-TV; Linux; Tizen 2.3) AppleWebkit/538.1 (KHTML, like Gecko) SamsungBrowser/1.0 TV Safari/538.1

*/

export const isSmartTV = () => {
    return _ua?.device.type === "smarttv";
}
