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
public final class ReceiptStatus {
    /** Not decodable status */
    public static const unknown:int = -2;
    /** No status returned */
    public static const none:int = -1;
    /** valid statu */
    public static const valid:int = 0;
    /** The App Store could not read the JSON object you provided. */
    public static const jsonNotReadable:int = 21000;
    /** The data in the receipt-data property was malformed or missing. */
    public static const malformedOrMissingData:int = 21002;
    /** The receipt could not be authenticated. */
    public static const receiptCouldNotBeAuthenticated:int = 21003;
    /** The shared secret you provided does not match the shared secret on file for your account. */
    public static const secretNotMatching:int = 21004;
    /** The receipt server is not currently available. */
    public static const receiptServerUnavailable:int = 21005;
    /** This receipt is valid but the subscription has expired. When this status code is returned to your server,
     * the receipt data is also decoded and returned as part of the response. */
    public static const subscriptionExpired:int = 21006;
    /**  This receipt is from the test environment, but it was sent to the production environment for verification.
     * Send it to the test environment instead. */
    public static const testReceipt:int = 21007;
    /** This receipt is from the production environment, but it was sent to the test environment for verification.
     * Send it to the production environment instead. */
    public static const productionEnvironment:int = 21008;
}
}