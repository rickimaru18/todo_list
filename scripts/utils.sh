#!/bin/bash

#--------------------------------------------------------------
if [ "$1" == "deintegrate" ] ; then
    echo ">>>>> Deintegrate pods..."
    flutter clean && cd ios && rm -rf Pods Podfile.lock .symlinks && flutter pub get && pod deintegrate && pod install && cd ..
elif [ "$1" == "parts" ] ; then
    echo ">>>>> Regenerate part files..."
    flutter pub run build_runner build --delete-conflicting-outputs
else
    echo "Invalid argument \"$1\"".
fi

