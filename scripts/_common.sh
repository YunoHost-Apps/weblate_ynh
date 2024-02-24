#!/bin/bash

#=================================================
# COMMON VARIABLES
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

#=================================================
# PERSONAL HELPERS
#=================================================

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

#=================================================
# EXPERIMENTAL HELPERS
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

	test "$db" -eq -1 && ynh_die --message="No available Redis databases..."

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
# FUTURE OFFICIAL HELPERS
#=================================================
