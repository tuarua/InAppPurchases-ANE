# InAppPurchases-ANE

Use StoreKit and BillingClient with this Adobe Air Native Extension for iOS 9.0+, tvOS 9.2+,macOS 10.12+ and Android 19+.    

-------------
## Prerequisites

You will need:

- IntelliJ IDEA
- AIR 33.1.1.217+
- [.Net Core Runtime](https://dotnet.microsoft.com/download/dotnet-core/3.1)
- [AIR-Tools](https://github.com/tuarua/AIR-Tools/)

-------------

## Android

cd into /example-mobile and run the _"air-tools"_ command (You will need [AIR-Tools](https://github.com/tuarua/AIR-Tools/) installed)

```shell
air-tools install
```
-------------

## iOS


>N.B. You must use a Mac to build an iOS app using this ANE. Windows is **NOT** supported.

This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.

-------------

## tvOS

>N.B. You must use a Mac to build an iOS app using this ANE. Windows is **NOT** supported.

This folder, tvos_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.


### App Setup

As per iOS above.

## macOS

### The ANE + Dependencies

From the command line cd into /example-desktop and run:

```shell
air-tools install
```

### App Setup

As per iOS above.


### References
* [https://github.com/bizz84/SwiftyStoreKit]
* [https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started]
* [https://developer.android.com/google/play/billing/billing_overview]
