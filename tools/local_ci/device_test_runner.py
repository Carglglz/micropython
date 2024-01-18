#!/usr/bin/env python3

import shlex
import sys
import os
import subprocess
import ast


TARGET = sys.argv.pop()

DEVICE = os.getenv(f"{TARGET.upper()}_DEVICE", "/dev/ttyUSB0")

TEST_DEVICE = ast.literal_eval(os.getenv(f"{TARGET.upper()}_TEST", "True"))

CMD_TESTS = shlex.split(f"./run-tests.py --target {TARGET} --device {DEVICE}")

if TEST_DEVICE:
    subprocess.run(CMD_TESTS, cwd="tests")
else:
    subprocess.run(["echo", "PORT:", TARGET, "TESTS: SKIP"])

# TODO: add run-multitest.py for devices


# run other tests depending on device or custom tests
