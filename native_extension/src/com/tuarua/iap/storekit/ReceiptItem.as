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
[RemoteClass(alias="com.tuarua.iap.storekit.ReceiptItem")]
public class ReceiptItem {
    /** The product identifier of the item that was purchased. This value corresponds to the productIdentifier
     * property of the SKPayment object stored in the transaction’s payment property.*/
    public var productId:String;
    /**  The number of items purchased. This value corresponds to the quantity property of the SKPayment object
     * stored in the transaction’s payment property.*/
    public var quantity:int;
    /** The transaction identifier of the item that was purchased. This value corresponds to the transaction’s
     * transactionIdentifier property.*/
    public var transactionId:String;
    /**  For a transaction that restores a previous transaction, the transaction identifier of the original
     * transaction. Otherwise, identical to the transaction identifier. This value corresponds to the original
     * transaction’s transactionIdentifier property. All receipts in a chain of renewals for an auto-renewable
     * subscription have the same value for this field.*/
    public var originalTransactionId:String;
    /**  The date and time that the item was purchased. This value corresponds to the transaction’s
     * transactionDate property.*/
    public var purchaseDate:Date;
    /**  For a transaction that restores a previous transaction, the date of the original transaction. This value
     * corresponds to the original transaction’s transactionDate property. In an auto-renewable subscription receipt,
     * this indicates the beginning of the subscription period, even if the subscription has been renewed.*/
    public var originalPurchaseDate:Date;
    /**  The primary key for identifying subscription purchases.*/
    public var webOrderLineItemId:String;
    /**  The expiration date for the subscription, expressed as the number of milliseconds since
     * January 1, 1970, 00:00:00 GMT. This key is only present for auto-renewable subscription receipts.*/
    public var subscriptionExpirationDate:Date;
    /**  For a transaction that was canceled by Apple customer support, the time and date of the cancellation.
     * Treat a canceled receipt the same as if no purchase had ever been made.*/
    public var cancellationDate:Date;
    public var isTrialPeriod:Boolean;
    public var isInIntroOfferPeriod:Boolean;

    public function ReceiptItem() {
    }
}
}
