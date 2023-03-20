import Auth from "@/services/auth"
import { flutter } from "./flutter"

export async function getUserInfo(): Promise<{ given_name: string } | null> {
    const token = flutter
        ? await flutter!.getAccessToken()
        : await Auth.getToken()
    if (!token) {
        return null
    }
    try {

        let res = await fetch("https://login.bcc.no/userinfo", {
            headers: {
                Authorization: "Bearer " + token,
            },
        })
        let response = await res.json()
        return response
    } catch (e) {
        console.log(JSON.stringify(e));
        return null;
    }
}