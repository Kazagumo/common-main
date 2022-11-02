#!/bin/sh /etc/rc.common
START=85
STOP=15
#PROCD=1

start(){
     echo "monitor-inet startup ..."
     res=`ps |grep "*monitor_inet" | grep /bin/sh`
        if [ -n "${res}" ];then
          echo "monitor_inet existence exiting.." > /dev/console
          return 0
        else
          ./etc/momitor_inet.sh & 
          return 1
        fi
}
stop(){
      pid=`ps |grep "*monitor_inet" | grep /bin/sh | awk '{print $1}'`
      if [ -n "${res}" ];then
        kill ${pid}
      fi
      return 0

}
restart(){
      echo "monitor-inet don,t restart command"
      return 0
}
