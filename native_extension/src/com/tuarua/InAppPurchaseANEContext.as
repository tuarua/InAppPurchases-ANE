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
package com.tuarua {
import com.tuarua.fre.ANEError;
import com.tuarua.iap.billing.BillingResult;
import com.tuarua.iap.billing.Purchase;
import com.tuarua.iap.billing.PurchaseHistoryRecord;
import com.tuarua.iap.billing.PurchasesResult;
import com.tuarua.iap.billing.SkuDetails;
import com.tuarua.iap.billing.events.BillingEvent;
import com.tuarua.iap.storekit.FetchReceiptResult;
import com.tuarua.iap.storekit.PurchaseError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class InAppPurchaseANEContext {
    internal static const NAME:String = "InAppPurchaseANE";
    internal static const TRACE:String = "TRACE";

    // storekit
    private static const PRODUCT_INFO:String = "InAppPurchaseEvent.ProductInfo";
    private static const PURCHASE:String = "InAppPurchaseEvent.Purchase";
    private static const RESTORE:String = "InAppPurchaseEvent.Restore";
    private static const VERIFY_RECEIPT:String = "InAppPurchaseEvent.VerifyReceipt";
    private static const FETCH_RECEIPT:String = "InAppPurchaseEvent.FetchReceipt";
    //billing
    private static const ON_CONSUME:String = "BillingEvent.onConsume";
    private static const ON_ACKNOWLEDGE_PURCHASE:String = "BillingEvent.onAcknowledgePurchase";
    private static const ON_SETUP_FINISHED:String = "BillingEvent.onBillingSetupFinished";
    private static const ON_SERVICE_DISCONNECTED:String = "BillingEvent.onBillingServiceDisconnected";
    private static const ON_QUERY_SKU:String = "BillingEvent.onQuerySkuDetails";
    private static const ON_PURCHASE_HISTORY:String = "BillingEvent.onPurchaseHistory";
    private static const ON_REWARDED_SKU:String = "BillingEvent.onLoadRewardedSku";

    public static var callbacks:Dictionary = new Dictionary();
    private static var _context:ExtensionContext;
    private static var _isDisposed:Boolean;

    public function InAppPurchaseANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isDisposed = false;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, ...args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        var argsAsJSON:Object;
        var ret:* = null;
        var err:PurchaseError = null;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case PRODUCT_INFO:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new PurchaseError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else {
                        ret = _context.call("getProductsInfo", argsAsJSON.callbackId);
                    }
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case PURCHASE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new PurchaseError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else {
                        ret = _context.call("getPurchaseProduct", argsAsJSON.callbackId);
                    }
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case RESTORE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ret = _context.call("getRestore", argsAsJSON.callbackId);
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case VERIFY_RECEIPT:
                trace(event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ret = _context.call("getReceipt", argsAsJSON.callbackId);
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    callCallback(argsAsJSON.callbackId, ret);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case FETCH_RECEIPT:
                trace(event.code);
                // FetchReceiptResult
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var receiptResult:FetchReceiptResult;
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        trace("has error");
                    } else {
                        receiptResult = new FetchReceiptResult(argsAsJSON.receiptData);
                    }
                    callCallback(argsAsJSON.callbackId, receiptResult);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_CONSUME:
                trace(event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    callCallback(argsAsJSON.callbackId,
                            new BillingResult(argsAsJSON.data.billingResult.responseCode,
                                    argsAsJSON.data.billingResult.debugMessage),
                            argsAsJSON.data.purchaseToken);

                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_ACKNOWLEDGE_PURCHASE:
            case ON_SETUP_FINISHED:
            case ON_REWARDED_SKU:
                trace(event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    callCallback(argsAsJSON.callbackId,
                            new BillingResult(argsAsJSON.data.billingResult.responseCode, argsAsJSON.data.billingResult.debugMessage));

                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_SERVICE_DISCONNECTED:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    callCallback(argsAsJSON.callbackId);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_QUERY_SKU:
                trace(event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var skuDetailsList:Vector.<SkuDetails> = new Vector.<SkuDetails>();

                    for each(var j:String in argsAsJSON.data.skuDetailsList) {
                        skuDetailsList.push(new SkuDetails(j))
                    }
                    callCallback(argsAsJSON.callbackId, new BillingResult(argsAsJSON.data.billingResult.responseCode,
                            argsAsJSON.data.billingResult.debugMessage),
                            skuDetailsList);

                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ON_PURCHASE_HISTORY:
                trace(event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var purchasesList:Vector.<PurchaseHistoryRecord> = new Vector.<PurchaseHistoryRecord>();
                    for each(var j2:Object in argsAsJSON.data.purchasesList) {
                        purchasesList.push(new PurchaseHistoryRecord(j2.originalJson, j2.signature));
                    }
                    callCallback(argsAsJSON.callbackId, new BillingResult(argsAsJSON.data.billingResult.responseCode,
                            argsAsJSON.data.billingResult.debugMessage),
                            purchasesList);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case BillingEvent.ON_PURCHASES_UPDATED:
                trace("ON_PURCHASES_UPDATED updated: ", event.code);
                try {
                    argsAsJSON = JSON.parse(event.code);
                    ret = InAppPurchaseANEContext.context.call("getOnPurchasesUpdates", argsAsJSON.callbackId);
                    if (ret is ANEError) {
                        printANEError(ret);
                        return;
                    }
                    InAppPurchase.billing().dispatchEvent(new BillingEvent(event.level, ret as PurchasesResult));
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /** @private */
    private static function printANEError(error:ANEError):void {
        trace("[" + NAME + "] Error: ", error.type, error.errorID, "\n", error.source, "\n", error.getStackTrace());
    }

    public static function dispose():void {
        if (_context == null) return;
        _isDisposed = true;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }

    public static function get isDisposed():Boolean {
        return _isDisposed;
    }

}
}
