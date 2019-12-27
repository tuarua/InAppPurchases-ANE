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
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifySubscriptionResult;

public class StoreKit {
    public function StoreKit() {
    }

    public function retrieveProductsInfo(productIds:Vector.<String>, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("retrieveProductsInfo", productIds, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function purchaseProduct(productId:String, listener:Function, atomically:Boolean = true, quantity:int = 1):void {
        var ret:* = InAppPurchaseANEContext.context.call("purchaseProduct", productId, quantity,
                atomically, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get canMakePayments():Boolean {
        var ret:* = InAppPurchaseANEContext.context.call("canMakePayments");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    public function finishTransaction(transaction:PaymentTransaction):void {
        var ret:* = InAppPurchaseANEContext.context.call("finishTransaction", transaction);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function verifyPurchase(productId:String, receipt:Object):VerifyPurchaseResult {
        var ret:* = InAppPurchaseANEContext.context.call("verifyPurchase", productId, receipt);
        if (ret is ANEError) throw ret as ANEError;
        return ret as VerifyPurchaseResult;
    }

    public function verifySubscription(productId:String, receipt:Object):VerifySubscriptionResult {
        var ret:* = InAppPurchaseANEContext.context.call("verifyPurchase", productId, receipt);
        if (ret is ANEError) throw ret as ANEError;
        return ret as VerifySubscriptionResult;
    }

    public function verifyReceipt(service:String, sharedSecret:String, listener:Function, forceRefresh:Boolean = false):void {
        var ret:* = InAppPurchaseANEContext.context.call("verifyReceipt", service, sharedSecret,
                forceRefresh, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function fetchReceipt(forceRefresh:Boolean, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("fetchReceipt", forceRefresh, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function restorePurchases(atomically:Boolean, listener:Function):void {
        var ret:* = InAppPurchaseANEContext.context.call("restorePurchases", atomically, InAppPurchaseANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }




}
}
