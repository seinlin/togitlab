Mirror and sync all repos, Input files are needed as bellow.
- ./github_to_gitlab.sh

A dry run to validate the scripts.
- DEBUG=echo ./github_to_gitlab.sh


Orgs list: mirror.list

A list of orgs' name to be mirror.

Token file: .github_access_token and .gitlab_access_token

A token used to access github and gitlab. For gitlab need to have the access right of create groups.
