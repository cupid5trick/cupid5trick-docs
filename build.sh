#!/bin/bash

set -exu

Usage() {
  cat <<'EOF'
Usages:
  $0 posts_dir site_dir archive_name site_repo   # production build (Netlify)
  $0 local-dev                                   # local dev: prepare only, then hugo serve

Environments:
  GITHUB_TOKEN         Netlify secret; fetches the DocumentSync release archive
  QUARTZ_ACL_PASSWORD  Optional; only needed if the archive contains @acl/private
                       notes (see obsidian_quartz/docs/advanced/protected-notes.md).

Local development:
  ./build.sh local-dev && hugo serve --config config-loveit.yaml -e production -DEF --minify --bind 0.0.0.0 --port 1313
  # to also serve the Quartz site: cd obsidian_quartz && ./dev_setup.sh <vault>
EOF
  exit 1
}

if [ "$#" -lt 4 ] && [ "$#" != 1 ]; then
  Usage

elif [ "$#" -eq 4 ]; then
  posts_dir=$1
  site_dir=$2
  posts_tgz=$3
  site_repo=$4
  mkdir -p {$posts_dir,$site_dir}
  ls -act $site_dir
  GITHUB_TOKEN=$GITHUB_TOKEN
fi

flag=$1

fetch_archive() {
  RELEASE_URL="https://api.github.com/repos/$1/releases/latest"
  GITHUB_TOKEN=$2 # This will be set in Netlify's environment variables
  source_tgz="$3"

  ## Fetch the download URL for the release asset (ZIP file)
  DOWNLOAD_URL=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" $RELEASE_URL | jq -r ".assets[] | select(.name == \"$source_tgz\") | .url")

  ## Download and extract file
  curl -L -o $source_tgz -H "Accept: application/octet-stream" -H "Authorization: token $GITHUB_TOKEN" $DOWNLOAD_URL
}

fetch_tarball() {
  RELEASE_URL="https://api.github.com/repos/$1/releases/latest"
  GITHUB_TOKEN=$2 # This will be set in Netlify's environment variables

  ## Fetch the download URL for the release asset (ZIP file)
  DOWNLOAD_URL=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" $RELEASE_URL | jq -r '.tarball_url')

  ## Download and extract file
  source_tgz="$3"
  curl -L -o $source_tgz -H "Authorization: token $GITHUB_TOKEN" $DOWNLOAD_URL
}

fetch() {
  if [ $flag != "local-dev" ]; then
    site_tgz="site-$(TZ=Asia/Shanghai date +%Y%m%d%H%M%S).tgz"

    fetch_archive cupid5trick/DocumentSync $GITHUB_TOKEN $posts_tgz
    # fetch_tarball cupid5trick/cupid5trick-docs $GITHUB_TOKEN $site_tgz

    tar --strip-components 1 -zxf $posts_tgz -C $posts_dir/
    # git clone --recurse-submodules https://github.com/$site_repo.git $site_dir

    cp -r $posts_dir/{00-阅读,10-ComputeScience,20-工作,30-玩玩游戏,40-学点法律,90-MISC} $site_dir/content/posts/
    # mkdir -p site/static/media/posts/ && mv posts/Data/attachments/* site/static/media/posts/
    find $posts_dir/Data/attachments/ -type f -exec cp {} $site_dir/static/media/ \;

    ls -act $site_dir/content
    # ls -act $site_dir/static/media

    cd $site_dir/
  fi
}

# build
build_site() {
  # 1. use config-loveit.yaml as config file
  # 2. enable production enviroment
  # 3. minify build outputs
  # 4. include drafts with `-D`
  # 5. `-E` include expired content
  # 6. `-F` include content with publishdate in the future
  # 7. `--gc` enable to run some cleanup tasks (remove unused cache files) after the build
  hugo --config config-loveit.yaml -e production --minify -DEF --gc
}

# build obsidian site (Quartz v5 static build)
build_obsidian() {
  # obsidian_quartz is a submodule pinned to a v5 commit (see .gitmodules / PR #1).
  local site_abs_dir
  site_abs_dir="$(realpath "$site_dir")"
  cd "$site_abs_dir/obsidian_quartz"

  # Source build-time secrets (QUARTZ_ACL_PASSWORD) from a gitignored acl.env if present
  if [ -f "./acl.env" ]; then
    set -a
    . ./acl.env
    set +a
  fi

  # v5: `-d` selects the content dir, `-o` the output. Do NOT use dev_setup.sh here —
  # it ends in `npx quartz build --serve`, which would block a production build.
  # The base URL is taken from quartz.config.yaml, not a build flag.
  npm install
  npx quartz plugin install
  npx quartz build -d "$(realpath "$posts_dir")" -o "$site_abs_dir/public/obsidian"
}

rm -rf public obsidian_quartz/public

fetch
build_site
build_obsidian
