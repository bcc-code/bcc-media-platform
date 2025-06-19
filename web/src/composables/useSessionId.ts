import { getSessionId } from 'rudder-sdk-js'
import { generateUUID } from "@/utils/uuid"

export function useSessionId() {
	const sessionId = getSessionId()?.toString()
	if (sessionId) return sessionId;

	let id = sessionStorage.getItem('sessionId')

	if (!id) {
		const newId = generateUUID()
		sessionStorage.setItem('sessionId', newId)
		id = newId
	}

	return id
}