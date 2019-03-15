cp ../hello 1

if dwz -L0 1 2>dwz.err; status=?; then
    true
fi

if ! grep -q "Too many DIEs, not optimizing" dwz.err; then
    cat dwz.err
    exit 1
fi

[ $status -eq 1 ]

cmp 1 ../hello

rm -f 1 dwz.err
