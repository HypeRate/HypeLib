#!/bin/sh

current_version=$(cat mix.exs | grep -P "version: \"(.*)\"")
new_version="0.0.0"
regex="\"(.*)\""

function exit_with_message () {
    echo $1
    echo
    echo "Exiting with code $2"

    exit $2
}

function output_version () {
    echo "Found $1 version: $2"
}

function step () {
    echo "-----"
    echo ""
    echo "Step: $1"
    echo ""
}

step "Checking command line arguments"

if [ "$#" -ne 1 ]; then
    exit_with_message "Usage: $0 <new version string>" 1
fi

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
    echo "Processing file: $file"

    sed -i -e "/###/s/### <upcoming version>/### $new_version/" $file
done


step "Adding mix.exs and README.md to git"
git add mix.exs README.md

step "Commit the new release on master branch"
git commit -m "chore: bump version to $new_version"

step "Create the git tag for triggering the GitHub Actions \"publish\" workflow"
git tag "v$new_version"

step "Push the new commit to GitHub"
git push

step "Push the new tag to GitHub"
git push --tags
