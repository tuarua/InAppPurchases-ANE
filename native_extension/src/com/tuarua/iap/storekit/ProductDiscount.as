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

[RemoteClass(alias="com.tuarua.iap.storekit.ProductDiscount")]
public class ProductDiscount {
    /**
     * A string used to uniquely identify a discount offer for a product.
     *
     * <p>You set up offers and their identifiers in App Store Connect.</p>
     * */
    public var identifier:String;
    /** An integer that indicates the number of periods the product discount is available. */
    public var numberOfPeriods:int;
    /** The payment mode for this product discount.*/
    public var paymentMode:uint;
    /** The discount price of the product in the local currency.*/
    public var price:Number;
    /** The locale used to format the discount price of the product.*/
    public var priceLocale:Locale;
    /** An object that defines the period for the product discount.*/
    public var subscriptionPeriod:ProductSubscriptionPeriod;
    /** The type of discount offer. */
    public var type:uint;
    public function ProductDiscount() {
    }
}
}