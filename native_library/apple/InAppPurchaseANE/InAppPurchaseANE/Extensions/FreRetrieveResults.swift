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

public extension RetrieveResults {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.RetrieveResults")
            else { return nil }
        ret.retrievedProducts = retrievedProducts.toFREObject()
        ret.invalidProductIDs = invalidProductIDs.toFREObject()
        // ret.error = error?.localizedDescription // TODO
        return ret.rawValue
    }
}

public extension Set where Element == String {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "String",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject()
            index+=1
        }
        return ret.rawValue
    }
}

public extension Locale {
    func toFREObject() -> FREObject? {
        // TODO
        guard let ret = FreObjectSwift(className: "flash.globalization.LocaleID", args: self.identifier)
            else { return nil }
        return ret.rawValue
    }
}
