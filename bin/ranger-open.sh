#!/bin/sh

rangeropen() {
	TMP_DIR="$(mktemp -t ranger_open.XXX)"
	echo $TMP_DIR
	RANGER_BIN="$(which ranger)"
	$RANGER_BIN --choosefile="$TMP_DIR"
	cat "$TMP_DIR"
	# nohup xdg-open $(cat $TMP_DIR); rm $TMP_DIR &
	nohup xdg-open $(cat $TMP_DIR) &
	sleep 0.05
	rm "$TMP_DIR"
}

rangeropen
