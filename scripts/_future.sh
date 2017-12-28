#!/bin/bash

# source: https://github.com/YunoHost/yunohost/commit/4f62eb5320323d4f4de83b2af306ae53e89bc5ba
# Define and install dependencies with a equivs control file
# This helper can/should only be called once per app
#
# usage: ynh_install_app_dependencies dep [dep [...]]
# | arg: dep - the package name to install in dependence
ynh_install_app_dependencies () {
    dependencies=$@
    manifest_path="../manifest.json"
    if [ ! -e "$manifest_path" ]; then
    	manifest_path="../settings/manifest.json"	# Into the restore script, the manifest is not at the same place
    fi
    version=$(grep '\"version\": ' "$manifest_path" | cut -d '"' -f 4)	# Retrieve the version number in the manifest file.
    dep_app=${app//_/-}	# Replace all '_' by '-'

    cat > /tmp/${dep_app}-ynh-deps.control << EOF	# Make a control file for equivs-build
Section: misc
Priority: optional
Package: ${dep_app}-ynh-deps
Version: ${version}
Depends: ${dependencies// /, }
Architecture: all
Description: Fake package for ${app} (YunoHost app) dependencies
 This meta-package is only responsible of installing its dependencies.
EOF
    ynh_package_install_from_equivs /tmp/${dep_app}-ynh-deps.control \
        || ynh_die "Unable to install dependencies"	# Install the fake package and its dependencies
    rm /tmp/${dep_app}-ynh-deps.control
    ynh_app_setting_set $app apt_dependencies $dependencies
}
