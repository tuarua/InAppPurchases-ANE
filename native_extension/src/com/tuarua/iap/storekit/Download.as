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
[RemoteClass(alias="com.tuarua.iap.storekit.Download")]
public class Download {
    private var _productId:String;
    public var contentIdentifier:String;
    public var contentLength:Number;
    public var contentURL:String;
    public var contentVersion:String;
    public var transaction:PaymentTransaction;

    /** @private */
    public function Download(id:String) {
        this._productId = id;
    }

    /** @private */
    public function get productId():String {
        return _productId;
    }
}
}
