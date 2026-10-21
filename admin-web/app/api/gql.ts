/* eslint-disable */
import * as types from './graphql';
import type { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';

/**
 * Map of all GraphQL operations in the project.
 *
 * This map has several performance disadvantages:
 * 1. It is not tree-shakeable, so it will include all operations in the project.
 * 2. It is not minifiable, so the string of a GraphQL query will be multiple times inside the bundle.
 * 3. It does not support dead code elimination, so it will add unused operations.
 *
 * Therefore it is highly recommended to use the babel or swc plugin for production.
 * Learn more about it here: https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#reducing-bundle-size
 */
type Documents = {
    "\n  fragment PermissionFields on Permission {\n    resource\n    level\n    scope {\n      search {\n        group\n        types\n      }\n      episodeAccess {\n        groups\n      }\n    }\n  }\n": typeof types.PermissionFieldsFragmentDoc,
    "\n  fragment ApiKeyFields on ApiKey {\n    id\n    name\n    prefix\n    createdAt\n    expiresAt\n    revokedAt\n    permissions {\n      ...PermissionFields\n    }\n  }\n": typeof types.ApiKeyFieldsFragmentDoc,
    "\n  query GetApiKeys {\n    access {\n      apiKeys {\n        ...ApiKeyFields\n      }\n    }\n  }\n": typeof types.GetApiKeysDocument,
    "\n  query GetRoles {\n    access {\n      roles {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n": typeof types.GetRolesDocument,
    "\n  mutation CreateApiKey($input: ApiKeyInput!) {\n    access {\n      createApiKey(input: $input) {\n        key\n        apiKey {\n          ...ApiKeyFields\n        }\n      }\n    }\n  }\n": typeof types.CreateApiKeyDocument,
    "\n  mutation UpdateApiKey($id: ID!, $input: ApiKeyInput!) {\n    access {\n      updateApiKey(id: $id, input: $input) {\n        ...ApiKeyFields\n      }\n    }\n  }\n": typeof types.UpdateApiKeyDocument,
    "\n  mutation RevokeApiKey($id: ID!) {\n    access {\n      revokeApiKey(id: $id)\n    }\n  }\n": typeof types.RevokeApiKeyDocument,
    "\n  mutation SetRolePermissions($roleId: ID!, $permissions: [PermissionInput!]!) {\n    access {\n      setRolePermissions(roleId: $roleId, permissions: $permissions) {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n": typeof types.SetRolePermissionsDocument,
    "\n  query GetEpisodeAccessGroups {\n    episodeAccess {\n      groups {\n        code\n        name\n      }\n    }\n  }\n": typeof types.GetEpisodeAccessGroupsDocument,
    "\n  fragment AuditLogEntryFields on AuditLogEntry {\n    id\n    createdAt\n    action\n    arguments\n    authMethod\n    userId\n    userEmail\n    apiKeyId\n    apiKeyName\n    userHeader\n    success\n    error\n  }\n": typeof types.AuditLogEntryFieldsFragmentDoc,
    "\n  query GetAuditLog($first: Int, $offset: Int, $filter: AuditLogFilter) {\n    access {\n      auditLog(first: $first, offset: $offset, filter: $filter) {\n        total\n        items {\n          ...AuditLogEntryFields\n        }\n      }\n    }\n  }\n": typeof types.GetAuditLogDocument,
    "\n  query GetAuditLogActions {\n    access {\n      auditLogActions\n    }\n  }\n": typeof types.GetAuditLogActionsDocument,
    "\n  query GetEpisodes($filter: String!) {\n    preview {\n      collection(filter: $filter) {\n        items {\n          id\n          title\n          collection\n        }\n      }\n    }\n  }\n": typeof types.GetEpisodesDocument,
};
const documents: Documents = {
    "\n  fragment PermissionFields on Permission {\n    resource\n    level\n    scope {\n      search {\n        group\n        types\n      }\n      episodeAccess {\n        groups\n      }\n    }\n  }\n": types.PermissionFieldsFragmentDoc,
    "\n  fragment ApiKeyFields on ApiKey {\n    id\n    name\n    prefix\n    createdAt\n    expiresAt\n    revokedAt\n    permissions {\n      ...PermissionFields\n    }\n  }\n": types.ApiKeyFieldsFragmentDoc,
    "\n  query GetApiKeys {\n    access {\n      apiKeys {\n        ...ApiKeyFields\n      }\n    }\n  }\n": types.GetApiKeysDocument,
    "\n  query GetRoles {\n    access {\n      roles {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n": types.GetRolesDocument,
    "\n  mutation CreateApiKey($input: ApiKeyInput!) {\n    access {\n      createApiKey(input: $input) {\n        key\n        apiKey {\n          ...ApiKeyFields\n        }\n      }\n    }\n  }\n": types.CreateApiKeyDocument,
    "\n  mutation UpdateApiKey($id: ID!, $input: ApiKeyInput!) {\n    access {\n      updateApiKey(id: $id, input: $input) {\n        ...ApiKeyFields\n      }\n    }\n  }\n": types.UpdateApiKeyDocument,
    "\n  mutation RevokeApiKey($id: ID!) {\n    access {\n      revokeApiKey(id: $id)\n    }\n  }\n": types.RevokeApiKeyDocument,
    "\n  mutation SetRolePermissions($roleId: ID!, $permissions: [PermissionInput!]!) {\n    access {\n      setRolePermissions(roleId: $roleId, permissions: $permissions) {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n": types.SetRolePermissionsDocument,
    "\n  query GetEpisodeAccessGroups {\n    episodeAccess {\n      groups {\n        code\n        name\n      }\n    }\n  }\n": types.GetEpisodeAccessGroupsDocument,
    "\n  fragment AuditLogEntryFields on AuditLogEntry {\n    id\n    createdAt\n    action\n    arguments\n    authMethod\n    userId\n    userEmail\n    apiKeyId\n    apiKeyName\n    userHeader\n    success\n    error\n  }\n": types.AuditLogEntryFieldsFragmentDoc,
    "\n  query GetAuditLog($first: Int, $offset: Int, $filter: AuditLogFilter) {\n    access {\n      auditLog(first: $first, offset: $offset, filter: $filter) {\n        total\n        items {\n          ...AuditLogEntryFields\n        }\n      }\n    }\n  }\n": types.GetAuditLogDocument,
    "\n  query GetAuditLogActions {\n    access {\n      auditLogActions\n    }\n  }\n": types.GetAuditLogActionsDocument,
    "\n  query GetEpisodes($filter: String!) {\n    preview {\n      collection(filter: $filter) {\n        items {\n          id\n          title\n          collection\n        }\n      }\n    }\n  }\n": types.GetEpisodesDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 *
 *
 * @example
 * ```ts
 * const query = graphql(`query GetUser($id: ID!) { user(id: $id) { name } }`);
 * ```
 *
 * The query argument is unknown!
 * Please regenerate the types.
 */
export function graphql(source: string): unknown;

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  fragment PermissionFields on Permission {\n    resource\n    level\n    scope {\n      search {\n        group\n        types\n      }\n      episodeAccess {\n        groups\n      }\n    }\n  }\n"): (typeof documents)["\n  fragment PermissionFields on Permission {\n    resource\n    level\n    scope {\n      search {\n        group\n        types\n      }\n      episodeAccess {\n        groups\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  fragment ApiKeyFields on ApiKey {\n    id\n    name\n    prefix\n    createdAt\n    expiresAt\n    revokedAt\n    permissions {\n      ...PermissionFields\n    }\n  }\n"): (typeof documents)["\n  fragment ApiKeyFields on ApiKey {\n    id\n    name\n    prefix\n    createdAt\n    expiresAt\n    revokedAt\n    permissions {\n      ...PermissionFields\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetApiKeys {\n    access {\n      apiKeys {\n        ...ApiKeyFields\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetApiKeys {\n    access {\n      apiKeys {\n        ...ApiKeyFields\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetRoles {\n    access {\n      roles {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetRoles {\n    access {\n      roles {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation CreateApiKey($input: ApiKeyInput!) {\n    access {\n      createApiKey(input: $input) {\n        key\n        apiKey {\n          ...ApiKeyFields\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation CreateApiKey($input: ApiKeyInput!) {\n    access {\n      createApiKey(input: $input) {\n        key\n        apiKey {\n          ...ApiKeyFields\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation UpdateApiKey($id: ID!, $input: ApiKeyInput!) {\n    access {\n      updateApiKey(id: $id, input: $input) {\n        ...ApiKeyFields\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation UpdateApiKey($id: ID!, $input: ApiKeyInput!) {\n    access {\n      updateApiKey(id: $id, input: $input) {\n        ...ApiKeyFields\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation RevokeApiKey($id: ID!) {\n    access {\n      revokeApiKey(id: $id)\n    }\n  }\n"): (typeof documents)["\n  mutation RevokeApiKey($id: ID!) {\n    access {\n      revokeApiKey(id: $id)\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation SetRolePermissions($roleId: ID!, $permissions: [PermissionInput!]!) {\n    access {\n      setRolePermissions(roleId: $roleId, permissions: $permissions) {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation SetRolePermissions($roleId: ID!, $permissions: [PermissionInput!]!) {\n    access {\n      setRolePermissions(roleId: $roleId, permissions: $permissions) {\n        id\n        name\n        permissions {\n          ...PermissionFields\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetEpisodeAccessGroups {\n    episodeAccess {\n      groups {\n        code\n        name\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetEpisodeAccessGroups {\n    episodeAccess {\n      groups {\n        code\n        name\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  fragment AuditLogEntryFields on AuditLogEntry {\n    id\n    createdAt\n    action\n    arguments\n    authMethod\n    userId\n    userEmail\n    apiKeyId\n    apiKeyName\n    userHeader\n    success\n    error\n  }\n"): (typeof documents)["\n  fragment AuditLogEntryFields on AuditLogEntry {\n    id\n    createdAt\n    action\n    arguments\n    authMethod\n    userId\n    userEmail\n    apiKeyId\n    apiKeyName\n    userHeader\n    success\n    error\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetAuditLog($first: Int, $offset: Int, $filter: AuditLogFilter) {\n    access {\n      auditLog(first: $first, offset: $offset, filter: $filter) {\n        total\n        items {\n          ...AuditLogEntryFields\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetAuditLog($first: Int, $offset: Int, $filter: AuditLogFilter) {\n    access {\n      auditLog(first: $first, offset: $offset, filter: $filter) {\n        total\n        items {\n          ...AuditLogEntryFields\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetAuditLogActions {\n    access {\n      auditLogActions\n    }\n  }\n"): (typeof documents)["\n  query GetAuditLogActions {\n    access {\n      auditLogActions\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetEpisodes($filter: String!) {\n    preview {\n      collection(filter: $filter) {\n        items {\n          id\n          title\n          collection\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetEpisodes($filter: String!) {\n    preview {\n      collection(filter: $filter) {\n        items {\n          id\n          title\n          collection\n        }\n      }\n    }\n  }\n"];

export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}

export type DocumentType<TDocumentNode extends DocumentNode<any, any>> = TDocumentNode extends DocumentNode<  infer TType,  any>  ? TType  : never;