#!/usr/bin/env bash

load_function(){
    . config/itennis.conf
    . core/log_print.sh
    . tools/remote.sh
    . tools/check_packages.sh
    . tools/base_function.sh
}

batch_exec_cmds(){
    CMDS_LIST=/tmp/cmds_list.$$
    CONF_LIST=${HOSTS_CONF}
read -p "please input command: "
(
cat << EOF
$REPLY
EOF
) > ${CMDS_LIST}
    while true
    do
        read -p "Please enter whether multiple processes are running backstage[y/n]: "
        bg=$REPLY
        if [[ $bg = "y" ]] || [[ $bg = "n" ]];then
            break
        fi
    done
    remoteScpRemote config/${MAIN_IP_CONFIG} ${CMDS_LIST} ${CMDS_LIST} y >/dev/null 2>&1
    remoteCmd config/${MAIN_IP_CONFIG} "sh ${CMDS_LIST}" $bg
    remoteCmd config/${MAIN_IP_CONFIG} "rm -f ${CMDS_LIST}" y >/dev/null 2>&1
    rm /tmp/*.$$ >/dev/null 2>&1
}

batch_exec_scp_remote(){
    read -p "Please enter the local path:"
    LOCAL_FILE=$REPLY
    read -p "Please enter the remote path:"
    REMOTE_FILE=$REPLY
    while true
    do
        read -p "Please enter whether multiple processes are running backstage[y/n]: "
        bg=$REPLY
        if [[ $bg = "y" ]] || [[ $bg = "n" ]];then
            break
        fi
    done
    remoteScpRemote config/${MAIN_IP_CONFIG} ${LOCAL_FILE} ${REMOTE_FILE} $bg
}

batch_exec_scp_local(){
    read -p "Please enter the remote path:"
    REMOTE_FILE=$REPLY
    read -p "Please enter the local path:"
    LOCAL_FILE=$REPLY
    while true
    do
        read -p "Please enter whether multiple processes are running backstage[y/n]: "
        bg=$REPLY
        if [[ $bg = "y" ]] || [[ $bg = "n" ]];then
            break
        fi
    done
    remoteScpLocal config/${MAIN_IP_CONFIG} ${REMOTE_FILE} ${LOCAL_FILE} $bg
}

display(){
    echo "****************************************Please Input************************************"
    echo "**  [1]：Batch execute commands             **                                        **"
    echo "**  [2]：Batch copy files to remote         **                                        **"
    echo "**  [3]：Batch copy files to local          **                                        **"
    echo "**  [q]：Quit                               **                                        **"
    echo "***********************@iTennis By xiehuisheng@hotmail.com******************************"
    read -p "Please input [1-3,q]: " INPUT
    choose_function ${INPUT}
    display
}

choose_function(){
    case "$1" in
    [1] ) log INFO  "Select function $1: Batch execute commands"      ;batch_exec_cmds;;
    [2] ) log INFO  "Select function $1: Batch copy files to remote"  ;batch_exec_scp_remote;;
    [3] ) log INFO  "Select function $1: Batch copy files to local"   ;batch_exec_scp_local;;
    [q] ) log INFO  "Program exit"                                    ;exit 0;;
    * ) log ERROR "This feature is still under development, please reselect the feature" ;;
    esac
}

load_function
check_packages

if [[ ! -n "$1" ]];then
    display
elif [[ "$1" = "-f" ]];then
	choose_function $2
elif [[ "$1" = "--version" || "$1" = "-v" ]];then
	log INFO "iTennis version:${VERSION}"
elif [[ "$1" = "--debug" || "$1" = "-d" ]];then
	log WARN "Start program debugging..."
	PS4="#[DEBUGGING]:"
    set -x
    display
else
    log ERROR "Your options are wrong, please check if your parameters are correct"
fi


#isNext
#remoteCmd config/${MAIN_IP_CONFIG} "ls -l ~/yc_goods_show" n
#remoteScpRemote config/${MAIN_IP_CONFIG} /Users/apple/Desktop/yc_projects/yc_goods_show/target/goods_show.jar '~/yc_goods_show/' n
#remoteCmd config/${MAIN_IP_CONFIG} "ls -l ~/yc_goods_show" n
#remoteCmd config/${MAIN_IP_CONFIG} 'rm -rf ~/logs' y
#remoteScpLocal config/${MAIN_IP_CONFIG} '~/itennis.log'  logs  n
