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

public extension SKDownload {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.Download", args: id)
            else { return nil }
        ret.contentIdentifier = contentIdentifier
#if os(iOS) || os(tvOS)
        ret.contentLength = NSNumber(value: contentLength)
#else
        ret.contentLength = contentLength
#endif
        ret.contentURL = contentURL?.absoluteString
        ret.contentVersion = contentVersion
        ret.transaction = transaction.toFREObject(id, false)
        return ret.rawValue
    }
}

public extension Array where Element == SKDownload {
    func toFREObject(_ id: String) -> FREObject? {
        return FREArray(className: "com.tuarua.iap.storekit.Download",
            length: self.count, fixed: true, items: self.map { $0.toFREObject(id) })?.rawValue
    }
}
