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

public extension SKProduct {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.Product")
            else { return nil }
        
        ret.localizedTitle = localizedTitle
        ret.price = price
        ret.localizedPrice = localizedPrice
        ret.localizedDescription = localizedDescription
        if #available(macOS 10.15, iOS 9.0, tvOS 9.2, *) {
            ret.isDownloadable = isDownloadable
        }
        if #available(macOS 10.14, iOS 9.0, tvOS 9.2, *) {
            ret.downloadContentLengths = downloadContentLengths
            ret.downloadContentVersion = downloadContentVersion
        }
        ret.priceLocale = priceLocale
        ret.productIdentifier = productIdentifier
        if #available(macOS 10.14, iOS 12.0, tvOS 12.2, *) {
            ret.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        }
        if #available(macOS 10.13.2, iOS 11.2, tvOS 11.2, *) {
            ret.introductoryPrice = introductoryPrice
            ret.subscriptionPeriod = subscriptionPeriod
        }
        return ret.rawValue
    }
}

public extension Set where Element == SKProduct {
    func toFREObject() -> FREObject? {
        return FREArray(className: "com.tuarua.iap.storekit.Product",
            length: self.count, fixed: true, items: self.map { $0.toFREObject() })?.rawValue
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> Set<SKProduct> {
        get { return [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
}
