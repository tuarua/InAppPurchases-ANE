/* Copyright 2019 Tua Rua Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

package com.tuarua.iap.storekit {
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