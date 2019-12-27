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
     * <p>Call this method once you are done with this BillingClient reference.
     */
    public function endConnection():void {
        var ret:* = InAppPurchaseANEContext.context.call("endConnection");
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Checks if the client is currently connected to the service, so that requests to other methods
     * will succeed.
     *
     * <p>Returns true if the client is currently connected to the service, false otherwise.
     *
     * <p>Note: It also means that INAPP items are supported for purchasing, queries and all other
     * actions. If you need to check support for SUBSCRIPTIONS or something different, use isFeatureSupported(String) method.
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
     * @return BILLING_RESULT_OK if feature is supported and corresponding error code otherwise.
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
     *
     * <p>It will show the Google Play purchase screen.</p>
     *
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
     * Acknowledge in-app purchases.
     *
     * <p>Developers are required to acknowledge that they have granted entitlement for all in-app
     * purchases for their application.
     *
     * <p><b>Warning!</b> All purchases require acknowledgement. Failure to acknowledge a purchase
     * will result in that purchase being refunded. For one-time products ensure you are using
     * {@link #consumeAsync) which acts as an implicit acknowledgement or you can explicitly
    * acknowledge the purchase via this method. For subscriptions use {@link #acknowledgePurchase).
    * Please refer to
    * https://developer.android.com/google/play/billing/billing_library_overview#acknowledge for more
    * details.
    *
    * @param purchaseToken
    * @param listener Implement it to get the result of the acknowledge operation returned
    * asynchronously through the callback
    * @param developerPayload
    */
    public function acknowledgePurchase(purchaseToken:String, listener:Function, developerPayload:String = null):void {
        var ret:* = InAppPurchaseANEContext.context.call("acknowledgePurchase", purchaseToken,
                developerPayload, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Consumes a given in-app product. Consuming can only be done on an item that's owned, and as a
     * result of consumption, the user will no longer own it.
     *
     * <p>Consumption is done asynchronously and the listener receives the callback specified upon
     * completion.
     *
     * <p><b>Warning!</b> All purchases require acknowledgement. Failure to acknowledge a purchase
     * will result in that purchase being refunded. For one-time products ensure you are using this
     * method which acts as an implicit acknowledgement or you can explicitly acknowledge the purchase
     * via {@link #acknowledgePurchase). For subscriptions use {@link #acknowledgePurchase).
    * Please refer to
    * https://developer.android.com/google/play/billing/billing_library_overview#acknowledge for more
    * details.
    *
    * @param purchaseToken Params specific to consume purchase.
    * @param listener Implement it to get the result of your consume operation returned
    * asynchronously through the callback with token
    * @param developerPayload
    * */
    public function consumePurchase(purchaseToken:String, listener:Function, developerPayload:String = null):void {
        var ret:* = InAppPurchaseANEContext.context.call("consumePurchase", purchaseToken, developerPayload,
                InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Get purchases details for all the items bought within your app. This method uses a cache of
     * Google Play Store app without initiating a network request.
     *
     * <p>Note: It's recommended for security purposes to go through purchases verification on your
     * backend (if you have one) by calling one of the following APIs:
     * https://developers.google.com/android-publisher/api-ref/purchases/products/get
     * https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/get
     *
     * @param skuType The type of SKU, either "inapp" or "subs" as in {@link SkuType}.
     * @return PurchasesResult The {@link PurchasesResult} containing the list of purchases and the
     * response code
     */
    public function queryPurchases(skuType:String = SkuType.inApp):PurchasesResult {
        var ret:* = InAppPurchaseANEContext.context.call("queryPurchases", skuType);
        if (ret is ANEError) throw ret as ANEError;
        return ret as PurchasesResult;
    }

    /**
     * Loads a rewarded sku in the background and returns the result asynchronously.
     *
     * <p>If the rewarded sku is available, the response will be BILLING_RESULT_OK. Otherwise the
     * response will be ITEM_UNAVAILABLE. There is no guarantee that a rewarded sku will always be
     * available. After a successful response, only then should the offer be given to a user to obtain
     * a rewarded item and call launchBillingFlow.
     *
     * @param skuList
     * @param listener Implement it to get the result of the load operation returned asynchronously
     */
    public function loadRewardedSku(skuList:Vector.<String>, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("loadRewardedSku",
                skuList, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

}
}
