#!/bin/bash

# Create a system user
#
# usage: ynh_system_user_create user_name [home_dir]
# | arg: user_name - Name of the system user that will be create
# | arg: home_dir - Path of the home dir for the user. Usually the final path of the app. If this argument is omitted, the user will be created without home
# | arg: password - user password (for SMTP access)
ynh_system_user_create_smtp () {
	if ! ynh_system_user_exists "$1"	# Check if the user exists on the system
	then	# If the user doesn't exist
		if [ $# -ge 2 ]; then	# If a home dir is mentioned
			user_home_dir="-d $2"
		else
			user_home_dir="--no-create-home"
		fi
		user_home_dir="-d $2"
		sudo useradd $user_home_dir --system --user-group $1 --shell /bin/false || ynh_die "Unable to create $1 system account"
	fi
}

ynh_psql_test_if_first_run() {
	if [ -f /etc/yunohost/psql ];
	then
		echo "PostgreSQL is already installed, no need to create master password"
	else
		pgsql=$(ynh_string_random)
		echo "$pgsql" >> /etc/yunohost/psql
		systemctl start postgresql
                sudo -u postgres psql -c"ALTER user postgres WITH PASSWORD '${pgsql}'"
		# we can't use peer since YunoHost create users with nologin
		sed -i '/local\s*all\s*all\s*peer/i \
		local all all password' /etc/postgresql/9.4/main/pg_hba.conf
		systemctl enable postgresql
		systemctl reload postgresql
	fi
}

# Open a connection as a user
#
# example: ynh_psql_connect_as 'user' 'pass' <<< "UPDATE ...;"
# example: ynh_psql_connect_as 'user' 'pass' < /path/to/file.sql
#
# usage: ynh_psql_connect_as user pwd [db]
# | arg: user - the user name to connect as
# | arg: pwd - the user password
# | arg: db - the database to connect to
ynh_psql_connect_as() {
	user="$1"
	pwd="$2"
	db="$3"
	sudo -u postgres PGUSER="${user}" PGPASSWORD="${pwd}" psql "${db}"
}

# # Execute a command as root user
#
# usage: ynh_psql_execute_as_root sql [db]
# | arg: sql - the SQL command to execute
# | arg: db - the database to connect to
ynh_psql_execute_as_root () {
	sql="$1"
	sudo -u postgres psql <<< "$sql"
}

# Execute a command from a file as root user
#
# usage: ynh_psql_execute_file_as_root file [db]
# | arg: file - the file containing SQL commands
# | arg: db - the database to connect to
ynh_psql_execute_file_as_root() {
	file="$1"
	db="$2"
	sudo -u postgres psql "$db" <<< "$file"
}

# Create a database, an user and its password. Then store the password in the app's config
#
# After executing this helper, the password of the created database will be available in $db_pwd
# It will also be stored as "psqlpwd" into the app settings.
#
# usage: ynh_psql_setup_db user name [pwd]
# | arg: user - Owner of the database
# | arg: name - Name of the database
# | arg: pwd - Password of the database. If not given, a password will be generated
ynh_psql_setup_db () {
	db_user="$1"
	app="$1"
	db_name="$2"
	new_db_pwd=$(ynh_string_random)	# Generate a random password
	# If $3 is not given, use new_db_pwd instead for db_pwd.
	db_pwd="${3:-$new_db_pwd}"
	ynh_psql_create_db "$db_name" "$db_user" "$db_pwd"	# Create the database
	ynh_app_setting_set "$app" psqlpwd "$db_pwd"	# Store the password in the app's config
}

# Create a database and grant optionnaly privilegies to a user
#
# usage: ynh_psql_create_db db [user [pwd]]
# | arg: db - the database name to create
# | arg: user - the user to grant privilegies
# | arg: pwd  - the user password
ynh_psql_create_db() {
	db="$1"
	user="$2"
	pwd="$3"
	ynh_psql_create_user "$user" "$pwd"
	sudo -u postgres createdb --owner="${user}" "${db}"
}

# Drop a database
#
# usage: ynh_psql_drop_db db
# | arg: db - the database name to drop
# | arg: user - the user to drop
ynh_psql_remove_db() {
	db="$1"
	user="$2"
	sudo -u postgres dropdb "${db}"
	ynh_psql_drop_user "${user}"
}

# Dump a database
#
# example: ynh_psql_dump_db 'roundcube' > ./dump.sql
#
# usage: ynh_psql_dump_db db
# | arg: db - the database name to dump
# | ret: the psqldump output
ynh_psql_dump_db() {
	db="$1"
	sudo -u postgres pg_dump "${db}"
}


# Create a user
#
# usage: ynh_psql_create_user user pwd [host]
# | arg: user - the user name to create
ynh_psql_create_user() {
	user="$1"
	pwd="$2"
        sudo -u postgres psql -c"CREATE USER ${user} WITH PASSWORD '${pwd}'"
}

# Drop a user
#
# usage: ynh_psql_drop_user user
# | arg: user - the user name to drop
ynh_psql_drop_user() {
	user="$1"
	sudo -u postgres dropuser "${user}"
}
