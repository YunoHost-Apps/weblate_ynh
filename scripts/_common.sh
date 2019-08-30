#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="libxml2-dev libxslt-dev libfreetype6-dev \
	libjpeg-dev libz-dev libyaml-dev python3-dev python3-pip python3-virtualenv \
	python3-enchant \
	postgresql libpq-dev uwsgi uwsgi-plugin-python3 \
	libpango1.0-dev libcairo2-dev libglib2.0-dev libgirepository1.0-dev \
	mailutils python-celery-common virtualenv redis-server"

# Weblate's version for PIP and settings file
current_version="3.8"

#=================================================
# PERSONAL HELPERS
#=================================================

weblate_fill_settings() {
	local settings="$1"

	ynh_replace_string "__NAME__"       "$app"            "$settings"
	ynh_replace_string "__DB_PWD__"     "$db_pwd"         "$settings"
	ynh_replace_string "__ADMIN__"      "$admin"          "$settings"
	ynh_replace_string "__ADMINMAIL__"  "$admin_mail"     "$settings"
	ynh_replace_string "__DOMAIN__"     "$domain"         "$settings"
	ynh_replace_string "__KEY__"        "$key"            "$settings"
	ynh_replace_string "__FINALPATH__"  "$final_path"     "$settings"
	ynh_replace_string "__GITHUBUSER__" "$github_account" "$settings"
	ynh_replace_string "__REDIS_DB__"   "$redis_db"       "$settings"

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

#=================================================
#
# Redis HELPERS
#
# Point of contact : Jean-Baptiste Holcroft <jean-baptiste@holcroft.fr>
#=================================================

# get the first available redis database
#
# usage: ynh_redis_get_free_db
# | returns: the database number to use
ynh_redis_get_free_db() {
	local result max db
	result=$(redis-cli INFO keyspace)

	# get the num
	max=$(cat /etc/redis/redis.conf | grep ^databases | grep -Eow "[0-9]+")

	db=0
	# default Debian setting is 15 databases
	for i in $(seq 0 "$max")
	do
	 	if ! echo "$result" | grep -q "db$i"
	 	then
			db=$i
	 		break 1
 		fi
 		db=-1
	done

	test "$db" -eq -1 && ynh_die "No available Redis databases..."

	echo "$db"
}

# Create a master password and set up global settings
# Please always call this script in install and restore scripts
#
# usage: ynh_redis_remove_db database
# | arg: database - the database to erase
ynh_redis_remove_db() {
	local db=$1
	redis-cli -n "$db" flushall
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# Print a message as INFO and show progression during an app script
#
# usage: ynh_script_progression --message=message [--weight=weight] [--time]
# | arg: -m, --message= - The text to print
# | arg: -w, --weight=  - The weight for this progression. This value is 1 by default. Use a bigger value for a longer part of the script.
# | arg: -t, --time=    - Print the execution time since the last call to this helper. Especially usefull to define weights.
# | arg: -l, --last=    - Use for the last call of the helper, to fill te progression bar.
increment_progression=0
previous_weight=0
ynh_script_progression () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [m]=message= [w]=weight= [t]=time [l]=last )
	local message
	local weight
	local time
	local last
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	weight=${weight:-1}
	time=${time:-0}
	last=${last:-0}


	# Get the number of occurrences of 'ynh_script_progression' in the script. Except those are commented.
	local helper_calls="$(grep --count "^[^#]*ynh_script_progression" $0)"
	# Get the number of call with a weight value
	local weight_calls=$(grep --perl-regexp --count "^[^#]*ynh_script_progression.*(--weight|-w )" $0)

	# Get the weight of each occurrences of 'ynh_script_progression' in the script using --weight
	local weight_valuesA="$(grep --perl-regexp "^[^#]*ynh_script_progression.*--weight" $0 | sed 's/.*--weight[= ]\([[:digit:]].*\)/\1/g')"
	# Get the weight of each occurrences of 'ynh_script_progression' in the script using -w
	local weight_valuesB="$(grep --perl-regexp "^[^#]*ynh_script_progression.*-w " $0 | sed 's/.*-w[= ]\([[:digit:]].*\)/\1/g')"
	# Each value will be on a different line.
	# Remove each 'end of line' and replace it by a '+' to sum the values.
	local weight_values=$(( $(echo "$weight_valuesA" | tr '\n' '+') + $(echo "$weight_valuesB" | tr '\n' '+') 0 ))

	# max_progression is a total number of calls to this helper.
	#    Less the number of calls with a weight value.
	#    Plus the total of weight values
	local max_progression=$(( $helper_calls - $weight_calls + $weight_values ))

	# Increment each execution of ynh_script_progression in this script by the weight of the previous call.
	increment_progression=$(( $increment_progression + $previous_weight ))
	# Store the weight of the current call in $previous_weight for next call
	previous_weight=$weight

	# Set the scale of the progression bar
	local scale=20
	# progress_string(1,2) should have the size of the scale.
	local progress_string1="####################"
	local progress_string0="...................."

	# Reduce $increment_progression to the size of the scale
	if [ $last -eq 0 ]
	then
		local effective_progression=$(( $increment_progression * $scale / $max_progression ))
	# If last is specified, fill immediately the progression_bar
	else
		local effective_progression=$scale
	fi

	# Build $progression_bar from progress_string(1,2) according to $effective_progression
	local progression_bar="${progress_string1:0:$effective_progression}${progress_string0:0:$(( $scale - $effective_progression ))}"

	ynh_print_info "[$progression_bar] > ${message}"
}
