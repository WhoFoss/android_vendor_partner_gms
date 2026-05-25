#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

download_apk() {
    local source_apk=$1
    local component_name=$2
    local destination_apk

    destination_apk="$component_name"/"$component_name".apk
    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
    else
        curl -L --output "$destination_apk" "$source_apk"
    fi
}

get-microg-components() {
    local microg_repo_base="https://github.com/microg"
    local name apk_to_download versioncode id
    microg_release=$(cat ".microg_release")

    # GmsCore
    name="GmsCore"
    versioncode=$(cat "$name"/.version_code)
    id="com.google.android.gms"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    download_apk "$apk_to_download" "$name"

    # FakeStore
    name="FakeStore"
    versioncode=$(cat "$name"/.version_code)
    id="com.android.vending"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    download_apk "$apk_to_download" "$name"

    # GsfProxy
    name="GsfProxy"
    versioncode=$(cat "$name"/.version_code)
    apk_to_download="$microg_repo_base"/android_packages_apps_GsfProxy/releases/download/"$versioncode"/"$name".apk
    download_apk "$apk_to_download" "$name"
}

# This script is called from the root directory, so we need to cd
cd vendor/partner_gms
get-microg-components
# and back to the root directory
cd ../..

set +e
