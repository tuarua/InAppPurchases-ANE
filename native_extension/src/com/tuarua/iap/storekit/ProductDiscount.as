/* Copyright 2018 Tua Rua Ltd.

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

import flash.globalization.LocaleID;

[RemoteClass(alias="com.tuarua.iap.storekit.ProductDiscount")]
public class ProductDiscount {
    public var numberOfPeriods:int;
    public var paymentMode:uint;
    public var price:Number;
    public var priceLocale:LocaleID; // TODO
    public var subscriptionPeriod:ProductSubscriptionPeriod;

    public function ProductDiscount() {
    }
}
}