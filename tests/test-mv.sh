#! /bin/bash

aug_mv() {
(augtool -r /dev/null | grep -v '/augeas\|augtool' | tr '\n' ' ') <<EOF
set /a/b/c value
mv /a/b/c $1
print
EOF
}

assert_eq() {
    msg=$1
    if [ "$ACT" != "$EXP" ] ; then
        echo "Failed: aug_mv $msg"
        echo "Expected: <$EXP>"
        echo "Actual  : <$ACT>"
        exit 1
    fi

}

ACT=$(aug_mv /x)
EXP='/a /a/b /x = "value" '
assert_eq /x

ACT=$(aug_mv /x/y)
EXP='/a /a/b /x /x/y = "value" '
assert_eq /x/y

ACT=$(aug_mv /a/x)
EXP='/a /a/b /a/x = "value" '
assert_eq /a/x

# Check that we don't move into a descendant
ACT=$(aug_mv /a/b/c/d)
EXP='Failed /a /a/b /a/b/c = "value" /a/b/c/d '
assert_eq /a/b/c/d

ACT=$(aug_mv /a/b/d)
EXP='/a /a/b /a/b/d = "value" '
assert_eq /a/b/d