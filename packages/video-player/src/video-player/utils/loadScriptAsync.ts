/*
* Copied from https://github.com/AnteWall/react-cast-sender/
*/

export function loadScriptAsync(url: string): Promise<any> {
    return new Promise((resolve, reject) => {
        let r = false,
            t = document.getElementsByTagName('script')[0],
            s = document.createElement('script');
        s.type = 'text/javascript';
        s.src = url;
        s.async = true;
        //@ts-ignore
        s.onload = s.onreadystatechange = function () {
            //@ts-ignore
            if (!r && (!this.readyState || this.readyState === 'complete')) {
                r = true;
                resolve(this);
            }
        };
        s.onerror = s.onabort = reject;
        if (t && t.parentNode) {
            t.parentNode.insertBefore(s, t);
        }
    });
}
