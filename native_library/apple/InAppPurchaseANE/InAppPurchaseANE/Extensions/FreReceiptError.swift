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

public extension ReceiptError {
    func toDictionary() -> [String: Any] {
        var props = [String: Any]()
        switch self {
        case .noReceiptData:
            props["type"] = 0
        case .noRemoteData:
            props["type"] = 1
        case .requestBodyEncodeError(let error):
            props["type"] = 2
            props["text"] = error.localizedDescription
        case .networkError(let error):
            props["type"] = 3
            props["text"] = error.localizedDescription
        case .jsonDecodeError(let string):
            props["type"] = 4
            props["text"] = string
        case .receiptInvalid(let receipt, let status):
            props["type"] = 5
            props["status"] = status.rawValue
            props["receipt"] = receipt
        }
        return props
    }
}
