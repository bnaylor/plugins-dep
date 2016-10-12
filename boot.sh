#!/bin/bash 

#
# Initial proof of concept host dependency checker
#
# Lots of things missing; only looking at redhat/debian at the moment, etc.
#
# Should also detect coreos specifically and bypass all of this because it has
# all the dependencies by default.
#

#
# These would be listed in the plugin Manifest
deps_yum="nfs-utils lsscsi iscsi-initiator-utils sg3_utils device-mapper-multipath"
deps_apt="nfs-common open-iscsi lsscsi sg3-utils multipath-tools scsitools"
deps_fake="testing foo baz qqnoob"

# Controls which package manager to use once distribution is detected
pkg_mode=
host_dist=unknown

# Shared mount passed in as -v /:/host
host_pfx="/host"
host_exec="chroot /host"

install_missing=1
run=0

# simplistic for demo
function check_redhat() {
	[ -e "$host_pfx/etc/redhat-release" ] 
}

function check_debian() {
	[ -e "$host_pfx/etc/debian-release" ]
}

function check_osx() {
	darwin=`uname -a | awk '{print $1}'`
	if [ "$darwin" = "Darwin" ] ; then
	        return 0
	fi
	return 1
}

function set_pkg_mode() {
	# sometimes you see apt on rh systems but not usually the other way
	# around, so check for rh first
	if check_redhat ; then
		pkg_mode="yum"
		host_dist="redhat-based"
        elif check_debian ; then
	        pkg_mode="apt"
		host_dist="debian-based"
	elif check_osx ; then
	        pkg_mode="fake"
		host_dist="osx"
	fi
}

function check_pkg_yum() {
	local pk=$1
	$host_exec rpm -qi $pk > /dev/null 2>&1
}

function chk_pkg_apt() {
	local pk=$1
	$host_exec dpkg -s $pk > /dev/null 2>&1
}

function check_pkg_fake() {
	local pk=$1
	return 1
}

function check_pkg() {
	local pk=$1
	fn="check_pkg_$pkg_mode"
	$fn $pk
}

function install_pkgs_yum() {
	local pkgs=$*
	$host_exec yum -y install $pkgs
}

function install_pkgs_apt() {
	local pkgs=$*
	$host_exec apt-get install -y $pkgs
}

function install_pkgs_fake() {
	local pkgs=$*
	echo install $pkgs
}

function install_pkgs() {
	local pkgs=$*
	fn="install_pkgs_$pkg_mode"
	echo Starting install using \'$pkg_mode\' for the following packages:
	echo $pkgs
	$fn $pkgs
}

while getopts "i" arg ; do
	case $arg in
	"i") install_missing=0 ;;
        esac
done
shift "$((OPTIND-1))"

set_pkg_mode
if [ -z "$pkg_mode" ] ; then
        echo
	echo "Couldn't determine how to manage packages on this distribution.  This plugin has"
	echo "host dependencies that need to be satisfied for it to work correctly.  For example,"
	echo "  redhat-based: $deps_yum"
	echo "  debian-based: $deps_apt"
	echo
else
  	missing=
        deps=$(eval echo \$deps"_"$pkg_mode)
	for d in $deps; do
		if ! check_pkg $d; then
			missing="$missing $d"
		fi
	done

	if [ ! -z "$missing" ] ; then
		if [ $install_missing = 0 ] ; then
		        install_pkgs $missing
			if [ $? != 0 ] ; then
			        echo There was an error installing dependencies.  Aborting.
				run=1
			fi
	        else
			echo This plugin is dependent on several packages that are missing
			echo on the $host_dist host system:
			echo
			echo " > " $missing
			echo
			echo Please install them, or re-run this plugin with -i to try to
			echo install them automatically.
			run=1
		fi
	fi
fi

# run actual plugin
if [ $run = 0 ] ; then
        ./netappdvp $*
fi

