#!/bin/sh

MOD="" # CTRL+g
ESC="" # \e
DVTM="./dvtm-plus"
LOG="dvtm-plus.log"
TEST_LOG="$0.log"
UTF8_TEST_URL="http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt"

[ ! -z "$1" ] && DVTM="$1"
[ ! -x "$DVTM" ] && echo "usage: $0 path-to-dvtm-plus-binary" && exit 1

dvtm_plus_input() {
	printf "$1"
}

dvtm_plus_cmd() {
	printf "${MOD}$1\n"
	sleep 1
}

sh_cmd() {
	printf "$1\n"
	sleep 1
}

test_copymode() { # requires wget, diff, vi
	local FILENAME="UTF-8-demo.txt"
	[ ! -e "$FILENAME" ] && (wget "$UTF8_TEST_URL" -O "$FILENAME" > /dev/null 2>&1 || return 1)
	sleep 1
	sh_cmd "cat $FILENAME"
	dvtm_plus_cmd 'v'
	dvtm_plus_input "?UTF-8 encoded\n"
	dvtm_plus_input '^kvGk$'
	dvtm_plus_input 'y'
	rm -f "$FILENAME.copy"
	sh_cmd "vi $FILENAME.copy"
	dvtm_plus_input 'i'
	dvtm_plus_cmd 'p'
	dvtm_plus_input "${ESC}dd:wq\n"
	sleep 1
	dvtm_plus_cmd 'q'
	diff -u "$FILENAME" "$FILENAME.copy" 1>&2
	local RESULT=$?
	rm "$FILENAME.copy"
	return $RESULT
}

{
	echo "Testing $DVTM" 1>&2
	$DVTM -v 1>&2
	test_copymode && echo "copymode: OK" 1>&2 || echo "copymode: FAIL" 1>&2;
} 2> "$TEST_LOG" | $DVTM -m ^g 2> $LOG

cat "$TEST_LOG" && rm "$TEST_LOG" $LOG
