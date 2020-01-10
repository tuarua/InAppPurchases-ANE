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
import SwiftyJSON
import SwiftyStoreKit

class StoreKitEvent: NSObject {
    static let PRODUCT_INFO = "StoreKitEvent.ProductInfo"
    static let PURCHASE = "StoreKitEvent.Purchase"
    static let RESTORE = "StoreKitEvent.Restore"
    static let VERIFY_RECEIPT = "StoreKitEvent.VerifyReceipt"
    static let FETCH_RECEIPT = "StoreKitEvent.FetchReceipt"
    var callbackId: String?
    var receipt: ReceiptInfo?
    var receiptData: Data?
    var receiptError: ReceiptError?
    var error: Error?
    
    convenience init(callbackId: String, receipt: ReceiptInfo? = nil, receiptData: Data? = nil,
                     receiptError: ReceiptError? = nil, error: Error? = nil) {
        self.init()
        self.callbackId = callbackId
        self.receipt = receipt
        self.receiptData = receiptData
        self.receiptError = receiptError
        self.error = error
    }
    
}

public extension JSON {
    internal init(_ event: StoreKitEvent) {
        var props = [String: Any]()
        props["callbackId"] = event.callbackId
        if let receipt = event.receipt {
            props["receipt"] = receipt
        }
        if let receiptData = event.receiptData {
            props["receiptData"] = receiptData.base64EncodedString(options: [])
        }
        if let receiptError = event.receiptError {
            props["error"] = receiptError.toDictionary()
        }
        if let error = event.error {
            props["error"] = ["text": error.localizedDescription, "id": 0]
        }
        
        self.init(props)
    }
}
