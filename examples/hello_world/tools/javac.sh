#!/usr/bin/env bash

set -eu

exec /usr/local/java-runtime/impl/17/bin/javac -J-Xss4M "$@"
