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

[RemoteClass(alias="com.tuarua.iap.storekit.PaymentTransaction")]
public class PaymentTransaction {
    private var _id:String;
    public var transactionIdentifier:String;
    public var transactionDate:Date;
    public var transactionState:int;
    public var downloads:Vector.<Download> = new Vector.<Download>();

    public function PaymentTransaction(id:String) {
        this._id = id;
    }

    /** The purchase id associated with this transaction */
    public function get id():String {
        return _id;
    }
}
}
