#! /usr/bin/bash

echo "PORT: esp32 CI"
source tools/ci.sh

# ports/esp32

# GitHub tag of ESP-IDF to use for CI (note: must be a tag or a branch)
IDF_VER=v5.0.4

export IDF_CCACHE_ENABLE=1

function ci_esp32_idf_setup {
    pip3 install pyelftools
    git clone --depth 1 --branch $IDF_VER https://github.com/espressif/esp-idf.git
    # doing a treeless clone isn't quite as good as --shallow-submodules, but it
    # is smaller than full clones and works when the submodule commit isn't a head.
    git -C esp-idf submodule update --init --recursive --filter=tree:0
    # GIT_DIR="${PWD}/esp-idf/.git" esp-idf/install.sh
}

function ci_esp32_build_remote {
    # source esp-idf/export.sh
    make ${MAKEOPTS} -C mpy-cross
    SUBMODULES="lib/berkeley-db-1.xx lib/micropython-lib"

    git submodule sync $SUBMODULES
    git submodule update --init $SUBMODULES

    GIT_DIR="${PWD}/esp-idf/.git" make ${MAKEOPTS} -C ports/esp32 -j8
}
export IDF_PATH="$PWD/esp-idf"
export PATH="$IDF_PATH/tools:${PATH}"
# echo $PATH
# GIT_WORK_TREE="$PWD/esp-idf" 

# TODO: check if esp-idf exists.

# ci_esp32_idf_setup # uncomment if there is no idf setup yet
GIT_DIR="${PWD}/esp-idf/.git" esp-idf/install.sh
GIT_DIR="${PWD}/esp-idf/.git" . esp-idf/export.sh
echo "IDF_PATH:" $IDF_PATH
# idf_tools.py list
GIT_DIR="${PWD}/esp-idf/.git" make -C ports/esp32 clean

ci_esp32_build_remote

ESP32_FLASH="True"
ESP32_TEST="True"
source .env
if test "$ESP32_FLASH" == "True";
    then
        echo "Flashing firmware"
        GIT_DIR="${PWD}/esp-idf/.git" make -C ports/esp32 PORT=$ESP32_DEVICE deploy 
        sleep 3
else 
    echo "PORT: esp32 flashing SKIP"
fi
echo "Running tests..."
tools/device_test_runner.py esp32

