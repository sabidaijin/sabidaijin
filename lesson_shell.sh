#!/bin/bash
# ================================================
# 📘 シェルスクリプトで学ぶ「検索・抽出・ログ解析」入門
# ================================================
# 使い方:
#   ./lesson.sh grep      → grepの章だけ実行
#   ./lesson.sh awk       → awkの章だけ実行
#   ./lesson.sh sed       → sedの章だけ実行
#   ./lesson.sh regex     → 正規表現の章を実行
#   ./lesson.sh redirect  → リダイレクトの章を実行
#   ./lesson.sh all       → 全章を順番に実行
# ================================================

CMD=$1 # 💡 変数定義：第1引数をCMDに格納
if [ -z "$CMD" ]; then
	echo "使い方: $0 [grep|awk|cut|sed|jq|head|tail|sort|uniq|wc|regex|redirect|all]"
	exit 1
fi

# --------------------------------------------------
# 📁 準備
# --------------------------------------------------
setup_data() {
	# 💡 -f はファイル存在チェック
	if [ ! -f sample.log ]; then
		echo "🪄 sample.log が見つかりません。新規作成します..."
		cat <<EOF >sample.log
2025-11-08 12:00:00 INFO  User alice logged in
2025-11-08 12:01:15 ERROR Failed to load module xyz
2025-11-08 12:02:30 INFO  User bob logged out
2025-11-08 12:03:45 WARNING Disk space low
2025-11-08 12:04:00 INFO  User charlie logged in
2025-11-08 12:05:10 INFO  User alice logged out
EOF
		# 💡 「cat <<EOF > ファイル名」はヒアドキュメント構文（複数行を一括出力）
	fi

	if [ ! -f sample.json ]; then
		echo "🪄 sample.json が見つかりません。新規作成します..."
		cat <<EOF >sample.json
{
  "users": [
    {"name": "alice", "role": "admin"},
    {"name": "bob", "role": "user"},
    {"name": "charlie", "role": "developer"}
  ]
}
EOF
	fi
}
setup_data

lesson_grep() {
	echo "==============================================="
	echo "🔍 grep の基本（検索コマンド）"
	echo "==============================================="
	echo "💡 grep [オプション] 'パターン' ファイル名"
	echo "   -n : 行番号表示   -i : 大文字小文字無視   -v : 含まない行を抽出"
	echo

	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "grep 'ERROR' sample.log"
	grep 'ERROR' sample.log
	echo

	echo "grep -n 'INFO' sample.log"
	grep -n 'INFO' sample.log
	echo

	echo "grep -i 'user' sample.log"
	grep -i 'user' sample.log
	echo

	echo "grep -v 'INFO' sample.log"
	grep -v 'INFO' sample.log
}

lesson_awk() {
	echo "==============================================="
	echo "🧮 awk の基本"
	echo "==============================================="
	echo "💡 awk 'パターン {アクション}' ファイル名"
	echo "   \$1, \$2 ... : 各列を表す変数"
	echo

	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "awk '{print \$3, \$4, \$5}' sample.log"
	awk '{print $3, $4, $5}' sample.log
	echo

	echo "awk '/ERROR/ {print \$1, \$2, \$5, \$6}' sample.log"
	awk '/ERROR/ {print $1, $2, $5, $6}' sample.log
}

lesson_cut() {
	echo "==============================================="
	echo "✂️ cut の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo
	echo "💡 cut -d[区切り文字] -f[列番号] ファイル名"
	echo

	echo

	echo "cut -d' ' -f1-3 sample.log"
	cut -d' ' -f1-3 sample.log
}

lesson_sed() {
	echo "==============================================="
	echo "🧹 sed の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "💡 sed 's/検索文字列/置換文字列/g' ファイル名"
	echo "💡 sed 'Nd' ファイル名  → N行目を削除"
	echo

	echo "sed 's/INFO/INFORMATION/g' sample.log"
	sed 's/INFO/INFORMATION/g' sample.log
	echo

	echo "sed '3d' sample.log"
	sed '3d' sample.log
	echo

	echo "sed -n '2,4p' sample.log"
	sed -n '2,4p' sample.log
}

lesson_jq() {
	echo "==============================================="
	echo "🪣 jq の基本（JSON処理）"
	echo "==============================================="

	echo "🧾 実行前データ:"
	cat sample.json
	echo

	echo "💡 jq 'フィルタ' ファイル名"
	echo

	echo "jq '.users[] | .name' sample.json"
	jq '.users[] | .name' sample.json
	echo

	echo "jq '.users[] | select(.role==\"admin\")' sample.json"
	jq '.users[] | select(.role==\"admin\")' sample.json
}
lesson_sort() {
	echo "==============================================="
	echo "🔢 sort の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "💡 基本: sort"
	echo "説明: 行をアルファベット順にソートします。"
	echo "💡 例: grep 'INFO' sample.log | awk '{print \$5}' | sort"
	grep 'INFO' sample.log | awk '{print $5}' | sort
	echo

	echo "💡 逆順ソート: sort -r"
	echo "💡 数値ソート: sort -n"
}

