#! /bin/bash
#
# TODO: adapt Mosfit's test.sh to properly work around mpich's bug and reduce
# the test suite to something that can be run in the 120-minute time limit of
# Circle CI.

set -xeuo pipefail

function my_mpirun() {
    # Work around bug in mpich mpirun that leaves stdin/stdout
    # with the O_NONBLOCK flag set, which causes problems in various
    # contexts -- but not always, since bash sometimes clears the
    # flag after the program is run.
    mpirun "$@" </dev/null 2>&1 |cat
}

my_mpirun -np 2 python -m mosfit -e mosfit/tests/LSQ12dlf.json --test -i 1 -f 1 -p 0 -F covariance
python -m mosfit -e mosfit/tests/SN2006le.json --test -i 1 --no-fracking -m ic
python -m mosfit --test -i 0
python -m mosfit -i 0 -m default -P parameters_test.json
