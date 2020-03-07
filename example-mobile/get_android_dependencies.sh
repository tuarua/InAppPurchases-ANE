#!/bin/sh

AneVersion="1.2.0"
FreKotlinVersion="1.9.5"
KotlinxCoroutinesVersion="1.3.3"
SupportV4Version="1.0.0"
GsonVersion="2.8.6"
BillingVersion="2.1.0"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-${SupportV4Version}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-${GsonVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-${GsonVersion}.ane?raw=true
wget -O android_dependencies/com.android.billingclient.billing-${BillingVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.android.billingclient.billing-${BillingVersion}.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-${KotlinxCoroutinesVersion}.ane?raw=true
wget -O ../native_extension/ane/InAppPurchaseANE.ane https://github.com/tuarua/InAppPurchases-ANE/releases/download/$AneVersion/InAppPurchaseANE.ane?raw=true