lesson_uniq() {
	echo "==============================================="
	echo "🔢 uniq の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "💡 基本: uniq"
	echo "説明: 連続する重複行をまとめます。"
	echo "💡 例: grep 'INFO' sample.log | awk '{print \$5}' | sort | uniq"
	grep 'INFO' sample.log | awk '{print $5}' | sort | uniq
	echo

	echo "💡 出現回数付き: uniq -c"
	echo "💡 重複のみ表示: uniq -d"
	grep 'INFO' sample.log | awk '{print $5}' | sort | uniq -c
}
lesson_wc() {
	echo "==============================================="
	echo "🔢 wc の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "💡 行数を数える: wc -l"
	wc -l sample.log
	echo

	echo "💡 単語数を数える: wc -w"
	wc -w sample.log
	echo

	echo "💡 文字数を数える: wc -c"
	wc -c sample.log
}

lesson_regex() {
	echo "==============================================="
	echo "🔤 正規表現（Regular Expression）の基本"
	echo "==============================================="
	echo "🧾 実行前データ:"
	cat sample.log
	echo

	echo "💡 基本的な正規表現例と意味"
	echo "-----------------------------------------------"
	echo "1. ^       : 行頭にマッチ"
	echo "2. \$       : 行末にマッチ"
	echo "3. .       : 任意の1文字"
	echo "4. *       : 直前の文字の0回以上の繰り返し"
	echo "5. +       : 直前の文字の1回以上の繰り返し"
	echo "6. ?       : 直前の文字の0回または1回"
	echo "7. [abc]   : aまたはbまたはc"
	echo "8. [0-9]   : 数字0-9"
	echo "9. [^0-9]  : 数字以外"
	echo "10. |      : OR（または）"
	echo "11. ()     : グループ化"
	echo "12. \\    : エスケープ（特殊文字を文字として扱う）"
	echo

	echo "💡 実例"

	echo "ERRORまたはWARNINGを抽出（grep -E 'ERROR|WARNING' sample.log）:"
	grep -E 'ERROR|WARNING' sample.log
	echo

	echo "数字だけを抽出（grep -E '[0-9]+' sample.log）:"
		grep -E '[0-9]+' sample.log
	echo
}

lesson_redirect() {
	echo "==============================================="
	echo "🔁 リダイレクトの基本"
	echo "==============================================="

	echo
	echo "💡 標準出力をファイルに書き込み: >"
	echo "-----------------------------------------------"
	echo "grep 'ERROR' sample.log > error.log"
	grep 'ERROR' sample.log >error.log
	echo "✅ error.log に出力しました:"
	cat error.log
	echo

	echo "💡 標準エラー出力をリダイレクト（例: ls 不在ファイル 2> error.txt）"
	echo "-----------------------------------------------"
	ls no_such_file 2>error.txt
	echo "✅ error.txt の内容:"
	cat error.txt
	echo

	echo "💡 標準出力と標準エラーをまとめてリダイレクト: &>"
	echo "-----------------------------------------------"
	echo "ls no_such_file existing_file &> both.txt"
	touch existing_file
	ls no_such_file existing_file &>both.txt
	echo "✅ both.txt の内容:"
	cat both.txt
	echo

	echo "💡 標準出力(1)と標準エラー(2)を別々に扱う: >1.txt 2>2.txt"
	echo "-----------------------------------------------"
	echo "ls no_such_file existing_file >out.txt 2>error.txt"
	ls no_such_file existing_file >out.txt 2>error.txt
	echo "✅ out.txt:"
	cat out.txt
	echo
	echo "✅ error.txt:"
	cat error.txt
	echo

	echo "💡 標準エラーを標準出力に結合: 2>&1"
	echo "-----------------------------------------------"
	echo "ls no_such_file existing_file >combined.txt 2>&1"
	ls no_such_file existing_file >combined.txt 2>&1
	echo "✅ combined.txt の内容:"
	cat combined.txt
	echo

	echo "💡 入力リダイレクト: <"
	echo "-----------------------------------------------"
	echo "wc -l < sample.log"
	wc -l <sample.log
	echo

	rm  ./error.txt ./both.txt ./combined.txt ./error.log  ./out.txt ./existing_file 
}

# --------------------------------------------------
# 🎬 実行制御
# --------------------------------------------------
case "$CMD" in
grep) lesson_grep ;;
awk) lesson_awk ;;
cut) lesson_cut ;;
sed) lesson_sed ;;
jq) lesson_jq ;;
sort) lesson_sort ;;
uniq) lesson_uniq ;;
wc) lesson_wc ;;
regex) lesson_regex ;;
redirect) lesson_redirect ;;
all)
	lesson_grep
	lesson_awk
	lesson_cut
	lesson_sed
	lesson_jq
	lesson_sort
	lesson_uniq
	lesson_wc
	lesson_regex
	lesson_redirect
	;;
*)
	echo "不明なコマンド: $CMD"
	echo "使用可能: grep awk cut sed jq sort uniq wc regex redirect all"
	;;
esac
