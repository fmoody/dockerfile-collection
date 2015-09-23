#!/bin/bash

# Function: try_running
# Runs command and exits with error message if the command fails to execute properly
# Ran across this on stackoverflow, modified it to exit on failure
function try_running {
    echo "Starting ---> $@"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
	echo "Error running $1, now exiting." >&2
	exit 1
    fi
    echo "Finished ---> $@"
    return $status
}

DATE=`date +%s`

while getopts afh opt; do
    case $opt in
	a)
	    BUILD_ALL=1
	    ;;
	f)
	    BUILD_FORCE=1
	    ;;
	h)
	    echo "Usage: `basename $0`"
	    cat<<EOF
This command will build minetest from the current git head.
-h  This message
-a  Build from scratch image (LONG!)
-f  Force the build from scratch
EOF
	    exit 0
	    ;;
	\?)
	    exit 1
	    ;;
    esac
done

if [ $BUILD_ALL ]
then if [ ! $BUILD_FORCE ]
     then
	 cat<<EOF
#################################################################################
#### WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ####
#################################################################################
#### This will build up the minetest images from a base fmoody/funtoo:latest ####
#### image and includes updating the portage image, building the             ####
#### dependencies, and then building the minetest server from git. This will ####
#### take some time.                                                         ####
#################################################################################

If you are certain this is what you want to do, pass the -f flag to force the
full build out.
EOF
	 exit 1
     else
	 cd updated_portage/
	 try_running docker build -t fmoody/funtoo:$DATE .
	 try_running docker tag -f fmoody/funtoo:$DATE fmoody/funtoo:latest
	 cd ..
	 cd minetest_dependencies/
	 try_running docker build -t fmoody/minetest_deps:$DATE .
	 try_running docker tag -f fmoody/minetest_deps:$DATE fmoody/minetest_deps:latest
	 cd ..
	 cd minetest-dev-pre/
	 try_running docker build -t fmoody/minetest_dev_pre:$DATE .
	 try_running docker tag -f fmoody/minetest_dev_pre:$DATE fmoody/minetest_dev_pre:latest
	 cd ..
     fi
fi

cd minetest-dev/
try_running docker build --no-cache -t fmoody/minetest-dev:$DATE .
try_running docker tag -f fmoody/minetest-dev:$DATE fmoody/minetest-dev:latest
cd ..

