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

import flash.events.EventDispatcher;

public class InAppPurchasesANE extends EventDispatcher {
    private var _isInited:Boolean;
    private static var _iap:InAppPurchasesANE;

    public function InAppPurchasesANE() {
        if (_iap) {
            throw new Error(InAppPurchasesANEContext.NAME + " is a singleton, use .iap");
        }
        if (InAppPurchasesANEContext.context) {
            var theRet:* = InAppPurchasesANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
            _isInited = theRet as Boolean;
        }
        _iap = this;
    }

    public static function get iap():InAppPurchasesANE {
        if (_iap == null) {
            new InAppPurchasesANE();
        }
        return _iap;
    }

    public function retrieveProductsInfo(productIds:Vector.<String>, listener:Function):void {
        if (!safetyCheck()) return;
        var ret:* = InAppPurchasesANEContext.context.call("retrieveProductsInfo", productIds, InAppPurchasesANEContext.createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function purchaseProduct(productId:String, listener:Function, atomically:Boolean = true, quantity:int = 1):void {
        if (!safetyCheck()) return;
        var ret:* = InAppPurchasesANEContext.context.call("purchaseProduct", productId, quantity,
                atomically, InAppPurchasesANEContext.createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public function get canMakePayments():Boolean {
        if (!safetyCheck()) return false;
        var ret:* = InAppPurchasesANEContext.context.call("canMakePayments");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /** @return whether we have inited */
    public function get isInited():Boolean {
        return _isInited;
    }

    /** @private */
    private function safetyCheck():Boolean {
        if (!_isInited || InAppPurchasesANEContext.isDisposed) {
            trace("You need to init first");
            return false;
        }
        return true;
    }

    public static function dispose():void {
        if (InAppPurchasesANEContext.context) {
            InAppPurchasesANEContext.dispose();
        }
    }
}
}
