#!/usr/bin/env bash
# Tree構造 -> フルパス一覧 変換スクリプト
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [tree_output_file|stdin]
ex.
  ./tree2path.sh tree.txt
  tree src | ./tree2path.sh
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
elif [ $# -ge 1 ] && [ ! -f "$1" ]; then
  echo "Error: File not found: $1" >&2
  usage
  exit 1
fi

# main routine
input="${1:-/dev/stdin}"

# 罫線記号(│ ├ └ ─)をASCII1文字に正規化してからawkへ渡す
# (awk実装によってはマルチバイト文字のlength()がずれるため)
sed -e 's/│/|/g' -e 's/├/+/g' -e 's/└/+/g' -e 's/─/-/g' "$input" | awk '
{
  line = $0
  if (line ~ /^Directory structure:/) next
  if (line ~ /^[[:space:]]*$/) next

  if (match(line, /(\+-- )/) == 0) next

  prefix = substr(line, 1, RSTART-1)
  name   = substr(line, RSTART+RLENGTH)

  depth = length(prefix) / 4

  is_dir = (name ~ /\/$/)
  gsub(/\/$/, "", name)

  stack[depth] = name

  if (!is_dir) {
    path = ""
    for (i = 0; i <= depth; i++) {
      path = path stack[i] "/"
    }
    sub(/\/$/, "", path)
    print path
  }
}'

