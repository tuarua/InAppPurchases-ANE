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
import com.tuarua.iap.billing.BillingResult;
import com.tuarua.iap.billing.ChildDirected;
import com.tuarua.iap.billing.Purchase;
import com.tuarua.iap.billing.PurchasesResult;
import com.tuarua.iap.billing.SkuDetails;
import com.tuarua.iap.billing.SkuType;
import com.tuarua.iap.billing.UnderAgeOfConsent;

import flash.events.EventDispatcher;

public class BillingClient extends EventDispatcher {
    private var childDirected:int;
    private var underAgeOfConsent:int;

    public function BillingClient(childDirected:int = ChildDirected.unspecified, underAgeOfConsent:int = UnderAgeOfConsent.unspecified) {
        this.childDirected = childDirected;
        this.underAgeOfConsent = underAgeOfConsent;
    }

    /**
     * Starts up BillingClient setup process asynchronously.
     *
     * @param onBillingSetupFinished
     * @param onBillingServiceDisconnected
     */
    public function startConnection(onBillingSetupFinished:Function, onBillingServiceDisconnected:Function = null):void {
        var ret:* = InAppPurchaseANEContext.context.call("startConnection",
                InAppPurchaseANEContext.createCallback(onBillingSetupFinished),
                InAppPurchaseANEContext.createCallback(onBillingServiceDisconnected));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Close the connection and release all held resources such as service connections.
     *
     * <p>Call this method once you are done with this BillingClient reference.</p>
     */
    public function endConnection():void {
        var ret:* = InAppPurchaseANEContext.context.call("endConnection");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Checks if the client is currently connected to the service, so that requests to other methods
     * will succeed.
     *
     * <p>Returns true if the client is currently connected to the service, false otherwise.</p>
     *
     * <p>Note: It also means that SkuType.inApp items are supported for purchasing, queries and all other
     * actions. If you need to check support for SUBSCRIPTIONS or something different, use isFeatureSupported(String) method.</p>
     */
    public function get isReady():Boolean {
        var ret:* = InAppPurchaseANEContext.context.call("isReady");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Check if specified feature or capability is supported by the Play Store.
     *
     * @param feature One of FeatureType constants.
     * @return BillingResponseCode.ok if feature is supported and corresponding error code otherwise.
     */
    public function isFeatureSupported(feature:String):BillingResult {
        var ret:* = InAppPurchaseANEContext.context.call("isFeatureSupported", feature);
        if (ret is ANEError) throw ret as ANEError;
        return ret as BillingResult;
    }

    /**
     * Perform a network query to get SKU details and return the result asynchronously.
     *
     * @param skuList
     * @param listener Implement it to get the result of your query operation returned asynchronously
     * @param skuType
     */
    public function querySkuDetails(skuList:Vector.<String>, listener:Function, skuType:String = SkuType.inApp):void {
        var ret:* = InAppPurchaseANEContext.context.call("querySkuDetails", skuList, skuType,
                InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Initiate the billing flow for an in-app purchase or subscription.
     * <p>It will show the Google Play purchase screen.</p>
     * @return BillingResult
     * @param skuDetails
     * @param accountId
     * @param vrPurchaseFlow
     * @param replaceSkusProrationMode
     * @param developerId
     */
    public function launchBillingFlow(skuDetails:SkuDetails, accountId:String = null,
                                      vrPurchaseFlow:Boolean = false, replaceSkusProrationMode:int = -1,
                                      developerId:String = null):BillingResult {
        var ret:* = InAppPurchaseANEContext.context.call("launchBillingFlow", skuDetails,
                accountId, vrPurchaseFlow, replaceSkusProrationMode, developerId);
        if (ret is ANEError) throw ret as ANEError;
        return ret as BillingResult;
    }

    /**
     * Initiate a flow to confirm the change of price for an item subscribed by the user.
     *
     * <p>When the price of a user subscribed item has changed, launch this flow to take users to a screen with price
     * change information. User can confirm the new price or cancel the flow.</p>
     * @param skuDetails
     * @param listener
     */
    public function launchPriceChangeConfirmationFlow(skuDetails:SkuDetails, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("launchPriceChangeConfirmationFlow", skuDetails,
                InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Acknowledge in-app purchases.
     *
     * <p>Developers are required to acknowledge that they have granted entitlement for all in-app
     * purchases for their application.</p>
     *
     * <p><b>Warning!</b> All purchases require acknowledgement. Failure to acknowledge a purchase
     * will result in that purchase being refunded. For one-time products ensure you are using
     * <code>consumeAsync</code> which acts as an implicit acknowledgement or you can explicitly
    * acknowledge the purchase via this method. For subscriptions use <code>acknowledgePurchase</code>.
    * Please refer to
    * https://developer.android.com/google/play/billing/billing_library_overview#acknowledge for more
    * details.</p>
    *
    * @param purchase
    * @param listener Implement it to get the result of the acknowledge operation returned
    * asynchronously through the callback
    */
    public function acknowledgePurchase(purchase:Purchase, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("acknowledgePurchase", purchase.purchaseToken,
                purchase.developerPayload, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Consumes a given in-app product. Consuming can only be done on an item that's owned, and as a
     * result of consumption, the user will no longer own it.
     *
     * <p>Consumption is done asynchronously and the listener receives the callback specified upon
     * completion.</p>
     *
     * <p><b>Warning!</b> All purchases require acknowledgement. Failure to acknowledge a purchase
     * will result in that purchase being refunded. For one-time products ensure you are using this
     * method which acts as an implicit acknowledgement or you can explicitly acknowledge the purchase
     * via <code>acknowledgePurchase</code>. For subscriptions use <code>acknowledgePurchase</code>.
    * Please refer to
    * https://developer.android.com/google/play/billing/billing_library_overview#acknowledge for more
    * details.</p>
    *
    * @param purchase
    * @param listener Implement it to get the result of your consume operation returned
    * asynchronously through the callback with token
    * */
    public function consumePurchase(purchase:Purchase, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("consumePurchase", purchase.purchaseToken,
                purchase.developerPayload,
                InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Get purchases details for all the items bought within your app. This method uses a cache of
     * Google Play Store app without initiating a network request.
     *
     * <p>Note: It's recommended for security purposes to go through purchases verification on your
     * backend (if you have one) by calling one of the following APIs:
     * <ul><li>https://developers.google.com/android-publisher/api-ref/purchases/products/get</li>
     * <li>https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/get</li></ul></p>
     *
     * @param skuType The type of SKU, either "inapp" or "subs" as in <code>SkuType</code>.
     * @return PurchasesResult The <code>PurchasesResult</code> containing the list of purchases and the
     * response code
     */
    public function queryPurchases(skuType:String = SkuType.inApp):PurchasesResult {
        var ret:* = InAppPurchaseANEContext.context.call("queryPurchases", skuType);
        if (ret is ANEError) throw ret as ANEError;
        return ret as PurchasesResult;
    }

    /**
     * Returns the most recent purchase made by the user for each SKU, even if that purchase is expired, canceled,
     * or consumed.
     * @param skuType The type of SKU, either "inapp" or "subs" as in <code>SkuType</code>.
     * @param listener Implement it to get the result of your query operation returned asynchronously through
     * the callback with the BillingResponseCode and the list of PurchaseHistoryRecord.
     */
    public function queryPurchaseHistory(skuType:String, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("queryPurchaseHistory", skuType,
                InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Loads a rewarded sku in the background and returns the result asynchronously.
     *
     * <p>If the rewarded sku is available, the response will be BillingResponseCode.ok. Otherwise the
     * response will be BillingResponseCode.itemUnavailable. There is no guarantee that a rewarded sku will always be
     * available. After a successful response, only then should the offer be given to a user to obtain
     * a rewarded item and call launchBillingFlow.</p>
     *
     * @param skuList
     * @param listener Implement it to get the result of the load operation returned asynchronously
     */
    public function loadRewardedSku(skuList:Vector.<String>, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("loadRewardedSku",
                skuList, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Verifies that the data was signed with the given signature
     *
     * @param publicKey should be YOUR APPLICATION'S PUBLIC KEY
     * (that you got from the Google Play developer console, usually under Services &amp; APIs tab).
     * This is not your developer public key, it's the <b>app-specific</b> public key.
     * @param purchase The purchase to check
     */
    public function isSignatureValid(publicKey:String, purchase:Purchase):Boolean {
        var ret:* = InAppPurchaseANEContext.context.call("isSignatureValid", publicKey, purchase);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }
}
}
