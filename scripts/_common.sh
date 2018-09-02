#!/bin/bash

current_version="3.1.1"

ynh_check_global_uwsgi_config () {
	uwsgi --version || ynh_die "You need to add uwsgi (and appropriate plugin) as a dependency"

	cp ../conf/uwsgi-app@.service /etc/systemd/system/uwsgi-app@.service

	# make sure the folder for sockets exists and set authorizations
	mkdir -p /var/run/uwsgi/
	chown root:www-data /var/run/uwsgi/
	chmod -R 775 /var/run/uwsgi/

	# make sure the folder for logs exists and set authorizations
	mkdir -p /var/log/uwsgi/app/
	chown root:www-data /var/log/uwsgi/app/
	chmod -R 775 /var/log/uwsgi/app/
}

# Create a dedicated uwsgi ini file to use with generic uwsgi service
# It will install generic uwsgi.socket and
#
# This will use a template in ../conf/uwsgi.ini
# and will replace the following keywords with
# global variables that should be defined before calling
# this helper :
#
#   __APP__       by  $app
#   __PATH__      by  $path_url
#   __FINALPATH__ by  $final_path
#
# usage: ynh_add_systemd_config
#
# to interact with your service: `systemctl <action> uwsgi-app@app`
ynh_add_uwsgi_service () {
	ynh_check_global_uwsgi_config

	# www-data group is needed since it is this nginx who will start the service
	usermod --append --groups www-data "$app" || ynh_die "It wasn't possible to add user $app to group www-data"

	finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"
	ynh_backup_if_checksum_is_different "$finaluwsgiini"
	cp ../conf/uwsgi.ini "$finaluwsgiini"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finaluwsgiini"
	fi
	if test -n "${path_url:-}"; then
		ynh_replace_string "__PATH__" "$path_url" "$finaluwsgiini"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__APP__" "$app" "$finaluwsgiini"
	fi
	ynh_store_file_checksum "$finaluwsgiini"

	chown root: "$finaluwsgiini"

	systemctl daemon-reload
	systemctl enable "uwsgi-app@$app.service"

	# Add as a service
	yunohost service add "uwsgi-app@$app.service" --log "/var/log/uwsgi/app/$app"
}

# Remove the dedicated uwsgi ini file
#
# usage: ynh_remove_systemd_config
ynh_remove_uwsgi_service () {
	finaluwsgiini="/etc/uwsgi/apps-available/$app.ini"
	if [ -e "$finaluwsgiini" ]; then
		systemctl stop "uwsgi-app@$app.service"
		systemctl disable "uwsgi-app@$app.service"
		yunohost service remove "uwsgi-app@$app.service"

		ynh_secure_remove "$finaluwsgiini"
		ynh_secure_remove "/var/log/uwsgi/app/$app"
	fi
}


weblate_fill_settings() {
	local settings="$1"

	ynh_replace_string "__NAME__"       "$app"            "$settings"
	ynh_replace_string "__DB_PWD__"     "$db_pwd"         "$settings"
	ynh_replace_string "__ADMIN__"      "$admin"          "$settings"
	ynh_replace_string "__ADMINMAIL__"  "$admin_mail"     "$settings"
	ynh_replace_string "__DOMAIN__"     "$domain"         "$settings"
	ynh_replace_string "__KEY__"        "$key"            "$settings"
	ynh_replace_string "__FINALPATH__"  "$final_path"     "$settings"
	ynh_replace_string "__MEMCPORT__"   "$memc_port"      "$settings"
	ynh_replace_string "__GITHUBUSER__" "$github_account" "$settings"

	# root install as an empty PATHURL to prevent '//static'
	if [ "$path_url" == "/" ]
	then
		ynh_replace_string "__PATHURL__" "" "$settings"
	else
		ynh_replace_string "__PATHURL__" "$path_url" "$settings"
	fi
}

ynh_check_if_checksum_is_different() {
	local file=$1
	local checksum_setting_name=checksum_${file//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	local checksum_value=$(ynh_app_setting_get $app $checksum_setting_name)
	local check=0

	if ! echo "$checksum_value $file" | md5sum -c --status
	then	# If the checksum is now different
		check=1
	fi

	echo "$check"
}

# Send an email to inform the administrator
#
# usage: ynh_send_readme_to_admin app_message [recipients]
# | arg: app_message - The message to send to the administrator.
# | arg: recipients - The recipients of this email. Use spaces to separate multiples recipients. - default: root
#	example: "root admin@domain"
#	If you give the name of a YunoHost user, ynh_send_readme_to_admin will find its email adress for you
#	example: "root admin@domain user1 user2"
ynh_send_readme_to_admin() {
	local app_message="${1:-...No specific information...}"
	local recipients="${2:-root}"

	# Retrieve the email of users
	find_mails () {
		local list_mails="$1"
		local mail
		local recipients=" "
		# Read each mail in argument
		for mail in $list_mails
		do
			# Keep root or a real email address as it is
			if [ "$mail" = "root" ] || echo "$mail" | grep --quiet "@"
			then
				recipients="$recipients $mail"
			else
				# But replace an user name without a domain after by its email
				if mail=$(ynh_user_get_info "$mail" "mail" 2> /dev/null)
				then
					recipients="$recipients $mail"
				fi
			fi
		done
		echo "$recipients"
	}
	recipients=$(find_mails "$recipients")

	local mail_subject="☁️🆈🅽🅷☁️: \`$app\` was just installed!"

	local mail_message="This is an automated message from your beloved YunoHost server.

Specific information for the application $app.

$app_message

---
Automatic diagnosis data from YunoHost

$(yunohost tools diagnosis | grep -B 100 "services:" | sed '/services:/d')"

	# Define binary to use for mail command
	if [ -e /usr/bin/bsd-mailx ]
	then
		local mail_bin=/usr/bin/bsd-mailx
	else
		local mail_bin=/usr/bin/mail.mailutils
	fi

	# Send the email to the recipients
	echo "$mail_message" | $mail_bin -a "Content-Type: text/plain; charset=UTF-8" -s "$mail_subject" "$recipients"
}
