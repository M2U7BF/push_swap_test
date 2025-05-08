#!/bin/bash

make re

test -f checker || wget -O checker https://cdn.intra.42.fr/document/document/33389/checker_linux
chmod +x checker

# メモリリークテスト
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

# ランダムテスト
OUT_FILE="result_$(date +%Y%m%d%H%M%S).txt"
ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); echo "${ARG[@]}" | tee -a $ $OUT_FILE | ./push_swap "${ARG[@]}" | tee -a $OUT_FILE | ./checker $ARG
ARG=(`ruby -e 'print (-50..50).to_a.shuffle * " "'`); echo "${ARG[@]}" | tee -a $ $OUT_FILE | ./push_swap "${ARG[@]}" | tee -a $OUT_FILE | ./checker $ARG
ARG=(`ruby -e 'print (-100..0).to_a.shuffle * " "'`); echo "${ARG[@]}" | tee -a $ $OUT_FILE | ./push_swap "${ARG[@]}" | tee -a $OUT_FILE | ./checker $ARG
