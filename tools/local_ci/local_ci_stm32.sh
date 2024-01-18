#! /usr/bin/bash

echo "PORT: stm32 CI"
source tools/ci.sh


# ports/stm32
function ci_stm32_pyb_build_remote {
    make ${MAKEOPTS} -C mpy-cross
    SUBMODULES="lib/libhydrogen lib/stm32lib lib/micropython-lib"

    git submodule sync $SUBMODULES
    git submodule update --init $SUBMODULES

    make ${MAKEOPTS} -C ports/stm32 BOARD=PYBV11 -j8
}

make -C ports/stm32 clean BOARD=PYBV11
ci_stm32_pyb_build_remote

PYBOARD_TEST="True"
PYBOARD_FLASH="True"
source .env 
if test "$PYBOARD_FLASH" == "True";
    then
        echo "Flashing firmware"
        tools/mpremote/mpremote.py bootloader
        sleep 2
        make -C ports/stm32 BOARD=PYBV11 deploy
        sleep 3
else 
    echo "PORT: stm32 flashing SKIP"
fi

echo "Running tests..."
tools/device_test_runner.py pyboard
