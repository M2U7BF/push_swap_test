#!bin/bash

make re

ARG=(`ruby -e 'print (1..10).to_a.shuffle * " "'`); echo "${ARG[@]}"; ./push_swap "${ARG[@]}"
# ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); echo $ARG; ./push_swap $ARG | tee >(cat) | ./checker $ARG
# ruby -e 'N = 100; (1..N).to_a.permutation.each{ |arr| puts "[#{arr * ", "}]"; `./push_swap #{arr * " "} > res`; puts `./checker #{arr * " "}; wc -l res`  }'
# ARG=(`ruby -e 'print (1..100).to_a.shuffle * " "'`); ./push_swap $ARG | tee >(wc -l) | ./checker $ARG
