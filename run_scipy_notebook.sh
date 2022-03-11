#!/bin/bash
# set -x
# what version of the scipy docker container do you want to use?
# see https://hub.docker.com/r/jupyter/scipy-notebook/tags for all options
# use 'latest' if you're ok being surprised with an occasional 15 minute wait to pull the latest image

# PREVIOUSSCIPYVERSION='1386e2046833' # updated 10/10/19
# PREVIOUSSCIPYVERSION='dc9744740e12' # updated 03/18/20
# PREVIOUSSCIPYVERSION='6d42503c684f' # updated 09/14/20
# PREVIOUSSCIPYVERSION='feacdbfc2e89' # updated 10/17/20
# PREVIOUSSCIPYVERSION='aec555e49be6' # updated 1/22/21
# PREVIOUSSCIPYVERSION='5cb007f03275' # updated 1/31/21
# SCIPYVERSION='d39fb37995ce' # updated 7/24/21
CONTAINERNAME='jupyter/scipy-notebook'
SCIPYVERSION='2e7b2562e0dd' # updated 3/5/22

# would you like to use a custom Dockerfile that extends the scipy-notebook?
CUSTOM_CONTAINER=1

# if using a custom container, where can we find the Dockerfile?
SCIPY_CUSTOM_DOCKERFILE='./scipy/Dockerfile'
VERSION_FILE='./scipy/.scipyversion'

# The result of your `pwd` command
WORKDIR='/Users/Connor/code/jupyter/'

# what is the name of the directory that you would like to share with the jupyter?
NAMEOFSUBDIR='host/'

# the location of a notebook config file
JUPYTER_CONFIG_FILE='notebook.json'

### CONFIG DONE
CUSTOM_TAG='custom'
CUSTOM_CONTAINERNAME="$CONTAINERNAME":"$CUSTOM_TAG"

if [ "$CUSTOM_CONTAINER" -eq 1 ]
then
  printf "To manually rebuild the custom container (e.g. after updating the Dockerfile) run:\n"
  printf "docker image rm -f "$CONTAINERNAME":"$CUSTOM_TAG" && "$0"\n\n"
fi

# create the directory NAMEOFSUBDIR if it doesn't already exist
# this is where your data will go
mkdir "$NAMEOFSUBDIR" &> /dev/null || true

resolvesubdir () {
  echo $(python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$@")
}

# have to resolve the absolute directory in the case of symbolic links
# would use readlink -f but don't have GNU version on OSX
RESOLVED_WORKDIR=$(resolvesubdir "$WORKDIR""$NAMEOFSUBDIR")

# put custom notebook config into the container (can use to specify shortcuts and such)
RESOLVED_CONFIG=$(resolvesubdir "$WORKDIR""$JUPYTER_CONFIG_FILE")

removeCustomContainer () {
  docker image rm -f "CUSTOM_CONTAINERNAME"
}

handleChangedVersion () {
  # remove the old container version so the new one can build
  docker image rm -f "$CONTAINERNAME":"$(cat "$VERSION_FILE")"
  removeCustomContainer
  echo $SCIPYVERSION > $VERSION_FILE
}

versionChanged () {
  OLDVERSION=$(cat "$VERSION_FILE")
  if [ "$OLDVERSION" != "$SCIPYVERSION" ]
  then
    return 0
  else
    return 1
  fi
}

setNewVersion () {
  NEWVERSION="$1"
  echo "$NEWVERSION" > "$VERSION_FILE"
}

if versionChanged
then 
  handleChangedVersion
fi

echo "REMEMBER, only save files you want to maintain access to in the /$NAMEOFSUBDIR directory"

runCustomContainer () {
  docker run -e GRANT_SUDO=yes -p 8888:8888 --volume="$RESOLVED_WORKDIR":'/home/jovyan/'"$NAMEOFSUBDIR" --volume="$RESOLVED_CONFIG":'/home/jovyan/.jupyter/nbconfig/notebook.json' "$CONTAINERNAME":"$CUSTOM_TAG"
}

if [ ! $CUSTOM_CONTAINER -eq 1 ]
then
  docker run -p 8888:8888 --volume="$RESOLVED_WORKDIR":'/home/jovyan/'"$NAMEOFSUBDIR" --volume="$RESOLVED_CONFIG":'/home/jovyan/.jupyter/nbconfig/notebook.json' "$CONTAINERNAME":"$SCIPYVERSION"
else
  docker images | ag '^'"$CONTAINERNAME"'\W*(?='"$CUSTOM_TAG"')' &> /dev/null
  FOUND_IMAGE=$?
  if [ $FOUND_IMAGE -eq 0 ]
  then
    runCustomContainer
  else
    # we have to build the container
    # go to the custom dockerfile directory
    pushd $( dirname "$SCIPY_CUSTOM_DOCKERFILE")
    # build the custom image
    docker build --memory-swap -1 -t "$CONTAINERNAME":custom - < <(cat $( basename "$SCIPY_CUSTOM_DOCKERFILE") | sed s/SCIPYVERSION/$SCIPYVERSION/g)
    # return to the prior container
    popd
    # now that we've rebuilt it with this version, we can store that version persistently to detect
    # an update next time
    setNewVersion "$SCIPYVERSION"
    # now that we've build the new container we can built it
    runCustomContainer
  fi
fi

