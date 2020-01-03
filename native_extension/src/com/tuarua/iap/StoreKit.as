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

package com.tuarua.iap {
import com.tuarua.InAppPurchaseANEContext;
import com.tuarua.fre.ANEError;
import com.tuarua.iap.storekit.PaymentTransaction;
import com.tuarua.iap.storekit.SubscriptionType;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifySubscriptionResult;

public class StoreKit {
    public function StoreKit() {
    }

    /**
     * Retrieve products information
     *
     * @param productIds The set of product identifiers to retrieve corresponding products for
     * @param completion handler for result
     */
    public function retrieveProductsInfo(productIds:Vector.<String>, completion:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("retrieveProductsInfo", productIds,
                InAppPurchaseANEContext.createCallback(completion));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Purchase a product
     *
     * @param productId productId as specified in iTunes Connect
     * @param completion  handler for result
     * @param atomically whether the product is purchased atomically (e.g. finishTransaction is called immediately)
     * @param quantity quantity of the product to be purchased
     */
    public function purchaseProduct(productId:String, completion:Function, atomically:Boolean = true, quantity:int = 1):void {
        var ret:* = InAppPurchaseANEContext.context.call("purchaseProduct", productId, quantity,
                atomically, InAppPurchaseANEContext.createCallback(completion));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Return false if this device is not able or allowed to make payments
     */
    public function get canMakePayments():Boolean {
        var ret:* = InAppPurchaseANEContext.context.call("canMakePayments");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Finish a transaction Once the content has been delivered, call this method to finish a transaction that was performed non-atomically
     *
     * @param transaction transaction to finish
     */
    public function finishTransaction(transaction:PaymentTransaction):void {
        var ret:* = InAppPurchaseANEContext.context.call("finishTransaction", transaction);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Verify the purchase of a Consumable or NonConsumable product in a receipt
     *
     * @param productId the product id of the purchase to verify
     * @param receipt the receipt to use for looking up the purchase
     * @return either notPurchased or purchased
     */
    public function verifyPurchase(productId:String, receipt:Object):VerifyPurchaseResult {
        var ret:* = InAppPurchaseANEContext.context.call("verifyPurchase", productId, receipt);
        if (ret is ANEError) throw ret as ANEError;
        return ret as VerifyPurchaseResult;
    }

    /**
     *  Verify the validity of a subscription (auto-renewable, free or non-renewing) in a receipt
     *
     * <p>This method extracts all transactions matching the given productId and sorts them by date in descending order.
     * It then compares the first transaction expiry date against the receipt date to determine its validity.</p>
     *
     * @param productId The product id of the subscription to verify.
     * @param receipt The receipt to use for looking up the subscription.
     * @param type SubscriptionType.autoRenewable or SubscriptionType.nonRenewing.
     * @return
     */
    public function verifySubscription(productId:String, receipt:Object, type:int = SubscriptionType.autoRenewable):VerifySubscriptionResult {
        var ret:* = InAppPurchaseANEContext.context.call("verifySubscription", productId, receipt, type);
        if (ret is ANEError) throw ret as ANEError;
        return ret as VerifySubscriptionResult;
    }

    /**
     * Verify application receipt
     *
     * @param service
     * @param sharedSecret
     * @param completion handler for result
     * @param forceRefresh If true, refreshes the receipt even if one already exists.
     */
    public function verifyReceipt(service:String, sharedSecret:String, completion:Function, forceRefresh:Boolean = false):void {
        var ret:* = InAppPurchaseANEContext.context.call("verifyReceipt", service, sharedSecret,
                forceRefresh, InAppPurchaseANEContext.createCallback(completion));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Fetch application receipt
     *
     * @param forceRefresh If true, refreshes the receipt even if one already exists.
     * @param completion handler for result
     */
    public function fetchReceipt(forceRefresh:Boolean, completion:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("fetchReceipt", forceRefresh,
                InAppPurchaseANEContext.createCallback(completion));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Restore purchases
     *
     * @param atomically whether the product is purchased atomically (e.g. finishTransaction is called immediately)
     * @param completion handler for result
     */
    public function restorePurchases(atomically:Boolean, completion:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("restorePurchases", atomically,
                InAppPurchaseANEContext.createCallback(completion));
        if (ret is ANEError) throw ret as ANEError;
    }


}
}
