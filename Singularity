# Copyright (c) 2015-2016, Gregory M. Kurtzer. All rights reserved.
# 
opyright (c) 2015-2016, Gregory M. Kurtzer. All rights reserved.
# 
# "Singularity" Copyright (c) 2016, The Regents of the University of California,
# through Lawrence Berkeley National Laboratory (subject to receipt of any
# required approvals from the U.S. Dept. of Energy).  All rights reserved.


BootStrap: yum
OSVersion: 7
MirrorURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/os/$basearch/
Include: yum

# If you want the updates (available at the bootstrap date) to be installed
# inside the container during the bootstrap instead of the General Availability
# point release (7.x) then uncomment the following line
UpdateURL: http://mirror.centos.org/centos-%{OSVERSION}/%{OSVERSION}/updates/$basearch/

%setup

    cp post.cent.sh $SINGULARITY_ROOTFS


%runscript
    echo "This is what happens when you run the container..."

    if [ $# -eq 0 ]; then
        echo "\nThe following software is installed in this image:"
        column -t /Software/.info | sort -u --ignore-case
        echo "\Note that some Anaconda in the list are modules and note executables."
        echo "Example usage: analysis.img [command] [args] [options]"
    else
        exec "$@"
    fi



%post
    echo "Hello from inside the container"
    yum -y install vim-minimal
    setopt=group_package_types=mandatory,default,optional    
    yum -y groupinstall "Development Tools"
    chmod u+x /post.cent.sh
    ./post.cent.sh


