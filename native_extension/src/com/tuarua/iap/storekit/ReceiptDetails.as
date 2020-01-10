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
public class ReceiptDetails {
    public var original_purchase_date:String;
    public var receipt_creation_date:String;
    public var download_id:int;
    public var bundle_id:String;
    public var request_date_pst:String;
    public var original_application_version:String;
    public var adam_id:int;
    public var original_purchase_date_pst:String;
    public var application_version:String;
    public var original_purchase_date_ms:String;
    public var receipt_creation_date_pst:String;
    public var receipt_creation_date_ms:String;
    public var app_item_id:int;
    public var request_date_ms:String;
    public var request_date:String;
    public var version_external_identifier:int;
    public var receipt_type:String;
    public var in_app:Vector.<ReceiptInfo>;
    // TODO others ?

    public function ReceiptDetails() {
    }
}
}