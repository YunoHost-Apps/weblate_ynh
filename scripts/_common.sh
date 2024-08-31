#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

debian_maj_version=$(sed 's/\..*//' /etc/debian_version)

if [ "$debian_maj_version" -eq 9 ] ; then
    weblate_pypath="python3.5"
elif [ "$debian_maj_version" -eq 10 ] ; then
    weblate_pypath="python3.7"
elif [ "$debian_maj_version" -eq 11 ] ; then
    weblate_pypath="python3.9"
elif [ "$debian_maj_version" -eq 12 ] ; then
    weblate_pypath="python3.11"
fi

set_forge_variables() {
	if [ $used_forge = "GitHub" ] ; then
		github_username="$forge_username"
		github_token="$forge_token"
		gitlab_username="None"
		gitlab_token="None"
	else
		github_username="None"
		github_token="None"
		gitlab_username="$forge_username"
		gitlab_token="$forge_token"
	fi
}
