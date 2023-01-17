#!/bin/sh

current_version=$(cat mix.exs | grep -P "version: \"(.*)\"")
new_version="0.0.0"
regex="\"(.*)\""
old_branch=$(git branch --show-current)

function exit_with_message () {
    echo -e "\e[91m$1\e[39m"
    echo
    echo -e "\e[91mExiting with code $2\e[39m"

    exit $2
}

function output_version () {
    echo "Found $1 version: $2"
}

function step () {
    echo "-----"
    echo ""
    echo -e "Step: \e[94m$1\e[39m"
    echo ""
}

function sub_step () {
    echo -e "-> $1"
}

function sub_sub_step () {
    echo -e "  -> $1"
}

step "Checking command line arguments"

if [ "$#" -ne 1 ]; then
    exit_with_message "Usage: $0 <new version string>" 1
fi

step "Stashing current changes"
git stash save "Latest stash on branch $old_branch"

step "Resetting git the hard way"
git reset --hard

step "Switching to master branch"
git checkout master

step "Fetching current version from mix.exs"

if [[ $current_version =~ $regex ]]
then
    current_version="${BASH_REMATCH[1]}"
    new_version=$1
else
    exit_with_message "Could not find current version in mix.exs file" 2
fi

output_version "current" $current_version
output_version "new    " $new_version

step "Replacing version in mix.exs"
sed -i -e "/version/s/\".*\"/\"$new_version\"/" mix.exs

step "Replacing version in README.md"
sed -i -e "/~>/s/\"~> .*\"/\"~> $new_version\"/" README.md

step "Replace upcoming version in all lib/**/*.ex files"

for file in $(find ./lib -type f -name "*.ex"); do
    sub_step "Processing file: \e[36m$file\e[39m"

    sed -i -e "/###/s/### <upcoming version>/### $new_version/" $file
done

step "Adding mix.exs and README.md to git"
git add mix.exs README.md ./lib/

step "Commit the new release on master branch"
git commit -m "chore: bump version to $new_version"

step "Create the git tag for triggering the GitHub Actions \"publish\" workflow"
git tag "v$new_version"

step "Push the new commit to GitHub"
git push

step "Push the new tag to GitHub"
git push --tags

all_branches=()
branches_to_rebase=()
eval "$(git for-each-ref --shell --format='all_branches+=(%(refname:short))' refs/heads/)"

step "Find local branches to rebase"

for branch in "${all_branches[@]}"; do
    if [[ $branch != "master" ]]; then
        branches_to_rebase+=($branch)

        sub_step "Found local branch to rebase: $branch"
    fi
done

if [ "${#branches_to_rebase[@]}" -ne 0 ]; then
    step "Rebasing local branches"

    for branch in "${branches_to_rebase[@]}"; do
        sub_step "Rebasing branch $branch"
        
        git checkout $branch
        git rebase master
    done
else
    sub_step "\e[92m! No local branches to rebase found !\e[39m"
    echo
fi

step "Checking out old branch \e[0m- \e[95m$old_branch\e[39m"
git checkout $old_branch

step "Popping latest stash"
git stash pop

echo
echo "-----"
echo -e "Published new version: \e[5;92m$new_version\e[25;39m!"
echo -e "Also switched back to old branch \e[95m$old_branch\e[39m and applied your lastest changes"
