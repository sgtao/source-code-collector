# source-code-collector

## 概要
- このリポジトリは、複数のソースファイルやREADME.mdをまとめてMarkdown形式で出力するシェルスクリプトを提供します。  
  - ディレクトリは自動でスキップされ、ファイル単位で結合されます。
  - ファイル `README.md` は、常に最初のファイルとしてまとめられます（ディフォルト機能）

## 使用例
```sh
# mkdir builds # for output
./source-code-collector.sh -o builds/summary.md source-code-collector.sh
# README.mdを最初に追加します。
# すべてのファイルが builds/summary.md に結合されました。
```

## オプション
- `-o ` : 出力ファイル名（デフォルト: collected-source-code.md）
- `-h` : ヘルプメッセージ

## ライセンス
MIT License
