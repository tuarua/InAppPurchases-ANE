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
public class ReceiptInfo {
    public var original_purchase_date:String;
    public var original_purchase_date_ms:String;
    public var original_purchase_date_pst:String;
    public var product_id:String;
    public var transaction_id:String;
    public var original_transaction_id:String;
    public var is_trial_period:String;
    public var purchase_date:String;
    public var purchase_date_ms:String;
    public var purchase_date_pst:String;
    public var quantity:String;
    public var expires_date:String;
    public var expires_date_ms:String;
    public var expires_date_pst:String;
    public var subscription_group_identifier:String;
    public var is_in_intro_offer_period:String;
    public var web_order_line_item_id:String;
    public function ReceiptInfo() {
    }
}
}