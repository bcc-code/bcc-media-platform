import type { CombinedError } from '@urql/vue'

export interface GraphQLErrorMessage {
  title: string
  description: string
}

const httpStatusMessages: Record<number, GraphQLErrorMessage> = {
  400: {
    title: 'Ugyldig forespørsel',
    description: 'Forespørselen kunne ikke behandles.'
  },
  401: {
    title: 'Sesjonen er utløpt',
    description: 'Logg inn på nytt for å fortsette.'
  },
  403: {
    title: 'Ingen tilgang',
    description: 'Du har ikke tilgang til dette innholdet.'
  },
  404: {
    title: 'Ikke funnet',
    description: 'Innholdet du leter etter finnes ikke.'
  },
  408: {
    title: 'Tidsavbrudd',
    description: 'Forespørselen tok for lang tid. Prøv igjen.'
  },
  429: {
    title: 'For mange forespørsler',
    description: 'Vent et øyeblikk og prøv igjen.'
  },
  500: {
    title: 'Serverfeil',
    description: 'Noe gikk galt på serveren. Prøv igjen senere.'
  },
  502: {
    title: 'Tjenesten er utilgjengelig',
    description: 'Kunne ikke nå serveren. Prøv igjen senere.'
  },
  503: {
    title: 'Tjenesten er utilgjengelig',
    description: 'Tjenesten er midlertidig nede. Prøv igjen senere.'
  },
  504: {
    title: 'Tidsavbrudd',
    description: 'Serveren svarte ikke i tide. Prøv igjen.'
  }
}

const networkFallback: GraphQLErrorMessage = {
  title: 'Tilkoblingsfeil',
  description: 'Kunne ikke koble til serveren. Sjekk internett-tilkoblingen din.'
}

const unknownFallback: GraphQLErrorMessage = {
  title: 'Noe gikk galt',
  description: 'En ukjent feil oppstod. Prøv igjen senere.'
}

export function formatGraphQLError(
  error: CombinedError | undefined | null
): GraphQLErrorMessage {
  if (!error) return unknownFallback

  const status = error.response?.status as number | undefined
  if (status && httpStatusMessages[status]) {
    return httpStatusMessages[status]
  }

  if (error.networkError) {
    return networkFallback
  }

  if (error.graphQLErrors.length > 0) {
    return {
      title: 'Noe gikk galt',
      description: error.graphQLErrors[0]!.message
    }
  }

  return unknownFallback
}
