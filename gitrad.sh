#!/bin/sh

command=$1

if [ "$command" = "init" ]; then
    name=$3

    ./expect.sh $name

    # create remote using the api

    curl -sX POST "https://api.github.com/user/repos" \
         -H "accept: application/json" \
         -H "Authorization: token $GITHUB_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{\"name\": \"$name\" }"

    curl -sX POST "https://gitea.iot-engineering.life/api/v1/user/repos" \
         -H "accept: application/json" \
         -H "Authorization: token $GITEA_TOKEN" \
         -H "Content-Type: application/json" \
         -d "{ \"name\": \"$name\" }"


    git add -A
    git commit -m "It begins..."


    echo 'Remotes Created !'

    # set up remotes
    git remote add gitea "https://gitea.iot-engineering.life/resister/$name.git"
    git remote add  github  "https://github.com/wordyallen/$name.git"
    git push -u gitea master
    git push -u github master

fi







if [ "$command" = "checkout" ]; then
    branch=$3
    project_id=$5

    git checkout -b "$branch"

 fi
#





if [ "$command" = "propose" ]; then

    hash=$(git rev-parse --short HEAD)
    name=$(basename -s .git `git config --get remote.github.url`)
    message=$3

    rad patch propose "$hash"
    rad patch comment 0  "$message"

    git add -A
    git commit -m "$message"
    git push github
    git push gitea

fi


# ddsljkdsjlkds 

if [ "$command" = "remove" ]; then
    name=$3

    curl -sX DELETE "https://api.github.com/repos/wordyallen/$name" \
         -H "accept: application/json" \
         -H "Authorization: token $GITHUB_TOKEN" \
         -H "Content-Type: application/json" \

    curl -sX DELETE "https://gitea.iot-engineering.life/api/v1/repos/resister/$name" \
         -H "accept: application/json" \
         -H "Authorization: token $GITEA_TOKEN" \
         -H "Content-Type: application/json" \


    echo 'Remotes Removed!'

fi
