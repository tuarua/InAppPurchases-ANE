#!/bin/sh

AneVersion="1.1.0"
FreSwiftVersion="4.2.0"

rm -r tvos_dependencies/device

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/tvos_dependencies.zip
unzip -u -o tvos_dependencies.zip
rm tvos_dependencies.zip

wget https://github.com/tuarua/InAppPurchase-ANE/releases/download/$AneVersion/tvos_dependencies.zip
unzip -u -o tvos_dependencies.zip
rm tvos_dependencies.zip

wget -O ../native_extension/ane/InAppPurchaseANE.ane https://github.com/tuarua/InAppPurchases-ANE/releases/download/$AneVersion/InAppPurchaseANE.ane?raw=true
