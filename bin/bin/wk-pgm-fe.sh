#!/bin/sh

set -eu

R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color

log_info() {
	printf "%b[wk-pgm-fe]%b %s\n" "$B" "$NC" "$*"
}

log_step() {
	printf "%b[wk-pgm-fe]%b %s\n" "$Y" "$NC" "$*"
}

log_ok() {
	printf "%b[wk-pgm-fe]%b %s\n" "$G" "$NC" "$*"
}

log_error() {
	printf "%bError:%b %s\n" "$R" "$NC" "$*" >&2
}

usage() {
	echo "Usage: $0 <branch-name|origin/branch-name>" >&2
	echo "       $0 -d|--delete <worktree-dir>" >&2
	echo "Example: $0 feat/my-branch" >&2
	echo "Example: $0 origin/someone-branch" >&2
	echo "Example: $0 --delete feat-my-branch" >&2
}

RAW_BRANCH=""
BASE_REF="origin/main"
DELETE_MODE=0

while [ "$#" -gt 0 ]; do
	case "$1" in
	-h | --help)
		usage
		exit 0
		;;
		-d | --delete)
			DELETE_MODE=1
			;;
		-*)
			log_error "unknown option: $1"
			usage
			exit 1
			;;
		*)
			if [ -n "$RAW_BRANCH" ]; then
				log_error "expected exactly one branch argument"
				usage
				exit 1
			fi
		RAW_BRANCH=$1
		;;
	esac
	shift
done

if [ -z "$RAW_BRANCH" ]; then
	log_error "missing argument"
	usage
	exit 1
fi

if [ "$(git rev-parse --is-bare-repository 2>/dev/null || true)" != "true" ]; then
	log_error "run this from a bare repository"
	exit 1
fi

if [ "$DELETE_MODE" -eq 1 ]; then
	case "$RAW_BRANCH" in
	/*) WORKTREE_DIR=$RAW_BRANCH ;;
	*) WORKTREE_DIR="./$RAW_BRANCH" ;;
	esac

	log_info "delete mode"
	log_info "target worktree: $WORKTREE_DIR"

	if [ ! -d "$WORKTREE_DIR" ]; then
		log_error "worktree directory not found: $WORKTREE_DIR"
		exit 1
	fi

	BRANCH_NAME=$(git -C "$WORKTREE_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
	if [ -z "$BRANCH_NAME" ] || [ "$BRANCH_NAME" = "HEAD" ]; then
		log_error "could not determine branch from worktree: $WORKTREE_DIR"
		exit 1
	fi
	log_info "detected branch: $BRANCH_NAME"

	log_step "removing worktree"
	git worktree remove --force "$WORKTREE_DIR"

	if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
		log_step "deleting local branch: $BRANCH_NAME"
		git branch -D "$BRANCH_NAME"
	else
		log_step "local branch already missing: $BRANCH_NAME"
	fi

	log_step "pruning stale worktree entries"
	git worktree prune
	log_ok "delete complete"
	exit 0
fi

# Passing origin/<branch> means: use it as base and create local branch
# without the origin/ prefix.
case "$RAW_BRANCH" in
origin/*)
	BASE_REF=$RAW_BRANCH
	RAW_BRANCH=${RAW_BRANCH#origin/}
	;;
esac

# slashes/spaces -> dash
# any other invalid char -> dash
# collapse repeated dashes
# trim leading and trailing  dash
SAFE_BRANCH=$(printf '%s' "$RAW_BRANCH" |
	tr '[:upper:]' '[:lower:]' |
	sed -e 's#[/[:space:]]\+#-#g' \
		-e 's#[^a-z0-9._-]#-#g' \
		-e 's#-\{2,\}#-#g' \
		-e 's#^-##' \
		-e 's#-$##')

if [ -z "$SAFE_BRANCH" ]; then
	log_error "branch name became empty after sanitization"
	exit 1
fi

WORKTREE_DIR="./$SAFE_BRANCH"

log_info "create mode"
log_info "branch: $SAFE_BRANCH"
log_info "base: $BASE_REF"
log_info "worktree: $WORKTREE_DIR"

if ! git rev-parse --verify --quiet "$BASE_REF^{commit}" >/dev/null; then
	case "$BASE_REF" in
	*/*)
		REMOTE=${BASE_REF%%/*}
		REMOTE_BRANCH=${BASE_REF#*/}
		if git remote get-url "$REMOTE" >/dev/null 2>&1; then
			log_step "fetching missing base ref: $BASE_REF"
			git fetch "$REMOTE" "$REMOTE_BRANCH:refs/remotes/$REMOTE/$REMOTE_BRANCH"
		fi
		;;
	esac
fi

if ! git rev-parse --verify --quiet "$BASE_REF^{commit}" >/dev/null; then
	log_error "base reference not found: $BASE_REF"
	printf "%bTip:%b pass main, origin/main, or origin/someone-branch\n" "$Y" "$NC" >&2
	exit 1
fi

if [ -e "$WORKTREE_DIR" ]; then
	log_error "worktree path already exists: $WORKTREE_DIR"
	exit 1
fi

log_step "creating worktree"
git worktree add -b "$SAFE_BRANCH" "$WORKTREE_DIR" "$BASE_REF"
cd "$WORKTREE_DIR"

log_step "installing dependencies"
npm ci
log_step "running prepare"
npm run prepare

log_ok "worktree ready"
pwd
