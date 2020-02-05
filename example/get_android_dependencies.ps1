$AneVersion = "1.0.0"
$FreKotlinVersion = "1.9.1"
$SupportV4Version = "1.0.0"
$KotlinxCoroutinesVersion = "1.2.2"
$GsonVersion = "2.8.6"
$BillingVersion="2.1.0"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/tuarua/InAppPurchases-ANE/releases/download/$AneVersion/InAppPurchaseANE.ane?raw=true -OutFile "$currentDir\..\native_extension\ane\InAppPurchaseANE.ane"
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\androidx.legacy.legacy-support-v4-$SupportV4Version.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.tuarua.frekotlin-$FreKotlinVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.android.billingclient.billing-$BillingVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/com.android.billingclient.billing-$BillingVersion.ane?raw=true
Invoke-WebRequest -OutFile "$currentDir\android_dependencies\com.google.code.gson.gson-$GsonVersion.ane" -Uri https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
