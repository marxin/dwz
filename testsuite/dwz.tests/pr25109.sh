cp $execs/no-multifile-prop 1
cp 1 2

dwz -m 3 1 2

rm -f 1 2 3
