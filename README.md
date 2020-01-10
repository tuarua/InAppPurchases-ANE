# InAppPurchases-ANE

Use StoreKit and BillingClient with this Adobe Air Native Extension for iOS 9.0+ and Android 19+.    

-------------

### AIR 32 or 33
This ANE is built against AIR 33 SDK. 

## Android

#### The ANE + Dependencies

cd into /example and run:
- macOS (Terminal)
```shell
bash get_android_dependencies.sh
```
- Windows Powershell
```shell
get_android_dependencies.ps1
```

```xml
<extensions>
<extensionID>com.tuarua.frekotlin</extensionID>
<extensionID>com.google.code.gson.gson</extensionID>
<extensionID>com.android.billingclient.billing</extensionID>
<extensionID>androidx.legacy.legacy-support-v4</extensionID>
<extensionID>org.jetbrains.kotlinx.kotlinx-coroutines-android</extensionID>
<extensionID>com.tuarua.InAppPurchaseANE</extensionID>
...
</extensions>
```

You will also need to include the following in your app manifest. Update accordingly.

```xml
<manifest android:installLocation="auto">
    <uses-sdk android:minSdkVersion="19" android:targetSdkVersion="28" />
    <uses-permission android:name="com.android.vending.BILLING" />
    ...
    <application>
        <meta-data
            android:name="com.google.android.play.billingclient.version"
            android:value="2.1.0" />
        <activity
            android:name="com.android.billingclient.api.ProxyBillingActivity"
            android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />
            ...
    </application>

</manifest>
```

-------------

## iOS

#### The ANE + Dependencies

N.B. You must use a Mac to build an iOS app using this ANE. Windows is NOT supported.
N.B. This ANE uses FreSwift 4.2. Other ANEs (WebViewANE, Firebase, etc) are not yet aligned to this version; Waiting on Harman to update iOS SDK to iOS 13.x

From the command line cd into /example and run:

```shell
bash get_ios_dependencies.sh
```

This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.   


### Prerequisites

You will need:

- IntelliJ IDEA
- AIR 330.2.338 or greater
- Android Studio 3.5 if you wish to edit the Android source
- Xcode 11.3
- [wget](http://rudix.org/packages/wget.html) on macOS
- Powershell on Windows

### References
* [https://github.com/bizz84/SwiftyStoreKit]
* [https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started]
* [https://developer.android.com/google/play/billing/billing_overview]
