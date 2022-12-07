



declare global {
    interface Window {
        flutter_inappwebview: FlutterWebView | undefined;
    }
}

export declare type FlutterWebView = {
    callHandler(...args);
};

export { }