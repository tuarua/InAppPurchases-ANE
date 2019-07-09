//
//  FreRetrieveResults.swift
//  InAppPurchasesANE_FW
//
//  Created by Eoin Landy on 07/07/2019.
//  Copyright © 2019 Tua Rua Ltd. All rights reserved.
//

import Foundation
import FreSwift
import StoreKit

public extension RetrieveResults {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.RetrieveResults")
            else { return nil }
        ret.retrievedProducts = retrievedProducts.toFREObject()
        ret.invalidProductIDs = invalidProductIDs.toFREObject()
        // ret.error = error?.localizedDescription // TODO
        return ret.rawValue
    }
}

public extension Set where Element == SKProduct {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.iap.Product",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject()
            index+=1
        }
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

public extension SKProduct {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.Product")
            else { return nil }
        
        ret.localizedTitle = localizedTitle
        ret.price = price
        ret.localizedPrice = localizedPrice
        ret.localizedDescription = localizedDescription
        ret.isDownloadable = isDownloadable
        ret.downloadContentLengths = downloadContentLengths
        ret.downloadContentVersion = downloadContentVersion
        ret.priceLocale = priceLocale.toFREObject()
        ret.productIdentifier = productIdentifier
        if #available(iOS 12.0, *) {
            ret.subscriptionGroupIdentifier = subscriptionGroupIdentifier
        }
        if #available(iOS 11.2, *) {
            ret.introductoryPrice = introductoryPrice?.toFREObject()
            ret.subscriptionPeriod = subscriptionPeriod?.toFREObject()
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

@available(iOS 11.2, *)
public extension SKProductDiscount {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.ProductDiscount")
            else { return nil }
        ret.numberOfPeriods = numberOfPeriods
        ret.paymentMode = paymentMode.rawValue
        ret.price = price
        ret.priceLocale = priceLocale.toFREObject()
        ret.subscriptionPeriod = subscriptionPeriod.toFREObject()
        return ret.rawValue
    }
}

@available(iOS 11.2, *)
public extension SKProductSubscriptionPeriod {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.ProductSubscriptionPeriod")
            else { return nil }
        ret.numberOfUnits = numberOfUnits
        ret.unit = unit.rawValue
        return ret.rawValue
    }
}

public extension PurchaseDetails {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.PurchaseDetails", args: id)
            else { return nil }
        ret.productId = productId
        ret.quantity = quantity
        ret.product = product.toFREObject()
        ret.needsFinishTransaction = needsFinishTransaction
        ret.transaction = transaction.toFREObject(id)
        ret.originalTransaction = originalTransaction?.toFREObject(id)
        return ret.rawValue
    }
}

public extension Purchase {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.Purchase", args: id)
            else { return nil }
        ret.productId = productId
        ret.quantity = quantity
        ret.needsFinishTransaction = needsFinishTransaction
        ret.transaction = transaction.toFREObject(id)
        ret.originalTransaction = originalTransaction?.toFREObject(id)
        return ret.rawValue
    }
}

public extension PaymentTransaction {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.PaymentTransaction", args: id)
            else { return nil }
        ret.transactionIdentifier = transactionIdentifier
        ret.transactionDate = transactionDate
        ret.transactionState = transactionState.rawValue
        ret.downloads = self.downloads.toFREObject(id)
        return ret.rawValue
    }
}

public extension SKDownload {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.Download")
            else { return nil }
        ret.contentIdentifier = contentIdentifier
        ret.contentLength = NSNumber(value: contentLength)
        ret.contentURL = contentURL?.absoluteString
        ret.contentVersion = contentVersion
        return ret.rawValue
    }
}

public extension Array where Element == SKDownload {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.iap.Download",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject(id)
            index+=1
        }
        return ret.rawValue
    }
}

public extension Array where Element == Purchase {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.iap.Purchase",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject(id)
            index+=1
        }
        return ret.rawValue
    }
}

public extension RestoreResults {
    func toFREObject(_ id: String) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.iap.RestoreResults")
            else { return nil }
        ret.restoredPurchases = restoredPurchases.toFREObject(id)
        // ret.restoreFailedPurchases = restoreFailedPurchases
        return ret.rawValue
    }
}
