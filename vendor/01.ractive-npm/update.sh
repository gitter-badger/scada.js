#!/bin/bash
#
# Usage:
#
#     ./update.sh [0.10.2]
#

DIR=$(dirname "$(readlink -f "$0")")

cd "$DIR/../.."
RACTIVE_VERSION=${1:-"latest"}

echo "Updating Ractive to: $RACTIVE_VERSION"

npm i --save ractive@$RACTIVE_VERSION

cd $DIR
export NODE_MODULES=$(realpath "$DIR/../../node_modules")
echo "updating ractive from this node modules"

# Create bundle
browserify -t browserify-livescript ractive-npm.ls -o ractive-latest.js

# Create a temporary warning to console
cat <<WARNING > tmp-warning.js
(function (global, factory) {
	typeof exports === 'object' && typeof module !== 'undefined' ? factory() :
	typeof define === 'function' && define.amd ? define(factory) :
	(factory());
}(this, (function () { 'use strict';
    console.warn("-------------------------- IMPORTANT WARNING ---------------------------------------")
    console.warn("RACTIVE IS UPDATED. TEST WEBAPP IF IT CAN BE VIEWED CORRECTLY ON MOBILE/OLD DEVICES.");
    console.warn("Then remove this file.")
    console.warn("-------------------------- /IMPORTANT WARNING ---------------------------------------")
})));
WARNING