#!/usr/bin/env bash

set -o pipefail

VERSION=1.1
DEFAULT_META_IMAGE=wildducktheories/y2j
META_IMAGE=${META_IMAGE:-${DEFAULT_META_IMAGE}}

die() {
	echo "$*" 1>&2
	exit 1
}

usage() {
	cat <<EOF
y2j.sh
	installer {install-dir}
	version

yaml to json:
	y2j < yaml > json
	j2y -d < yaml > json

json to yaml:
	j2y < json > yaml
	y2j -d < json > yaml

filtered yaml:
	yq {jq-filter} < yaml > yaml
EOF
}

installer() {
	local target=${1:-/usr/local/bin}

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
	local target=\${1:-${target}}
	(
		base64 -D <<EOF_EOF
$(sed "s|^\(DEFAULT_META_IMAGE=\).*|\1${META_IMAGE}|" < "$BASH_SOURCE" | base64)
EOF_EOF
	) | tee \${target}/y2j.sh >/dev/null &&
	chmod ugo+x \${target}/y2j.sh &&
	ln -sf y2j.sh \${target}/y2j &&
	ln -sf y2j.sh \${target}/j2y &&
	ln -sf y2j.sh \${target}/yq &&
	echo "Installed \${target}/{y2h.sh,y2j,j2y,yq}."
}
install "\$@"
EOF
}

version() {
	echo "y2j.sh-${VERSION}"
}


python() {
	PYTHON=$(which python 2>/dev/null)
	if test -n "$PYTHON" && $PYTHON -c 'import sys, yaml, json;' 2>/dev/null; then
		$PYTHON "$@"
	else
		docker run --rm -i ${META_IMAGE} python "$@"
	fi
}

jq() {
	JQ=$(which jq 2>/dev/null)
	if test -n "$JQ"; then
		"$JQ" "$@"
	else
		docker run --rm -i ${META_IMAGE} jq "$@"
	fi
}

y2j() {
	if test "$1" = "-d"; then
		shift 1
		j2y "$@"
	else
		python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' | (
			if test $# -gt 0; then
				jq "$@"
			else
				cat
			fi
		)
	fi
}

j2y() {
	if test "$1" = "-d"; then
		shift 1
		y2j "$@"
	else
		(
			if test $# -gt 0; then
				jq "$@"
			else
				cat
			fi
		) | python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
	fi
}

y2j_sh() {
	cmd=$1
	shift 1
	case "$cmd" in
		installer|version|j2y|y2j|yq)
			"$cmd" "$@"
		;;
		*)
			usage
		;;
	esac
}

yq() {
	test $# -gt 0 || die "usage: yq {jq-filter}"
	y2j | jq "$@" | j2y
}

case $(basename "$0") in
	y2j.sh)
		y2j_sh "$@"
	;;
	j2y)
		j2y "$@"
	;;
	y2j)
		y2j "$@"
	;;
	yq)
		yq "$@"
	;;
	*)
		die "unable to determine execution mode - check the name of script - '$(dirname $0)'"
	;;
esac
