/* Copyright 2018 Tua Rua Ltd.
 
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
import SwiftyStoreKit
import SwiftyJSON

public class SwiftController: NSObject {
    public static var TAG = "InAppPurchaseANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var retrieveResults: [String: RetrieveResults] = [:]
    private var purchaseResult: [String: PurchaseDetails] = [:]
    private var restoreResults: [String: RestoreResults] = [:]
    private var restoredPurchases: [String: Purchase] = [:]
    internal var launchPurchases: [Purchase] = []
    private var pendingPurchases: [String: Purchase] = [:]
    private var productDownloads: [String: [SKDownload]] = [:]
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return FREArray(className: "com.tuarua.iap.storekit.Purchase", length: launchPurchases.count, fixed: true,
                        items: launchPurchases.map {
                            let pid = UUID().uuidString
                            if $0.needsFinishTransaction {
                                pendingPurchases[pid] = $0
                            }
                            return $0.toFREObject(pid)
        })?.rawValue
    }
    
    func retrieveProductsInfo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let productIds = [String](argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.retrieveProductsInfo(Set<String>(productIds)) { result in
            self.retrieveResults[callbackId] = result
            if let error = result.error {
                self.dispatchEvent(name: StoreKitEvent.PRODUCT_INFO,
                                   value: JSON(StoreKitEvent(callbackId: callbackId, error: error)).description)
                return
            }
            self.dispatchEvent(name: StoreKitEvent.PRODUCT_INFO,
                               value: JSON(StoreKitEvent(callbackId: callbackId)).description)
        }
        return nil
    }
    
    func getProductsInfo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let ret = retrieveResults[id]?.toFREObject()
        retrieveResults.removeValue(forKey: id)
        return ret
    }
    
    func canMakePayments(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return SwiftyStoreKit.canMakePayments.toFREObject()
    }
    
    func purchaseProduct(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 5,
            let productId = String(argv[0]),
            let quantity = Int(argv[1]),
            let atomically = Bool(argv[2]),
            let applicationUsername = String(argv[3]),
            let simulatesAskToBuyInSandbox = Bool(argv[4]),
            let callbackId = String(argv[5])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.purchaseProduct(productId, quantity: quantity, atomically: atomically,
                                       applicationUsername: applicationUsername,
                                       simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox) { result in
            switch result {
            case .success(let purchase):
                self.purchaseResult[callbackId] = purchase
                self.dispatchEvent(name: StoreKitEvent.PURCHASE,
                                   value: JSON(StoreKitEvent(callbackId: callbackId)).description)

            case .error(let error):
                self.dispatchEvent(name: StoreKitEvent.PURCHASE,
                                   value: JSON(StoreKitEvent(callbackId: callbackId, error: error)).description)
            }
        }
        return nil
    }
    
    func getPurchaseProduct(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let purchase = purchaseResult[id] {
            let ret = purchase.toFREObject(id)
            if purchase.needsFinishTransaction == false {
                purchaseResult.removeValue(forKey: id)
            } else {
                productDownloads[id] = purchase.transaction.downloads
            }
            return ret
        }
        return nil
    }
    
    func finishTransaction(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let purchase = purchaseResult[id], purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
        if let purchase = restoredPurchases[id], purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
        if let purchase = pendingPurchases[id], purchase.needsFinishTransaction {
            SwiftyStoreKit.finishTransaction(purchase.transaction)
        }
        purchaseResult.removeValue(forKey: id)
        restoredPurchases.removeValue(forKey: id)
        pendingPurchases.removeValue(forKey: id)
        productDownloads.removeValue(forKey: id)
        return nil
    }
    
    func restorePurchases(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let atomically = Bool(argv[0]),
            let applicationUsername = String(argv[1]),
            let callbackId = String(argv[2])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.restorePurchases(atomically: atomically, applicationUsername: applicationUsername) { results in
            self.restoreResults[callbackId] = results
            self.dispatchEvent(name: StoreKitEvent.RESTORE,
                               value: JSON(StoreKitEvent(callbackId: callbackId)).description)
        }
        return nil
    }
    
    func getRestore(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let restore = restoreResults[id] {
            var ret = restore.toFREObject()
            ret?["restoredPurchases"] = FREArray(className: "com.tuarua.iap.storekit.Purchase",
                                                 length: restore.restoredPurchases.count,
                                                 fixed: true,
                                                 items: restore.restoredPurchases.map {
                                                    let pid = UUID().uuidString
                                                    if $0.needsFinishTransaction {
                                                        productDownloads[pid] = $0.transaction.downloads
                                                        restoredPurchases[pid] = $0
                                                    }
                                                    return $0.toFREObject(pid)})?.rawValue
            
            ret?["restoreFailedPurchases"] = FREArray(className: "Error",
                                                      length: restore.restoreFailedPurchases.count,
                                                      fixed: true,
                                                      items: restore.restoreFailedPurchases.map {
                                                        return FREObject(className: "Error",
                                                                         args: $0.0.localizedDescription,
                                                                         $0.0.errorCode)})?.rawValue
            restoreResults.removeValue(forKey: id)
            return ret
        }
        
        return nil
    }
    
    func fetchReceipt(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let forceRefresh = Bool(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.fetchReceipt(forceRefresh: forceRefresh) { result in
            switch result {
            case .success(let receiptData):
                self.dispatchEvent(name: StoreKitEvent.FETCH_RECEIPT,
                                   value: JSON(StoreKitEvent(callbackId: callbackId,
                                                             receiptData: receiptData)).description)
            case .error(let error):
                self.dispatchEvent(name: StoreKitEvent.FETCH_RECEIPT,
                                   value: JSON(StoreKitEvent(callbackId: callbackId, receiptError: error)).description)
            }
        }
        
        return nil
    }
    
    func verifyReceipt(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let service = String(argv[0]),
            let sharedSecret = String(argv[1]),
            let forceRefresh = Bool(argv[2]),
            let callbackId = String(argv[3])
            else {
                return FreArgError().getError()
        }
        var _service: AppleReceiptValidator.VerifyReceiptURLType = .production
        if service == AppleReceiptValidator.VerifyReceiptURLType.sandbox.rawValue {
            _service = .sandbox
        }
        
        let appleValidator = AppleReceiptValidator(service: _service, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: forceRefresh) { result in
            switch result {
            case .success(let receipt):
                self.dispatchEvent(name: StoreKitEvent.VERIFY_RECEIPT,
                                   value: JSON(StoreKitEvent(callbackId: callbackId, receipt: receipt)).description)
            case .error(let error):
                self.dispatchEvent(name: StoreKitEvent.VERIFY_RECEIPT,
                                   value: JSON(StoreKitEvent(callbackId: callbackId, receiptError: error)).description)
            }
        }
        return nil
    }
    
    func verifyPurchase(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let productId = String(argv[0]),
            let receipt: ReceiptInfo = Dictionary(argv[1])
            else {
                return FreArgError().getError()
        }
        let result = SwiftyStoreKit.verifyPurchase(productId: productId, inReceipt: receipt)
        if let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.VerifyPurchaseResult") {
            switch result {
            case .purchased(let item):
                ret.item = item
                ret.purchased = true
            case .notPurchased: break
            }
            return ret.rawValue
        }
        return nil
    }
    
    func verifySubscription(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let productId = String(argv[0]),
            let receipt: ReceiptInfo = Dictionary(argv[1]),
            let type = UInt(argv[2])
            else {
                return FreArgError().getError()
        }
        var result: VerifySubscriptionResult?
        switch type {
        case 0: // auto-renewable
            result = SwiftyStoreKit.verifySubscription(
                ofType: .autoRenewable,
                productId: productId,
                inReceipt: receipt)
        case 1: // nonRenewing
            result = SwiftyStoreKit.verifySubscription(
                ofType: .nonRenewing(validDuration: 3600 * 24 * 30),
                productId: productId,
                inReceipt: receipt)
        default: return nil
        }
        
        if let ret = FreObjectSwift(className: "com.tuarua.iap.storekit.VerifySubscriptionResult") {
            switch result {
            case .purchased(let expiryDate, let items):
                ret.purchased = true
                ret.expiryDate = expiryDate
                ret.items = items
            case .notPurchased: break
            case .expired(let expiryDate, let items):
                ret.expired = true
                ret.expiryDate = expiryDate
                ret.items = items
            case .none: break
            }
            return ret.rawValue
        }
        
        return nil
    }
    
    func start(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let downloads = productDownloads[id] {
            trace("starting downloads")
            SwiftyStoreKit.start(downloads)
        }
        return nil
    }
    
    func pause(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let downloads = productDownloads[id] {
            SwiftyStoreKit.pause(downloads)
        }
        return nil
    }
    
    func resume(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let downloads = productDownloads[id] {
            SwiftyStoreKit.resume(downloads)
        }
        return nil
    }
    
    func cancel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let downloads = productDownloads[id] {
            SwiftyStoreKit.cancel(downloads)
        }
        return nil
    }
}
