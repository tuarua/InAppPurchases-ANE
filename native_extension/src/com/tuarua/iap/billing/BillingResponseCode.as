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

package com.tuarua.iap.billing {
public final class BillingResponseCode {
    public static const serviceTimeout:int = -3;
    public static const featureNotSupported:int = -2;
    public static const serviceDisconnected:int = -1;
    public static const ok:int = 0;
    public static const userCancelled:int = 1;
    public static const serviceUnavailable:int = 2;
    public static const billingUnavailable:int = 3;
    public static const itemUnavailable:int = 4;
    public static const developerError:int = 5;
    public static const error:int = 6;
    public static const itemAlreadyOwned:int = 7;
    public static const itemNotOwned:int = 8;
    public static function asString(code:int):String {
        switch (code) {
            case serviceTimeout:
                return "service timeout";
            case featureNotSupported:
                return "feature not supported";
            case serviceDisconnected:
                return "service disconnected";
            case ok:
                return "ok";
            case userCancelled:
                return "user cancelled";
            case serviceUnavailable:
                return "service unavailable";
            case billingUnavailable:
                return "billing unavailable";
            case itemUnavailable:
                return "item unavailable";
            case developerError:
                return "developer error";
            case error:
                return "error";
            case itemAlreadyOwned:
                return "item already owned";
            case itemNotOwned:
                return "item not owned";
            default:
                return "unknown";
        }
    }
}
}