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
elif [ "$debian_maj_version" -eq 13 ] ; then
    weblate_pypath="python3.13"
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


# Create a dedicated systemd socket config
#
# usage: ynh_add_systemd_socket_config [--socket=socket] [--template=template]
# | arg: --socket=      - Socket name (optional, `$app` by default)
# | arg: --template=    - Name of template file (optional, this is 'systemd' by default, meaning `../conf/systemd.socket` will be used as template)
#
# This will use the template `../conf/<templatename>.socket`.
#
# See the documentation of `ynh_config_add` for a description of the template
# format and how placeholders are replaced with actual variables.
ynh_config_add_systemd_socket() {
    # ============ Argument parsing =============
    local -A args_array=([s]=socket= [t]=template=)
    local socket
    local template
    ynh_handle_getopts_args "$@"
    socket="${socket:-$app}"
    template="${template:-systemd.socket}"
    # ===========================================

    ynh_config_add --template="$template" --destination="/etc/systemd/system/$socket.socket"

    systemctl enable "$socket.socket" --quiet
    systemctl daemon-reload
}


# Remove the dedicated systemd socket config
#
# usage: ynh_config_remove_systemd socket
# | arg: socket   - Socket name (optionnal, $app by default)
ynh_config_remove_systemd_socket() {
    local socket="${1:-$app}"
    if [ -e "/etc/systemd/system/$socket.socket" ]; then
        ynh_systemctl --service="$socket" --action=stop
        systemctl disable "$socket" --quiet
        ynh_safe_rm "/etc/systemd/system/$socket.socket"
        systemctl daemon-reload
    fi
}
