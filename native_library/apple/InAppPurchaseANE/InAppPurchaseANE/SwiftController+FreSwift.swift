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
import SwiftyStoreKit

extension SwiftController: FreSwiftMainController {
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)createGUID"] = createGUID
        functionsToSet["\(prefix)retrieveProductsInfo"] = retrieveProductsInfo
        functionsToSet["\(prefix)getProductsInfo"] = getProductsInfo
        functionsToSet["\(prefix)canMakePayments"] = canMakePayments
        functionsToSet["\(prefix)purchaseProduct"] = purchaseProduct
        functionsToSet["\(prefix)getPurchaseProduct"] = getPurchaseProduct
        functionsToSet["\(prefix)finishTransaction"] = finishTransaction
        functionsToSet["\(prefix)verifyPurchase"] = verifyPurchase
        functionsToSet["\(prefix)verifyReceipt"] = verifyReceipt
        functionsToSet["\(prefix)verifySubscription"] = verifySubscription
        functionsToSet["\(prefix)fetchReceipt"] = fetchReceipt
        functionsToSet["\(prefix)restorePurchases"] = restorePurchases
        functionsToSet["\(prefix)getRestore"] = getRestore
        functionsToSet["\(prefix)start"] = start
        functionsToSet["\(prefix)pause"] = pause
        functionsToSet["\(prefix)resume"] = resume
        functionsToSet["\(prefix)cancel"] = cancel

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            self.launchPurchases = purchases
        }
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
        }
    }
    
    @objc public func dispose() {
    }
    
    // Must have these 3 functions.
    //Exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    //Here we set our FREContext
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
        FreSwiftLogger.shared.context = context
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
}
