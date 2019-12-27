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
import FreSwift
import StoreKit

public extension ReceiptItem {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.ReceiptItem")
            else { return nil }
        ret.productId = productId
        ret.quantity = quantity
        ret.transactionId = transactionId
        ret.originalTransactionId = originalTransactionId
        ret.purchaseDate = purchaseDate
        ret.originalPurchaseDate = originalPurchaseDate
        ret.webOrderLineItemId = webOrderLineItemId
        ret.subscriptionExpirationDate = subscriptionExpirationDate
        ret.cancellationDate = cancellationDate
        ret.isTrialPeriod = isTrialPeriod
        ret.isInIntroOfferPeriod = isInIntroOfferPeriod
        return ret.rawValue
    }
}

public extension Array where Element == ReceiptItem {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.iap.storekit.ReceiptItem",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject()
            index+=1
        }
        return ret.rawValue
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> ReceiptItem? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    public subscript(dynamicMember name: String) -> [ReceiptItem] {
        get { return [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
}
