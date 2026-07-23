# https://www.reddit.com/r/git/comments/1rqwncs/anyone_else_using_git_clone_bare_for_their/
# https://stackoverflow.com/questions/54367011/git-bare-repositories-worktrees-and-tracking-branches
# https://medium.com/@miladpw/git-worktrees-with-bare-repos-a-clean-setup-for-modern-development-c5b251ee7b73

prog="${0##*/}"
ext=${prog#gh-}

_msg() {
    printf '%s\n' "$*" >&2
}

log() {
    _msg "$prog: $*"
}

section() {
    _msg
    _msg "==> $*"
}

die() {
    _msg "$prog: $*"
    exit 1
}

usage() {
    _msg "Usage: gh $ext <org>/<repo>"
    exit 2
}

show_help() {
    cat <<-EOF
		Usage: $prog <org>/<repo>

		Git bare + worktrees setup:

		<PROJECTS>/<org>/<repo>/.git             <- bare, cloned from origin, additional remote: upstream
		                       /master           <- default branch, track upstream, push to origin
		                       /{foo,bar,…}  \\
		                       /feat/{a,b,…}  | <- one worktree per branch at origin
		                       /fix/{a,b,…}  /

		Flags:
		   -h, --help        Show this help message
EOF
}

for arg in "$@"; do
    case "$arg" in
    -h | --help)
        show_help
        exit 0
        ;;
    esac
done

repo_spec=$1

IFS=/ read -r org repo extra <<<"$repo_spec"

if [[ -z $org || -z $repo || -n ${extra:-} ]]; then
    usage
fi

projects_dir=$(xdg-user-dir PROJECTS)

[[ -n $projects_dir ]] || {
    die 'could not determine PROJECTS directory'
}

repo_path=$projects_dir/$org/$repo

if [[ -e $repo_path ]]; then
    die "$repo_path already exists"
fi

log "Creating ‘$repo_path’"
mkdir -p "$repo_path"
cd "$repo_path"

# https://cli.github.com/manual/
handle=$(gh api user --jq .login)

log 'Ensuring we have a fork'
gh repo fork "$org"/"$repo" --default-branch-only --clone=false

log 'Cloning forked bare repo including upstream as a remote and setting tracking refs for it'
gh repo clone "$handle"/"$repo" .git -- --bare --single-branch

log 'Setting core.logAllRefUpdates'
# For git reflog
git config --local core.logAllRefUpdates true

# FIXME: pre-commit-hook doesn’t like this
# https://git-scm.com/docs/git-worktree#_configuration_file
# log 'Setting extensions.worktreeConfig'
# # For per-branch pre-commit hooks
# git config --local extensions.worktreeConfig true

log 'Setting tracking refs for our fork'
# They are not set when doing a bare clone
git config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

log 'Preventing pushing to upstream'
# https://functor.tokyo/blog/2021-12-15-git-no_push
git remote set-url --push upstream no_push

log 'Setting upstream url to use https'
# Allow unauthenticated fetching, also further impede pushing to upstream
git remote set-url upstream "$(gh repo view --json url --jq .url)".git

# Bare clones create a local branch that tracks origin.
# We update it so it instead tracks upstream.
default_branch=$(gh repo view "$handle"/"$repo" --json defaultBranchRef --jq .defaultBranchRef.name)

log "Ensure upstream/$default_branch is available"
git fetch upstream "$default_branch" --no-all

log "Update ref/heads/$default_branch to refs/remotes/upstream/$default_branch"
git update-ref "refs/heads/$default_branch" "refs/remotes/upstream/$default_branch"

log 'Setting default branch to track upstream'
git branch --set-upstream-to=upstream/"$default_branch" "$default_branch"

log "Creating a worktree tracking the default branch: ‘$default_branch’"
git worktree add "$default_branch" "$default_branch"

log 'Setting push remote for default branch to our fork'
# Push to our fork, but fetch from upstream
git config --local branch."$default_branch".pushRemote origin

log 'Unsetting remote.origin.pruneTags'
# Otherwise we’ll prune upstream’s
git config --local remote.origin.pruneTags false

log 'Fetching from origin'
git fetch origin --no-all

section 'Creating a worktree per each of the branches on our fork'
# Allow the following `while` loop to run in the current shell.
shopt -s lastpipe
git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin |
    while IFS= read -r branch; do
        # Skip symbolic refs like origin/HEAD
        [[ $branch == HEAD ]] && continue

        # Skip branches that exist upstream
        if git show-ref --verify --quiet "refs/remotes/upstream/$branch"; then
            continue
        fi

        # Skip if a worktree already exists
        if git worktree list --porcelain | grep --fixed-strings --line-regexp --quiet "branch refs/heads/$branch"; then
            continue
        fi

        section "Creating worktree for fork-only branch: ‘$branch’"
        git worktree add -b "$branch" "$branch" origin/"$branch"
    done
