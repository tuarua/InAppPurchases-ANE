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

package com.tuarua.iap.billing {
[RemoteClass(alias="com.tuarua.iap.billing.Purchase")]
public class Purchase {
    /** Returns the payload specified when the purchase was acknowledged or consumed. */
    public var developerPayload:String;
    /** Indicates whether the purchase has been acknowledged. */
    public var isAcknowledged:Boolean;
    /** Indicates whether the subscription renews automatically. */
    public var isAutoRenewing:Boolean;
    /** Returns an unique order identifier for the transaction. */
    public var orderId:String;
    /** Returns a String in JSON format that contains details about the purchase order. */
    public var originalJson:String;
    /** Returns the application package from which the purchase originated. */
    public var packageName:String;
    /** Returns the state of purchase. */
    public var purchaseState:int;
    /** Returns the time the product was purchased. */
    public var purchaseTime:Date;
    /** Returns a token that uniquely identifies a purchase for a given item and user pair. */
    public var purchaseToken:String;
    /** Returns the product Id. */
    public var sku:String;
    /** Returns String containing the signature of the purchase data that was signed with the private key of the developer. */
    public var signature:String;

    public function Purchase() {
    }
}
}
