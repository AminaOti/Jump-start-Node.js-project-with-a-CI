#!/bin/bash
OLD_REPOSITORY_NAME='jumpstart'
OLD_REPOSITORY_TRAVIS_ENCRYPTED_SNKY_TOKEN="cwj7YDIKkfDF344cDoxxBln8Zilg7ohMFrU9BmX7Z0wnSAkS//GyyU81PW4yZKuB7/JpZ9YdoziLFbJCpnKqeNxlPzT6ySVV1/ebsjtZFqHqVeEyMklTiwzHt4D49i3RDoqZ7HF7RAnfKoxIUsEiH3UjwAkCqzbh5xZt6D8Qo5JMwXFgrc0q79BaeX9NjOVqFpmpCESRxZg88tK343Wi4iLtPL02C7vOmix8QujO9/7P16rfkzzTT6Az257CSpj4WGVKc6g72pgDcYDVZiRVRdjcUxk4YnESeSYb4d8g1a3HPFrso0v6tP0o33LR4drApxc/TDmZNMTO6VYlSe5daDXuUoq50EgFjJvI55JKPDa/jDiViiaIZLmudV0mamHE3HnVo4b2bNGY/j7uCPF4TEnnbxsl+6qE4i/DTF0dFSC9KeWH5YQiYIBk7KtoGpSBCCHeDMw6OvmZ+rhkjIUc+LXr3J0VbU4prfgJUQ6m5CzQ1DTdYfgxitYv/7/Z4K9Ap3lT3lHZOO6zF6E2GfMFZjPDpVslPIy1afYlzTnlAn1tV1BAPvg8AFLHqMIUK3FZIcQQQPYnMyMbjQgsnB1NYsxrncpdYYIDKLnywhhMoCgP0XrC7YO6TTx7HigCHW6GmDb0710mlmYJLGyB8QK1xQA7wwr/kVkkxDgWwRamNik="
OLD_REPOSITORY_TRAVIS_ENCRYPTED_SONAR_TOKEN="RusWCKyhDypxVBgmxkJ4lOrVNW2iTtXaWquWibSIXHzHE5vgQI1skrMK/QVmuzydE5u2VXL2k3frU7eX2UiGC8l9vrXDyU361QtzRgJYmm4/ja0pMJsiVhpaayc3EB5H1hZBR1oknDhXLHYhmqh2sLaZPcSnSk4kZsW5rt0Hf4hqb8SQOYNVxMqW5XE67zoWIPB8CaH07WXIosUZZsfdKwJfgnJV7l1AmxbPQ555o32VIFxf+0JDqcrWZVeVtxsvn2zHRAeWjqhEjckwU/U/gkRJmS+/WFXzXRYbFLdu6o2yIP95Wb7ipL/RTxUtRtxGU1tMvqZM7ikTt77mQx3mVpg/ocvFBWP9/+qrJj02yjP1beY7FVJgwjI3DRTr5MZQeUcXiRUF0iGnBBXV6mCYcWfiCdmNLQvcL3m8khL5V+6BzLWW5ITiWLqWBOfgs9ZUXCFt4aPBJ1u2mIpQXdkA2s1fi1eoJRNPVcVd9gBd0Q0im30cWrEpu1k36OiExwHipOkODw2pip5DVE1zC7zDZ4e8VvklKNDOTbvnfGMkW9Sc+3V1kzn71YAUj8mZwMQvGMqlbN0doEtBZaMchF4R42Ic5Gri6qEnrXbrn87r1RK+95kZccM2Mglwu77DvglUXBnDoQmjY1cAx0829Ynnd3BVAokvpV+1O9EBQfNrH+0="

function cloneTemplateRepositry(){
while [ -z $repository_name ]; do
  echo Hello, what is the name of your repository?
  read repository_name
done

set +e
gh repo create $repository_name --template "git@github.ibm.com:Amina-Oti/jumpstart.git" --public --clone
set -e

cd $repository_name

 echo -e "ℹ️    Waiting or the main branch to be ready"
    while [[ "$(git branch -a | grep remotes/origin/master)" != *"remotes/origin/master" ]]; do
        git fetch origin
    done
git checkout master
git config --global init.defaultBranch master
echo -e "👌    Working on the master branch"  

echo Replacing references to template repo with your new repository name... 🚧
sed -i '' "s/node-starter/$repository_name/" package.json
echo Succesffully replaced references
}

function installNpmPackages(){
#vi ~/.zshrc:
echo setting the correct node version
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use 
npm i
}

function swapProjectNameWithNewOne(){
  sed -i '' -e "s/$OLD_REPOSITORY_NAME/$repository_name/g" package-lock.json
  sed -i '' -e "s/$OLD_REPOSITORY_NAME/$repository_name/g" package.json
  sed -i '' -e "s/$OLD_REPOSITORY_NAME/$repository_name/g" sonar-project.properties
}

function addSnykTokenToPipeLine(){
  echo Please enter your Snky token
  read -s snky_token
  travis_encrypted_snky_token=$(travis encrypt SNYK_TOKEN=$snky_token)
  sed -i '' -e "s#$OLD_REPOSITORY_TRAVIS_ENCRYPTED_SNKY_TOKEN#$travis_encrypted_snky_token#g" .travis.yml
}

function addSonarCloudTokenToPipeLine(){
  echo Please enter your Sonar Cloud token
  read -s sonar_token
  travis_encrypted_sonar_token=$sonar_token
  travis env set SONAR_TOKEN $travis_encrypted_sonar_token
}

cloneTemplateRepositry
travis sync
swapProjectNameWithNewOne
installNpmPackages
yes | travis enable 
addSnykTokenToPipeLine
addSonarCloudTokenToPipeLine
swapProjectNameWithNewOne


