#!/bin/bash
# source-code-collector.sh

# デフォルトの出力ファイル名
output_file="collected-source-code.md"

# ヘルプメッセージの表示
echo_usage() {
  echo "Usage: repo_snapshot.sh [-o <output_file>] [input_file1] [input_file2]..."
  echo "  -o <output_file> (Optional) Specify the output file. Default is ${output_file}"
  echo "  -h Show this help message and exit"
  echo "i.e.) repo_snapshot.sh -o summary.md README.md src/pages/*.py"
}

# オプション解析
while getopts "o:h" opt; do
  case $opt in
    o)
      output_file="$OPTARG"
      ;;
    h)
      echo_usage
      exit 0
      ;;
    \?)
      echo "不正なオプション: -$OPTARG" >&2
      echo_usage
      exit 1
      ;;
    :)
      echo "オプション -$OPTARG には引数が必要です。" >&2
      echo_usage
      exit 1
      ;;
  esac
done

# オプション解析後の引数の開始位置を調整
shift $((OPTIND - 1))

# README.mdファイルが引数に含まれているか確認
has_readme=false
for file in "$@"; do
  if [ "$file" = "README.md" ]; then
    has_readme=true
    break
  fi
done

# README.mdファイルが存在する場合、最初に追加
if [ -f "README.md" ] && [ "$has_readme" = false ]; then
  echo "README.mdを最初に追加します。"
  cat README.md > "$output_file"
  echo "---" >> "$output_file"
fi

# 入力ファイルを処理
for file in "$@"; do
  # ファイルの存在チェック
  if [ ! -e "$file" ]; then
    echo "ファイルが存在しません: $file" >&2
    continue
  fi

  # ファイルの種類をチェック
  if [ -d "$file" ]; then
    echo "ディレクトリをスキップ: $file"
    continue
  fi

  echo "---" >> "$output_file"
  echo "## ファイル: $file" >> "$output_file"
  cat "$file" >> "$output_file"
  echo " " >> "$output_file"  # ファイルの区切りとして空行を挿入
done

echo "すべてのファイルが $output_file に結合されました。"
