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
import SwiftyStoreKit
import SwiftyJSON

public class SwiftController: NSObject {
    public static var TAG = "InAppPurchaseANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var retrieveResults: [String: RetrieveResults] = [:]
    private var purchaseResult: [String: PurchaseDetails] = [:]
    private var restoreResults: [String: RestoreResults] = [:]
    private var receiptResults: [String: ReceiptInfo] = [:]
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
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
                                   value: JSON(["error": ["text": error.localizedDescription,
                                                          "id": 0]]).description)
                return
            }
            self.dispatchEvent(name: StoreKitEvent.PRODUCT_INFO,
                               value: JSON(["callbackId": callbackId]).description)
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
        retrieveResults.removeValue(forKey: id) //ok
        return ret
    }
    
    func canMakePayments(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return SwiftyStoreKit.canMakePayments.toFREObject()
    }
    
    func purchaseProduct(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let productId = String(argv[0]),
            let quantity = Int(argv[1]),
            let atomically = Bool(argv[2]),
            let callbackId = String(argv[3])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.purchaseProduct(productId, quantity: quantity, atomically: atomically) { result in
            switch result {
            case .success(let purchase):
                self.purchaseResult[callbackId] = purchase
                self.dispatchEvent(name: StoreKitEvent.PURCHASE,
                                   value: JSON(["callbackId": callbackId]).description)

            case .error(let error):
                self.dispatchEvent(name: StoreKitEvent.PURCHASE,
                                   value: JSON(["error": ["text": error.localizedDescription,
                                                          "id": error.code.rawValue]]).description)
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
            purchaseResult.removeValue(forKey: id)
        }
        return nil
    }
    
    func restorePurchases(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let atomically = Bool(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        SwiftyStoreKit.restorePurchases(atomically: atomically) { results in
            self.restoreResults[callbackId] = results
            self.dispatchEvent(name: StoreKitEvent.RESTORE,
                               value: JSON(["callbackId": callbackId]).description)
            
//            if results.restoreFailedPurchases.count > 0 {
//                self.trace("Restore Failed: \(results.restoreFailedPurchases)")
//            } else if results.restoredPurchases.count > 0 {
//                // TODO save restoredPurchases to dict and look for in finishTransaction
//                self.trace("Restore Success: \(results.restoredPurchases)")
//            } else {
//                self.trace("Nothing to Restore")
//            }
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
            trace("restore.restoredPurchases.count", restore.restoredPurchases.count)
            trace("restore.restoreFailedPurchases.count", restore.restoreFailedPurchases.count)
            let ret = restore.toFREObject(id)
//            if purchase.needsFinishTransaction == false {
//                purchaseResult.removeValue(forKey: id)
//            }
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
                                   value: JSON(["callbackId": callbackId,
                                   "receiptData": receiptData.base64EncodedString(options: [])]).description)
            case .error(let error):
                switch error {
                case .noReceiptData:
                    break
                case .noRemoteData:
                    break
                case .requestBodyEncodeError(let error):
                    self.trace("requestBodyEncodeError", error.localizedDescription)
                case .networkError(let error):
                    self.trace("networkError", error.localizedDescription)
                case .jsonDecodeError(let string):
                    self.trace("jsonDecodeError", string ?? "")
                case .receiptInvalid(let receipt, let status):
                    self.trace("receiptInvalid", receipt.debugDescription, status.rawValue)
                }
                self.dispatchEvent(name: StoreKitEvent.FETCH_RECEIPT,
                                   value: JSON(["callbackId": callbackId,
                                                "error": ["text": error.localizedDescription,
                                                          "id": 0]]).description)
                self.trace("Fetch receipt failed: \(error)")
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
                self.receiptResults[callbackId] = receipt
                self.dispatchEvent(name: StoreKitEvent.VERIFY_RECEIPT,
                                   value: JSON(["callbackId": callbackId]).description)
            case .error(let error):
                self.trace("Verify receipt failed: \(error)")
            }
        }
        return nil
    }
    
    func getReceipt(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let receipt = receiptResults[id] {
            //trace(receipt.keys)
            //trace(receipt.values)
            //trace(receipt.debugDescription)
            
            return JSON(receipt).description.toFREObject()
            
//            if var ret: FREObject = FREObject(className: "Object") {
//                for key in receipt.keys {
//                    let value = receipt[key]
//                    if value is FREObject {
//                        ret[key] = value as? FREObject
//                    } else if value is String {
//                        if let v = value as? String {
//                            ret[key] = v.toFREObject()
//                        }
//
//                    } else if value is Int {
//                        if let v = value as? Int {
//                            ret[key] = v.toFREObject()
//                        }
//
//                    } else if value is Double {
//                        if let v = value as? Double {
//                            ret[key] = v.toFREObject()
//                        }
//
//                    } else if value is Bool {
//                        if let v = value as? Bool {
//                            ret[key] = v.toFREObject()
//                        }
//
//                    }
//                }
//                return ret
//            }
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
                self.trace("purchased \(item.productId)")
                ret.item = item
                ret.purchased = true
            case .notPurchased:
                self.trace("notPurchased")
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
                ret.expiryDate = expiryDate.toFREObject()
                ret.items = items
            case .none: break
            }
            return ret.rawValue
        }
        
        return nil
    }
}

// TODO
// SwiftyStoreKit.start([SKDownload])

//public extension NSError {
//    func toDictionary() -> [String: Any] {
//        return ["text": self.localizedDescription, "id": self.code]
//    }
//}
