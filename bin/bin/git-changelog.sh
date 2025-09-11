#!/bin/bash
R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Generate changelog and optionally create new version tag.

OPTIONS:
    --help             Show this help message
    --major            Create major version tag (breaking changes)
    --minor            Create minor version tag (new features)
    --patch            Create patch version tag (bug fixes)
    --completion-zsh   Print zsh completion script

Without options, only shows changelog and version suggestions.
EOF
}

show_completion_zsh() {
    cat << 'EOF'
#compdef git-changelog git-changelog.sh

_git-changelog() {
    local context state line
    
    _arguments -C \
        '--help[Show help message]' \
        '--major[Create major version tag (breaking changes)]' \
        '--minor[Create minor version tag (new features)]' \
        '--patch[Create patch version tag (bug fixes)]' \
        '--completion-zsh[Print zsh completion script]' \
        '*::' && return 0
}

_git-changelog "$@"
EOF
}

# Parse command line arguments
CREATE_TAG=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --help)
            show_help
            exit 0
            ;;
        --completion-zsh)
            show_completion_zsh
            exit 0
            ;;
        --major)
            CREATE_TAG="major"
            shift
            ;;
        --minor)
            CREATE_TAG="minor"
            shift
            ;;
        --patch)
            CREATE_TAG="patch"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# git pull

# Get last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "${LAST_TAG}" ]; then
    echo "No tags found in repository"
    exit 1
fi

echo "Last tag: ${LAST_TAG}"

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# WARNING if you are in feature branch
if [[ "${CURRENT_BRANCH}" != "main" && "${CURRENT_BRANCH}" != "master" && "${CURRENT_BRANCH}" != "dev" ]]; then
	printf "${R}
				***********
				* WARNING *
				***********

 ${B}You are on branch: ${G}${CURRENT_BRANCH}
 ${B}Expected: ${G}main${B}, ${G}master ${B}or ${G}dev${NC} \n"

    if [[ -n "${CREATE_TAG}" ]]; then
        echo -e "\033[1;31mDo you really want to create a tag from this branch? (y/N):\033[0m"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 1
        fi
    fi
fi


# Get all merged commits since last tag
echo ""
echo -e "${B}Merged commits since ${G}${LAST_TAG} ${B}on branch ${G}${CURRENT_BRANCH}:"
echo -e "${B}==================================================${NC}"

# Use git log to get commits since last tag
CHANGELOG=$(git --no-pager log --format="%h %s" --merges "${LAST_TAG}..${CURRENT_BRANCH}")
echo "${CHANGELOG}"

echo ""
echo -e "${B}Next version suggestions:${NC}"
echo -e "${B}==================================================${NC}"

# Parse current version (with or without v prefix)
if [[ $LAST_TAG =~ ^(v?)([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    PREFIX=${BASH_REMATCH[1]}
    MAJOR=${BASH_REMATCH[2]}
    MINOR=${BASH_REMATCH[3]}
    PATCH=${BASH_REMATCH[4]}
    
    # Calculate next versions keeping same prefix
    NEXT_MAJOR="${PREFIX}$((MAJOR + 1)).0.0"
    NEXT_MINOR="${PREFIX}${MAJOR}.$((MINOR + 1)).0"
    NEXT_PATCH="${PREFIX}${MAJOR}.${MINOR}.$((PATCH + 1))"
    
    echo "Major: ${NEXT_MAJOR} (breaking changes)"
    echo "Minor: ${NEXT_MINOR} (new features)"
    echo "Patch: ${NEXT_PATCH} (bug fixes)"
    
    # Create tag if requested
    if [[ -n "${CREATE_TAG}" ]]; then
        case ${CREATE_TAG} in
            major)
                NEW_TAG="${NEXT_MAJOR}"
                ;;
            minor)
                NEW_TAG="${NEXT_MINOR}"
                ;;
            patch)
                NEW_TAG="${NEXT_PATCH}"
                ;;
        esac
        
        echo ""
        echo "Creating tag: $NEW_TAG"
        git tag -a "${NEW_TAG}" -m "${CHANGELOG}"
        echo "Tag created successfully!"
    fi
else
    echo "Major: (breaking changes)"
    echo "Minor: (new features)" 
    echo "Patch: (bug fixes)"
    
    if [[ -n "${CREATE_TAG}" ]]; then
        echo "Cannot create tag: unable to parse current version format"
        exit 1
    fi
fi
