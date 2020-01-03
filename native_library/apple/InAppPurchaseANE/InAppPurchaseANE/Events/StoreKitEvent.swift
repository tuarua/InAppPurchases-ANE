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

import Foundation

class StoreKitEvent: NSObject {
    public static let PRODUCT_INFO = "StoreKitEvent.ProductInfo"
    public static let PURCHASE = "StoreKitEvent.Purchase"
    public static let RESTORE = "StoreKitEvent.Restore"
    public static let VERIFY_RECEIPT = "StoreKitEvent.VerifyReceipt"
    public static let FETCH_RECEIPT = "StoreKitEvent.FetchReceipt"
}
