export type ApiClientOptions = {
    tokenFactory: (() => Promise<string | null>) | null
    endpoint: string
    application?: string
    headersFactory?: () =>
        | Record<string, string>
        | Promise<Record<string, string>>
}

export class ApiClient {
    public endpoint: string
    public application?: string

    private _tokens: null | (() => Promise<string | null>)
    private _headers?: () =>
        | Record<string, string>
        | Promise<Record<string, string>>

    constructor({
        tokenFactory,
        endpoint,
        application,
        headersFactory,
    }: ApiClientOptions) {
        this._tokens = tokenFactory
        this.endpoint = endpoint
        this.application = application
        this._headers = headersFactory
    }

    public getToken() {
        return this._tokens?.() ?? null
    }

    public async getHeaders(): Promise<Record<string, string>> {
        return (await this._headers?.()) ?? {}
    }

    public static get default() {
        if (!ApiClient._default) {
            throw new Error("Default instance not found")
        }
        return ApiClient._default
    }
    private static _default: ApiClient | null = null
}
