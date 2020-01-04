package views {
import com.tuarua.InAppPurchase;
import com.tuarua.iap.StoreKit;
import com.tuarua.iap.storekit.FetchReceiptResult;
import com.tuarua.iap.storekit.PaymentTransactionState;
import com.tuarua.iap.storekit.Product;
import com.tuarua.iap.storekit.Purchase;
import com.tuarua.iap.storekit.PurchaseDetails;
import com.tuarua.iap.storekit.PurchaseError;
import com.tuarua.iap.storekit.ReceiptError;
import com.tuarua.iap.storekit.ReceiptErrorType;
import com.tuarua.iap.storekit.ReceiptStatus;
import com.tuarua.iap.storekit.RestoreResults;
import com.tuarua.iap.storekit.RetrieveResults;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifyReceiptURLType;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class StoreKitView extends Sprite {
    private var storeKit:StoreKit;

    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var restorePurchasesBtn:SimpleButton = new SimpleButton("Restore Purchases");
    private var fetchReceiptBtn:SimpleButton = new SimpleButton("Fetch Receipt");

    private static const PRODUCT_IDS:Vector.<String> = new <String>["com.tuarua.storekitdemo.10Dolla", "com.tuarua.storekitdemo.RemoveAds"];
    private static const CONSUMABLE_IDS:Vector.<String> = new <String>["com.tuarua.storekitdemo.10Dolla"];
    private var products:Vector.<Product>;

    public function StoreKitView() {
        storeKit = InAppPurchase.storeKit();
        if (!storeKit.canMakePayments) {
            trace("canMakePayments is false");
            return;
        }
        for each(var purchase:Purchase in storeKit.pendingPurchases) {
            trace("pending product", purchase.productId);
            switch (purchase.transaction.transactionState) {
                case PaymentTransactionState.restored:
                case PaymentTransactionState.purchased:
                    if (purchase.needsFinishTransaction) {
                        // Deliver content from server, then:
                        storeKit.finishTransaction(purchase.transaction);
                    }
                    // Unlock content
                    break;
                case PaymentTransactionState.failed:
                case PaymentTransactionState.purchasing:
                case PaymentTransactionState.deferred:
                    break; // do nothing
            }
        }

        storeKit.retrieveProductsInfo(PRODUCT_IDS, function (result:RetrieveResults, error:PurchaseError):void {
            if (error != null) {
                trace("PurchaseError", error.message);
                trace("PurchaseError", error.errorID);
                return;
            }
            products = result.retrievedProducts;
            trace(JSON.stringify(result, null, 4));

            if (products.length > 0) {
                initMenu();
            }
        });
    }

    private static function isConsumable(product:Product):Boolean {
        return CONSUMABLE_IDS.indexOf(product.productIdentifier) > -1;
    }

    private function initMenu():void {
        purchaseConsumableBtn.y = 100;
        purchaseNonConsumableBtn.y = 180;
        restorePurchasesBtn.y = 260;
        fetchReceiptBtn.y = 340;
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseConsumableClick);
        purchaseNonConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseNonConsumableTouch);
        restorePurchasesBtn.addEventListener(TouchEvent.TOUCH, onRestorePurchasesTouch);
        fetchReceiptBtn.addEventListener(TouchEvent.TOUCH, onFetchReceiptTouch);
        fetchReceiptBtn.x = restorePurchasesBtn.x = purchaseNonConsumableBtn.x = purchaseConsumableBtn.x = (stage.stageWidth - 200) / 2;

        addChild(purchaseConsumableBtn);
        addChild(purchaseNonConsumableBtn);
        addChild(restorePurchasesBtn);
        addChild(fetchReceiptBtn);
    }

    private function onPurchaseConsumableClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.purchaseProduct("com.tuarua.storekitdemo.10Dolla", onPurchase, false);
        }
    }

    private function onPurchaseNonConsumableTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseNonConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.purchaseProduct("com.tuarua.storekitdemo.RemoveAds", onPurchase, true);
        }
    }

    private function onRestorePurchasesTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(restorePurchasesBtn, TouchPhase.ENDED);
        const atomically:Boolean = true;
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.restorePurchases(atomically, function (results:RestoreResults):void {
                trace(results);
                if (/*results.restoreFailedPurchases.length > 0*/ 1 == 0) {
                    trace("Restore failed")
                } else if (results.restoredPurchases.length > 0) {
                    trace("Restore success");
                    if (!atomically) {
                        for each(var purchase:Purchase in results.restoredPurchases) {
                            // fetch content from your server, then:
                            if (purchase.needsFinishTransaction) {
                                storeKit.finishTransaction(purchase.transaction)
                            }
                            // Unlock content
                        }
                    }
                } else {
                    trace("Nothing to Restore");
                }
            });
        }
    }

    private function onFetchReceiptTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(fetchReceiptBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.fetchReceipt(false, function (result:FetchReceiptResult, error:ReceiptError):void {
                if (error != null) {
                    switch (error.errorID) {
                        case ReceiptErrorType.receiptInvalid:
                            trace("receiptInvalid");
                            switch (error.status) {
                                case ReceiptStatus.receiptCouldNotBeAuthenticated:
                                    trace("receiptCouldNotBeAuthenticated");
                                    break;
                                case ReceiptStatus.malformedOrMissingData:
                                    trace("malformedOrMissingData");
                                    break;
                                    // etc
                            }
                            break;
                        case ReceiptErrorType.noReceiptData:
                            trace("noReceiptData");
                            break;
                        case ReceiptErrorType.networkError:
                            trace(error.message);
                            break;
                            // etc
                    }
                    return;
                }
                trace("receiptData", result.receiptData);
            });
        }
    }

    private function onPurchase(purchase:PurchaseDetails, error:PurchaseError):void {
        trace("onPurchase");
        if (error != null) {
            trace("Error", error.errorID, error.message);
            switch (error.errorID) {
                case PurchaseError.paymentCancelled:
                    trace("paymentCancelled");
                    break;
                case PurchaseError.storeProductNotAvailable:
                    trace("storeProductNotAvailable");
                    break;
            }
            return;
        }
        trace(JSON.stringify(purchase, null, 4));
        trace("-------------------------------------------");
        trace("Purchased", purchase.quantity, purchase.productId);
        trace("Date:", purchase.transaction.transactionDate);
        switch (purchase.transaction.transactionState) {
            case PaymentTransactionState.purchased:
                trace("Payment Transaction State:", "purchased");
                break;
            case PaymentTransactionState.failed:
                trace("Payment Transaction State:", "failed");
                break;
            case PaymentTransactionState.deferred:
                trace("Payment Transaction State:", "deferred");
                break;
            case PaymentTransactionState.purchasing:
                trace("Payment Transaction State:", "purchasing");
                break;
            case PaymentTransactionState.restored:
                trace("Payment Transaction State:", "restored");
                break;
        }
        trace("Transaction needs finishing:" + purchase.transaction.transactionState);

        if (purchase.needsFinishTransaction) {
            trace("Finishing transaction !!");
            storeKit.finishTransaction(purchase.transaction);
        }

    }
}
}
