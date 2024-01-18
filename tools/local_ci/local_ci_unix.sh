#! /usr/bin/bash

echo "PORT: unix CI"
source tools/ci.sh


# ports/unix
function ci_unix_build_helper_remote {
    make ${MAKEOPTS} -C mpy-cross
    SUBMODULES="lib/mbedtls lib/micropython-lib lib/berkeley-db-1.xx" 
    git submodule sync $SUBMODULES
    git submodule update --init $SUBMODULES
    make ${MAKEOPTS} -C ports/unix "$@" deplibs
    make ${MAKEOPTS} -C ports/unix "$@" -j8
}

function ci_unix_standard_build_remote {
    ci_unix_build_helper_remote VARIANT=standard
    ci_unix_build_ffi_lib_helper gcc
}


make -C ports/unix clean
ci_unix_standard_build_remote
echo "Running tests..."
ci_unix_standard_run_tests

