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
public class PurchaseHistoryRecord {
    private var _signature:String;
    private var _sku:String;
    private var _purchaseTime:Date;
    private var _purchaseToken:String;
    private var _developerPayload:String;
    private var _originalJson:String;
    public function PurchaseHistoryRecord(jsonPurchaseInfo:String, signature:String = null) {
        var json:Object = JSON.parse(jsonPurchaseInfo);
        this._originalJson = jsonPurchaseInfo;
        this._signature = signature;
        this._sku = json["productId"];
        this._purchaseTime = new Date(json["purchaseTime"]);
        this._purchaseToken = json.hasOwnProperty("token") ? json["token"] : json["purchaseToken"];
        this._developerPayload = json["developerPayload"];
    }
    /**
     * Returns String containing the signature of the purchase data that was signed with the private
     * key of the developer. The data signature uses the RSASSA-PKCS1-v1_5 scheme.
     */
    public function get signature():String {
        return _signature;
    }
    /** Returns the product Id. */
    public function get sku():String {
        return _sku;
    }
    /** Returns the time the product was purchased. */
    public function get purchaseTime():Date {
        return _purchaseTime;
    }
    /** Returns a token that uniquely identifies a purchase for a given item and user pair. */
    public function get purchaseToken():String {
        return _purchaseToken;
    }
    /** Returns the payload specified when the purchase was acknowledged or consumed. */
    public function get developerPayload():String {
        return _developerPayload;
    }
    /** Returns a String in JSON format that contains details about the purchase order. */
    public function get originalJson():String {
        return _originalJson;
    }
}
}
