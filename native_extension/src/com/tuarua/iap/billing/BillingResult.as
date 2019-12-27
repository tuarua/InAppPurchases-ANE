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
[RemoteClass(alias="com.tuarua.iap.billing.BillingResult")]
public class BillingResult {
    private var _responseCode:int;
    private var _debugMessage:String;

    public function BillingResult(responseCode:int, debugMessage:String) {
        this._responseCode = responseCode;
        this._debugMessage = debugMessage;
    }

    public function get responseCode():int {
        return _responseCode;
    }

    public function get debugMessage():String {
        return _debugMessage;
    }
}
}
