import { generateUUID } from "@/utils/uuid"

export function useSessionId() {
	let id = sessionStorage.getItem('sessionId')

	if (!id) {
		const newId = generateUUID()
		sessionStorage.setItem('sessionId', newId)
		id = newId
	}

	return id
}