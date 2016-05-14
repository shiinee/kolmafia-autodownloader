#!/bin/bash

# Downloads the latest build of KoLMafia from the official builds site.

# Local directory where KoLMafia executables are stored
BASE_DIR=~/kol
BUILDS_DIR=$BASE_DIR/builds

# Path to be symlinked to the latest build
LATEST_SYMLINK=$BASE_DIR/KoLmafia-latest.jar

# URL to the build list
BUILDS_URL="http://builds.kolmafia.us"

# Build names take the form 'KoLmafia-<versionnum>.jar'. Links to builds
# are directly off the root site: <buildlist_url>/<buildname>.
BUILD_LINK_REGEX="$BUILDS_URL/KoLmafia-[0-9]{5,}.jar"

# Find the link to the latest build. It should be the first link on the
# KolMafia builds site.
LATEST_URL=$(curl $BUILDS_URL | egrep -o $BUILD_LINK_REGEX | head -n 1)
if [ -z "$LATEST_URL" ]; then
  echo "Couldn't find a link to the latest build on $BUILDS_URL"
  exit 1
fi

# Download the latest build, unless it has already been downloaded.
LATEST_FILENAME=$BUILDS_DIR/$(basename $LATEST_URL)
if [ ! -f $LATEST_FILENAME ]; then
  curl -o $LATEST_FILENAME --create-dirs $LATEST_URL
fi

# Update the KoLmafia-latest.jar symlink to refer to the latest build.
rm $LATEST_SYMLINK
ln -s $LATEST_FILENAME $LATEST_SYMLINK
