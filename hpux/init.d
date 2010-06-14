#!/sbin/sh
#
# NOTE:    This script is not configurable!  Any changes made to this
#          scipt will be overwritten when you upgrade to the next
#          release of HP-UX.
#
# WARNING: Changing this script in any way may lead to a system that
#          is unbootable.  Do not modify this script.
#

#
# Start postfix
#

PATH=/sbin:/usr/sbin:/usr/bin
export PATH

rval=0
set_return() {
	x=$?
	if [ $x -ne 0 ]; then
		echo "EXIT CODE: $x"
		rval=1
	fi
}


case $1 in
start_msg)
	echo "Start postfix"
	;;

stop_msg)
	echo "Stopping postfix"
	;;

'start')
	if [ -f /etc/rc.config.d/postfix ] ; then
	    . /etc/rc.config.d/postfix
	else
	    echo "ERROR:   /etc/rc.config/postfix defaults file MISSING"
	    rval=1
	    exit $rval
	fi
 
	if (( $START_POSTFIX )) && [[ -x /opt/postfix/bin/postfix ]]; then
	    if [[ ! -f /etc/postfix/main.cf ]]; then
		echo "ERROR:   Configuration file missing";
		rval=1
		exit $rval
	    fi

	    if [[ -n $POSTFIX_REQD_DIR && ! -d $POSTFIX_REQD_DIR ]]; then
		echo "WARNING: $POSTFIX_REQD_DIR not found - not starting postfix"
		rval=2
		exit $rval
	    fi

	    if /opt/postfix/bin/postfix start; then
		echo "postfix daemon started"
	    else
		set_return
		echo "Could not start postfix daemon"
    	    fi
	else
	    rval=2
	fi
	;;

'stop')
	if [[ -x /opt/postfix/bin/postfix ]]; then
	    if /opt/postfix/bin/postfix stop; then
		echo "postfix daemon killed"
	    else
		set_return
		echo "Could not stop postfix"
    	    fi
	else
	    rval=2
	fi
	;;

*)
	echo "usage: $0 {start|stop|start_msg|stop_msg}"
	;;
esac

exit $rval
