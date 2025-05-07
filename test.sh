#!/bin/bash

make re

test -f checker || wget -O checker https://cdn.intra.42.fr/document/document/33389/checker_linux

ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); echo "${ARG[@]}"; ./push_swap "${ARG[@]}"
# ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); echo $ARG; ./push_swap $ARG | tee >(cat) | ./checker $ARG
# ruby -e 'N = 100; (1..N).to_a.permutation.each{ |arr| puts "[#{arr * ", "}]"; `./push_swap #{arr * " "} > res`; puts `./checker #{arr * " "}; wc -l res`  }'
# ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); ./push_swap $ARG | tee >(wc -l) | ./checker $ARG
