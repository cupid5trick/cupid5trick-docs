#!/bin/bash

set -exu

Usage() {
  # To debug this build script:
  """
  export GITHUB_TOKEN=xxxxxx
  sudo act -j trigger-hook   --env GITHUB_TOKEN=$GITHUB_TOKEN   --bind $(pwd)/98-publish:$(pwd)/98-publish   --pull=false
  """
  echo "Usages: $0 posts_dir, site_dir, archive_name, site_repo"
  echo "Environments: GITHUB_TOKEN"
  exit 1
}
if [ "$#" -lt 4 ]; then
  Usage
else
  posts_dir=$1
  site_dir=$2
  posts_tgz=$3
  site_repo=$4
  GITHUB_TOKEN=$GITHUB_TOKEN
  mkdir -p {$posts_dir,$site_dir}
  ls -act $site_dir
fi

fetch_archive ()
{
  RELEASE_URL="https://api.github.com/repos/$1/releases/latest"
  GITHUB_TOKEN=$2 # This will be set in Netlify's environment variables
  source_tgz="$3"

  ## Fetch the download URL for the release asset (ZIP file)
  DOWNLOAD_URL=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" $RELEASE_URL | jq -r ".assets[] | select(.name == \"$source_tgz\") | .url")

  ## Download and extract file
  curl -L -o $source_tgz -H "Accept: application/octet-stream" -H "Authorization: token $GITHUB_TOKEN" $DOWNLOAD_URL
}

fetch_tarball ()
{
  RELEASE_URL="https://api.github.com/repos/$1/releases/latest"
  GITHUB_TOKEN=$2 # This will be set in Netlify's environment variables

  ## Fetch the download URL for the release asset (ZIP file)
  DOWNLOAD_URL=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" $RELEASE_URL | jq -r '.tarball_url')

  ## Download and extract file
  source_tgz="$3"
  curl -L -o $source_tgz -H "Authorization: token $GITHUB_TOKEN" $DOWNLOAD_URL
}


# site_tgz="site-$(TZ=Asia/Shangehai date +%Y%m%d%H%M%S).tgz"

fetch_archive cupid5trick/DocumentSync $GITHUB_TOKEN $posts_tgz
# fetch_tarball cupid5trick/cupid5trick-docs $GITHUB_TOKEN $site_tgz

tar --strip-components 1 -zxf $posts_tgz -C $posts_dir/
# git clone --recurse-submodules https://github.com/$site_repo.git $site_dir

mv $posts_dir/{00-阅读,10-ComputeScience,20-工作,30-玩玩游戏,40-学点法律,90-MISC} $site_dir/content/posts/
# mkdir -p site/static/media/posts/ && mv posts/Data/attachments/* site/static/media/posts/
find $posts_dir/Data/attachments/ -type f  -exec mv {} $site_dir/static/media/ \;

ls -act $site_dir/content
# ls -act $site_dir/static/media

cd $site_dir/

# build
build_site () {
  # 1. use config-loveit.yaml as config file
  # 2. enable production enviroment
  # 3. minify build outputs
  # 4. include drafts with `-D` 
  # 5. `-E` include expired content
  # 6. `-F` include content with publishdate in the future
  # 7. `--gc` enable to run some cleanup tasks (remove unused cache files) after the build
  hugo --config config-loveit.yaml -e production --minify -DEF --gc
}

build_site

