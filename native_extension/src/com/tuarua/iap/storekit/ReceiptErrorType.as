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
public final class ReceiptErrorType {
    /** No receipt data */
    public static const noReceiptData:uint = 0;
    /** No data received */
    public static const noRemoteData:uint = 1;
    /** Error when encoding HTTP body into JSON */
    public static const requestBodyEncodeError:uint = 2;
    /** Error when proceeding request */
    public static const networkError:uint = 3;
    /** Error when decoding response */
    public static const jsonDecodeError:uint = 4;
    /** Receive invalid - bad status returned */
    public static const receiptInvalid:uint = 5;
}
}