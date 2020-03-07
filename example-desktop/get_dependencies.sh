#!/bin/sh

AneVersion="1.2.0"
FreSwiftVersion="4.3.0"

wget -O ../native_extension/ane/FreSwift.ane https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/FreSwift.ane?raw=true
wget -O ../native_extension/ane/InAppPurchaseANE.ane https://github.com/tuarua/InAppPurchases-ANE/releases/download/$AneVersion/InAppPurchaseANE.ane?raw=true
