export type ApiClientOptions = {
    tokenFactory: (() => Promise<string | null>) | null
    endpoint: string
    application?: string
}

export class ApiClient {
    public endpoint: string
    public application?: string

    private _tokens: null | (() => Promise<string | null>)

    constructor({ tokenFactory, endpoint, application }: ApiClientOptions) {
        this._tokens = tokenFactory
        this.endpoint = endpoint
        this.application = application
    }

    public getToken() {
        return this._tokens?.() ?? null
    }

    public static get default() {
        if (!ApiClient._default) {
            throw new Error("Default instance not found")
        }
        return ApiClient._default
    }
    private static _default: ApiClient | null = null
}
