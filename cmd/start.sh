#!/bin/bash

source /lib-utils

# Run all
echo 'Run all'
nginx &
/etc/init.d/php7.1-fpm start &
/multi-tail.sh $LOG_FILES
#{extend-run}

# wait SIGTERM or SIGINT
echo 'wait SIGTERM or SIGINT'
wait_signal

# call stop
echo 'call stop'
pkill -x nginx
/etc/init.d/php7.1-fpm stop
pkill -x tail
#{extend-kill}

# wait stop
echo 'wait stop'
wait_exit "nginx php-fpm7.1 tail"
#{extend-wait}