# Roles

This document contains the definition and flow of roles.

Roles are called Usergroups in the database. They are also permissive and never restrictive.

# Flow (client)

1. User requests with an X-Application header containing an identifier for an Application.
2. Application is validated or falls back to the default.
3. Roles are retrieved for the user.
    - If the user is registered, add `registered`
    - If the user is not registered, add `public`
    - If the user is a BCC Member, add `bcc-member`
    - Add any additional roles specified by the Emails field in the database.
    - Example result: `["registered", "bcc-member", "early-access"]`
4. Based on the application, iterate through the roles.
    - Add each role again with `{application-code}-{role}`
        - Example result:
            - `registered`
            - `bcc-member`
            - `early-access`
            - `tvos-registered`
            - `tvos-bcc-member`
            - `tvos-early-access`
    - Based on the configuration of the application group. Filter the roles:
        - Example configuration:
            - `tvos-early-access`
            - `ux`
            - `public`
        - Example result (only intersecting roles will apply to the rest of the request):
            - `tvos-early-access`
5. When listing items or where permissions are evaluated, this example will treat the user as only having the
   role `tvos-early-access`.
