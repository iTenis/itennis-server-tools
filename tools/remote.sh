#!/usr/bin/env bash

# 远程执行命令
remoteCmd(){
    start=`date +'%F %H:%M:%S'`
    RESULT_ALL=/tmp/res_cmd_all.$$
    local cmd_file="/tmp/exec_cmd_r.$$.$(date +%s%N)"
    tmp_fifofile="/tmp/cmd.$.fifo"
    mkfifo ${tmp_fifofile}     # 新建一个fifo类型的文件
    exec 6<>${tmp_fifofile}      # 将fd6指向fifo类型
    rm -f ${tmp_fifofile}
    THREAD=`grep -Ev "^#|^$" $1 | wc -l`
    for ((i=1;i<${THREAD}+1;i++));do
        echo
    done >&6
    if [[ "$3" = "y" ]];then
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        {
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi
                log INFO "sh $ROOTDIR/core/expect_cmd.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\""
                sh $ROOTDIR/core/expect_cmd.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" > ${cmd_file}
                ret=$?
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
                log ERROR  "thread error"
	        }
	    echo >&6
	    wait
        } &
        done
    else
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        {
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi
                log INFO "sh $ROOTDIR/core/expect_cmd.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\""
                sh $ROOTDIR/core/expect_cmd.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" > ${cmd_file}
                ret=$?
                cat "${cmd_file}" | grep -v "^spawn ssh" | grep -v "^Warning" | grep -v "^Password:" | grep -v "^Authorized" | grep -v "password:" | grep -v "^Permission denied"  | grep -v "^\n"
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
            log ERROR  "thread error"
            }
            echo >&6
            wait
        }
        done
    fi

    wait
    exec 6>&-
    end=`date +'%F %H:%M:%S'`
    log INFO "--------------------------------------------------------------"
    sort -n -k 4 ${RESULT_ALL}
    log INFO  "Shell Cmd Begin time:${start} , End time: ${end}"
    log INFO "--------------------------------------------------------------"

    rm -f  ${RESULT_ALL}
#    rm -f ${cmd_file}
    return 0
}

# 远程发送文件
remoteScpRemote(){
    start=`date +'%F %H:%M:%S'`
    RESULT_ALL=/tmp/res_scp_remote_all.$$
    local cmd_file="/tmp/exec_scp_remote_r.$$.$(date +%s%N)"
    tmp_fifofile="/tmp/scp_remote.$.fifo"
    mkfifo ${tmp_fifofile}     # 新建一个fifo类型的文件
    exec 6<>${tmp_fifofile}      # 将fd6指向fifo类型
    rm -f ${tmp_fifofile}
    THREAD=`grep -Ev "^#|^$" $1 | wc -l`
    for ((i=1;i<$THREAD+1;i++));do
        echo
    done >&6
    if [[ "$4" = "y" ]];then
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        (
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi

                log INFO "sh $ROOTDIR/core/expect_scp_remote.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\" \"$3\""
                sh $ROOTDIR/core/expect_scp_remote.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" "$3" > ${cmd_file}
                ret=$?
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
            log ERROR  "thread error"
            }
            echo >&6
        ) &
        done
    else
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        (
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi

                log INFO "sh $ROOTDIR/core/expect_scp_remote.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\" \"$3\""
                sh $ROOTDIR/core/expect_scp_remote.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" "$3"  > ${cmd_file}
                ret=$?
                cat "${cmd_file}" | grep -v "^spawn scp" | grep -v "^Warning" | grep -v "^Password:" | grep -v "^Authorized" | grep -v "password:" | grep -v "^Permission denied" | grep -v "^\n"
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
            log ERROR  "thread error"
            }
            echo >&6
        )
        done
    fi

    wait
    exec 6>&-
    end=`date +'%F %H:%M:%S'`
    log INFO "--------------------------------------------------------------"
    sort -n -k 4 ${RESULT_ALL}
    log INFO  "Shell Scp Remote Begin time:${start} , End time: ${end}"
    log INFO "--------------------------------------------------------------"

    rm -f  ${RESULT_ALL}
    rm -f ${cmd_file}
    return 0
}

# 远程拷贝文件到本地
remoteScpLocal(){
    start=`date +'%F %H:%M:%S'`
    RESULT_ALL=/tmp/res_scp_local_all.$$
    local cmd_file="/tmp/exec_scp_local_r.$$.$(date +%s%N)"
    tmp_fifofile="/tmp/scp_local.$.fifo"
    mkfifo ${tmp_fifofile}     # 新建一个fifo类型的文件
    exec 6<>${tmp_fifofile}      # 将fd6指向fifo类型
    rm -f ${tmp_fifofile}
    THREAD=`grep -Ev "^#|^$" $1 | wc -l`
    for ((i=1;i<$THREAD+1;i++));do
        echo
    done >&6
    if [[ "$4" = "y" ]];then
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        (
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi
                mkdir -p $3/${arr[0]}
                log INFO "sh $ROOTDIR/core/expect_scp_local.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\" \"$3\""
                sh $ROOTDIR/core/expect_scp_local.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" "$3" > ${cmd_file}
                ret=$?
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
            log ERROR  "thread error"
            }
            echo >&6
        ) &
        done
    else
        for(( i = 1; i < ${THREAD}+1; i++ ))
        do
        (
            read -u6
            {
                arr=(`cat $1 |grep -Ev "^#|^$" | sed -n ${i}p`)
                ping -c 3 -i 0.2 -W 3 ${arr[0]} &> /dev/null
                if [ $? -eq 0 ];then
                    log DEBUG "ping ${arr[0]} succeed"
                else
                    log ERROR "ping ${arr[0]} failed" >> ${RESULT_ALL}
                    continue
                fi
                mkdir -p $3/${arr[0]}
                log INFO "sh $ROOTDIR/core/expect_scp_local.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} \"$2\" \"$3\""
                sh $ROOTDIR/core/expect_scp_local.sh ${SSH_PORT} ${arr[1]} ${arr[0]} ${arr[2]} "$2" "$3"  > ${cmd_file}
                ret=$?
                cat "${cmd_file}" | grep -v "^spawn scp" | grep -v "^Warning" | grep -v "^Password:" | grep -v "^Authorized" | grep -v "password:" | grep -v "^Permission denied" | grep -v "^\n"
                if [ $ret -ne 0 ]; then
                    log ERROR "exec ${arr[0]} failed" >> ${RESULT_ALL}
                else
                    log INFO "exec ${arr[0]} succeed" >> ${RESULT_ALL}
                fi
            } || {
            log ERROR  "thread error"
            }
            echo >&6
        )
        done
    fi

    wait
    exec 6>&-
    end=`date +'%F %H:%M:%S'`
    log INFO "--------------------------------------------------------------"
    sort -n -k 4 ${RESULT_ALL}
    log INFO  "Shell Scp Local Begin time:${start} , End time: ${end}"
    log INFO "--------------------------------------------------------------"

    rm -f  ${RESULT_ALL}
    rm -f ${cmd_file}
    return 0
}

