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

public extension RetrieveResults {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.RetrieveResults")
            else { return nil }
        ret.retrievedProducts = retrievedProducts
        ret.invalidProductIDs = invalidProductIDs
        if let err = error {
            ret.error = FREObject(className: "Error", args: err.localizedDescription)
        }
        return ret.rawValue
    }
}

public extension Set where Element == String {
    func toFREObject() -> FREObject? {
        return FREArray(className: "String",
            length: self.count, fixed: true, items: self.map { $0.toFREObject() })?.rawValue
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> Set<String> {
        get { return [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
}

public extension Locale {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.Locale")
            else { return nil }
        ret.currencyCode = currencyCode
        ret.currencySymbol = currencySymbol
        ret.identifier = identifier
        return ret.rawValue
    }
    
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> Locale? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
