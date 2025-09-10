import { useAuth0 } from "@auth0/auth0-vue";

const COUNTRY_CODE_CLAIM = "https://login.bcc.no/claims/CountryIso2Code";
const CHURCH_ID_CLAIM = "https://login.bcc.no/claims/churchId";
export const PERSON_ID_CLAIM = "https://login.bcc.no/claims/personId";

export function useAuth() {
	const {
		idTokenClaims,
		loginWithRedirect,
		logout,
		user,
		isAuthenticated,
		getAccessTokenSilently
	} = useAuth0();

	const wasLoggedIn = ref<string | null>(null);

	function getClaims() {
		return {
			gender: idTokenClaims.value?.gender,
			birthDate: idTokenClaims.value?.birthdate,
			churchId: idTokenClaims.value?.[CHURCH_ID_CLAIM] as number,
			country: idTokenClaims.value?.[COUNTRY_CODE_CLAIM] as string,
			bccPersonId: idTokenClaims.value?.[PERSON_ID_CLAIM] as number,
		};
	}

	function authenticated() {
		if (isAuthenticated.value) {
			if ((wasLoggedIn.value ??= localStorage.getItem("wasLoggedIn")) !== "true") {
				localStorage.setItem("wasLoggedIn", "true");
			}
		}
		return isAuthenticated.value;
	}

	async function signIn(silent?: boolean) {
		await loginWithRedirect({
			appState: {
				target: window.location.pathname,
			},
			authorizationParams: {
				prompt: silent ? "none" : undefined,
			},
		});
	}


	async function signOut() {
		localStorage.clear();
		return await logout({
			logoutParams: {
				returnTo: window.location.origin,
			},
		});
	}

	function shouldSignIn() {
		if (isAuthenticated.value) {
			return false;
		}
		if (localStorage.getItem("wasLoggedIn") === "true") {
			const query = new URLSearchParams(location.search);
			if (query.get("error") === "login_required") {
				return true;
			} else {
				const triedLoggingIn = localStorage.getItem("triedLoggingIn");

				let shouldLogIn = true;

				if (triedLoggingIn) {
					const date = new Date(triedLoggingIn);
					const now = new Date();
					now.setSeconds(now.getSeconds() - 20);
					shouldLogIn = date.getTime() < now.getTime();
				}
				if (shouldLogIn) {
					localStorage.setItem("triedLoggingIn", new Date().toISOString());
					signIn(true);
				}
			}
		}
		return false;
	}

	function cancelSignIn() {
		localStorage.removeItem("wasLoggedIn");
		localStorage.removeItem("triedLoggingIn");
		location.replace("/");
	}

	async function getToken() {
		if (isAuthenticated.value) {
			try {
				return await getAccessTokenSilently();
			} catch {
				await loginWithRedirect();
			}
		}

		const query = new URLSearchParams(location.search);
		return query.get("access_token");
	}

	return {
		wasLoggedIn,
		user,
		getClaims,
		authenticated,
		signIn,
		signOut,
		shouldSignIn,
		cancelSignIn,
		getToken
	}
}