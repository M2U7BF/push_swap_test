#!/bin/bash

make fclean
make debug

test -f checker || wget -O checker https://cdn.intra.42.fr/document/document/33389/checker_linux
chmod +x checker

# テストのフラグ
error_test=1
leak_test=1
random_test=1
tester_test=1

if [ $error_test -eq 1 ]; then
  echo "==================== エラー出力テスト（基本）"
  # 2>&1: 標準エラーを標準出力にリダイレクト
  # 1>/dev/null: 標準出力を捨てる
  stderr_output=$(cat <<< $(./push_swap abc 2>&1 1>/dev/null) | cat -e)
  if [ "$stderr_output" != "Error$" ]; then
    echo "NG, output:[$stderr_output], expected:[Error$]"
  else
    echo "OK"
  fi
fi

if [ $leak_test -eq 1 ]; then
  echo "==================== valgrindによるメモリリークテスト（valgrindの出力がなければOK）"
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 41 42tokyo
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 1 2 3 3 4 5
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 1 2 3 4 5 3
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 2147483648
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap -2147483649
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 42
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 2 3
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 0 1 2 3
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 0 1 2 3 4 5 6 7 8 9
  valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap 0 3 6 7 9
  ARG=(`ruby -e 'print (-50..50).to_a.shuffle * " "'`); valgrind --leak-check=full --show-leak-kinds=all -q ./push_swap "${ARG[@]}" | grep -Ev '^(sa|sb|ss|ra|rb|rr|rra|rrb|rrr|pb|pa)$'
fi

if [ $random_test -eq 1 ]; then
  echo "==================== ランダムテスト"
  OUT_FILE="result_$(date +%Y%m%d).txt"
  echo "" > $OUT_FILE

  random_test() {
    OUT_FILE="result_$(date +%Y%m%d).txt"
    echo "出力はこちら: $OUT_FILE"

    ARG=($1)
    echo "${ARG[@]}" >> "$OUT_FILE"
    
    ./push_swap "${ARG[@]}" | tee -a "$OUT_FILE" | ./checker "${ARG[@]}"
  }

  random_test "$(ruby -e "puts (1..100).to_a.shuffle.join(' ')")"
  random_test "-710274644 1024770161 2074782735 -727596888 644483656"
  random_test "$(ruby -e "puts (50..50).to_a.shuffle.join(' ')")"
  random_test "$(ruby -e "puts (-100..1).to_a.shuffle.join(' ')")"
fi

if [ $tester_test -eq 1 ]; then
  # テスターによるテスト
  test -d push_swap_tester || git clone https://github.com/nafuka11/push_swap_tester
  echo "==================== テスターのテスト（https://github.com/nafuka11/push_swap_tester）"
  cd push_swap_tester
  python3 push_swap_tester.py -l 1 -c 1000
  echo ""
  echo ""
  python3 push_swap_tester.py -l 2 -c 1000
  echo ""
  echo ""
  python3 push_swap_tester.py -l 3 -c 1000
  echo ""
  echo ""
  python3 push_swap_tester.py -l 4 -c 1000
  echo ""
  echo ""
  echo "引数5個が手数12以下か。"
  MAX_5=$(HOGE=$(python3 push_swap_tester.py -l 5 -c 1000 | grep "max"); echo ${HOGE:8:10})
  if [ $MAX_5 -gt 12 ]; then
    echo "NG. max:$MAX_5, (ログ:$(pwd)/result.log)"
  else
    echo "OK"
  fi
  echo ""
  echo ""
  python3 push_swap_tester.py -l 100 -c 100

  cd - 1>/dev/null
fi
