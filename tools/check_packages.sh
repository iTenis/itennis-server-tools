#!/usr/bin/env bash

check_packages(){
    os_type=`uname  -a`
    log INFO "Operating system type is ${os_type}"

    for package in ${NEED_PACKAGES[@]}
    do
        if [[ -f /usr/bin/${package} ]];then
            log INFO "The package ${package} already exists"
        else
            log INFO "Installing package ${package} , please wait..."
            if [[ ${os_type} =~ "Darwin" ]];then
                brew install ${package} -f >/dev/null 2>&1 || log ERROR "Package ${package} install error"
            elif [[ ${os_type} =~ "ubuntu" ]];then
                apt-get install expect -y >/dev/null 2>&1  || log ERROR "Package ${package} install error"
            else
                yum install expect -y >/dev/null 2>&1  || log ERROR "Package ${package} install error"
            fi
        fi
    done

}
