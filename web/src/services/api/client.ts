import auth from "@/services/auth"

type ClientOptions = {
    getToken: () => Promise<string>
}

export class Client {
    private tokenFactory: () => Promise<string>

    constructor(options: ClientOptions) {
        this.tokenFactory = options.getToken
    }

    public getToken() {
        return this.tokenFactory()
    }
}

export default new Client({
    getToken: auth.getToken
})