#!/usr/bin/env bash

META_IMAGE=${META_IMAGE:-wildducktheories/y2j}
BASE64=$(which base64 2>/dev/null)
PYTHON=$(which python 2>/dev/null)

die() {
	echo "$*" 1>&2
	exit 1
}

installer() {
	cat <<EOF
#!/bin/bash
base64() {
	META_IMAGE=${META_IMAGE}
	BASE64=\$(which base64 2>/dev/null)
	if test -n "\$BASE64"; then
		\$BASE64 "\$@"
	else
		docker run --rm -i \${META_IMAGE} base64 "\$@"
	fi
}
install() {
	local target=\${1:-${INSTALL_DIR:-/usr/local/bin}}
	(
		base64 -D <<EOF_EOF
$(cat "$BASH_SOURCE" | base64)
EOF_EOF
	) | sudo tee \${target}/y2j.sh >/dev/null &&
	sudo chmod ugo+x \${target}/y2j.sh &&
	sudo ln -sf y2j.sh \${target}/y2j &&
	sudo ln -sf y2j.sh \${target}/j2y &&
	echo "Installed \${target}/{y2h.sh,y2j,j2y}."
}
install "\$@"
EOF
}


python() {
	if test -n "$PYTHON" && $PYTHON -c 'import sys, yaml, json;' 2>/dev/null; then
		$PYTHON "$@"
	else
		docker run --rm -i ${IMAGE} python "$@"
	fi
}

y2j() {
	if test "$1" = "-d"; then
		shift 1
		j2y "$@"
	elif test "$1" = "installer"; then
		installer
	else
		python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)'
	fi
}

j2y() {
	if test "$1" = "-d"; then
		shift 1
		y2j "$@"
	elif test "$1" = "installer"; then
		installer
	else
		python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
	fi
}

case $(basename "$0" .sh) in
	j2y)
		j2y "$@"
		exit $?
	;;
	y2j)
		y2j "$@"
		exit $?
	;;
	*)
		die "unable to determine mode - check name of script - '$(dirname $0)'"
	;;
esac
