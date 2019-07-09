package com.tuarua.iap {
public class PurchaseError extends Error {
    public static const unknown:uint = 0;
    // client is not allowed to issue the request, etc.
    public static const clientInvalid:uint = 1;
    // user cancelled the request, etc.
    public static const paymentCancelled:uint = 2;
    // purchase identifier was invalid, etc.
    public static const paymentInvalid:uint = 3;
    // this device is not allowed to make the payment
    public static const paymentNotAllowed:uint = 4;
    // Product is not available in the current storefront
    public static const storeProductNotAvailable:uint = 5;
    // user has not allowed access to cloud service information
    public static const cloudServicePermissionDenied:uint = 6;
    // the device could not connect to the network
    public static const cloudServiceNetworkConnectionFailed:uint = 7;
    // user has revoked permission to use this cloud service
    public static const cloudServiceRevoked:uint = 8;

    public function PurchaseError(message:* = "", id:* = 0) {
        super(message, id);
    }
}
}