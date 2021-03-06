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
import SwiftyStoreKit
import StoreKit

public extension PaymentTransaction {
    func toFREObject(_ id: String, _ returnDownloads: Bool = true) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.PaymentTransaction", args: id)
            else { return nil }
        ret.transactionIdentifier = transactionIdentifier
        ret.transactionDate = transactionDate
        ret.transactionState = transactionState.rawValue
        if returnDownloads {
            ret.downloads = self.downloads.toFREObject(id)
        }
        return ret.rawValue
    }
}
