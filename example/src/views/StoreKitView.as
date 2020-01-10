package views {
import com.tuarua.InAppPurchase;
import com.tuarua.iap.StoreKit;
import com.tuarua.iap.storekit.FetchReceiptResult;
import com.tuarua.iap.storekit.PaymentTransactionState;
import com.tuarua.iap.storekit.Product;
import com.tuarua.iap.storekit.Purchase;
import com.tuarua.iap.storekit.PurchaseDetails;
import com.tuarua.iap.storekit.PurchaseError;
import com.tuarua.iap.storekit.Receipt;
import com.tuarua.iap.storekit.ReceiptError;
import com.tuarua.iap.storekit.ReceiptErrorType;
import com.tuarua.iap.storekit.ReceiptStatus;
import com.tuarua.iap.storekit.RestoreResults;
import com.tuarua.iap.storekit.RetrieveResults;
import com.tuarua.iap.storekit.SubscriptionType;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifyReceiptURLType;
import com.tuarua.iap.storekit.VerifySubscriptionResult;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class StoreKitView extends Sprite {
    private var storeKit:StoreKit;

    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var purchaseNonRenewSubBtn:SimpleButton = new SimpleButton("Purchase Non-Renew Sub");
    private var purchaseAutoRenewSubBtn:SimpleButton = new SimpleButton("Purchase Auto-Renew Sub");
    private var restorePurchasesBtn:SimpleButton = new SimpleButton("Restore Purchases");
    private var verifyReceiptBtn:SimpleButton = new SimpleButton("Verify Receipt");
    private static const SHARED_SECRET:String = "[SHARED_SECRET]";

    private static const PRODUCT_IDS:Vector.<String> = new <String>[
        "com.tuarua.storekitdemo.10Dolla",
        "com.tuarua.storekitdemo.RemoveAds",
        "com.tuarua.storekitdemo.NonRenewingSubscription",
        "com.tuarua.storekitdemo.AutoRenew"
    ];
    private static const CONSUMABLE_IDS:Vector.<String> = new <String>["com.tuarua.storekitdemo.10Dolla"];
    private var products:Vector.<Product>;

    public function StoreKitView() {
        storeKit = InAppPurchase.storeKit();
        if (!storeKit.canMakePayments) {
            trace("canMakePayments is false");
            return;
        }
/*
        App startup
        If there are any pending transactions on app startup, these will be reported here so that the app state and
        UI can be updated.*/
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
        purchaseNonRenewSubBtn.y = 260;
        purchaseAutoRenewSubBtn.y = 340;
        restorePurchasesBtn.y = 420;
        verifyReceiptBtn.y = 500;
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseConsumableClick);
        purchaseNonConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseNonConsumableTouch);
        restorePurchasesBtn.addEventListener(TouchEvent.TOUCH, onRestorePurchasesTouch);
        verifyReceiptBtn.addEventListener(TouchEvent.TOUCH, onVerifyReceiptTouch);

        purchaseNonRenewSubBtn.addEventListener(TouchEvent.TOUCH, onPurchaseNonRenewSubTouch);
        purchaseAutoRenewSubBtn.addEventListener(TouchEvent.TOUCH, onPurchaseAutoRenewSubTouch);
        purchaseAutoRenewSubBtn.x = purchaseNonRenewSubBtn.x = verifyReceiptBtn.x = restorePurchasesBtn.x = purchaseNonConsumableBtn.x = purchaseConsumableBtn.x = (stage.stageWidth - 200) / 2;

        addChild(purchaseConsumableBtn);
        addChild(purchaseNonConsumableBtn);
        addChild(purchaseNonRenewSubBtn);
        addChild(purchaseAutoRenewSubBtn);
        addChild(restorePurchasesBtn);
        addChild(verifyReceiptBtn);
    }

    private function onPurchaseConsumableClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            // What does atomic / non-atomic mean? https://github.com/bizz84/SwiftyStoreKit#what-does-atomic--non-atomic-mean
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

    private function onPurchaseNonRenewSubTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseNonRenewSubBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.purchaseProduct("com.tuarua.storekitdemo.NonRenewingSubscription", onPurchase, true);
        }
    }

    private function onPurchaseAutoRenewSubTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseAutoRenewSubBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.purchaseProduct("com.tuarua.storekitdemo.AutoRenew", onPurchase, true);
        }
    }

    private function onRestorePurchasesTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(restorePurchasesBtn, TouchPhase.ENDED);
        const atomically:Boolean = true;
        if (touch && touch.phase == TouchPhase.ENDED) {
            // See https://github.com/bizz84/SwiftyStoreKit#restore-previous-purchases
            storeKit.restorePurchases(atomically, function (results:RestoreResults):void {
                trace(results);
                if (results.restoreFailedPurchases.length > 0) {
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

    private function onVerifyReceiptTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(verifyReceiptBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            verifyReceipt();
        }
    }

    private function fetchReceipt():void {
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
            verifyReceipt();
        });
    }

    // Receipt verification https://github.com/bizz84/SwiftyStoreKit#receipt-verification
    private function verifyReceipt():void {
        storeKit.verifyReceipt(VerifyReceiptURLType.sandbox, SHARED_SECRET, function (receipt:Receipt, error:ReceiptError):void {
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
                    default:
                        trace(error.errorID, error.message);
                        break;
                        // etc
                }
                return;
            }

            trace("----------------------------------------------------------------------");
            trace(JSON.stringify(receipt, null, 4));
            trace("----------------------------------------------------------------------");

            if (receipt.status == ReceiptStatus.valid) {
                trace("The receipt is valid");
                // Verifying purchases and subscriptions https://github.com/bizz84/SwiftyStoreKit#verifying-purchases-and-subscriptions
                var verifyResult:VerifyPurchaseResult = storeKit.verifyPurchase("com.tuarua.storekitdemo.RemoveAds", receipt);
                trace("verifyResult.purchased:", verifyResult.purchased);
                if (verifyResult.item) trace(verifyResult.item.purchaseDate);

                // verify a previous subscription
                var verifySubscriptionResult:VerifySubscriptionResult = storeKit.verifySubscription("com.tuarua.storekitdemo.NonRenewingSubscription", receipt, SubscriptionType.nonRenewing);
                trace("Subscription purchased:", verifySubscriptionResult.purchased);
                trace("Subscription expired:", verifySubscriptionResult.expired);
                trace("Subscription end date:", verifySubscriptionResult.expiryDate);
            }

        })
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
        trace("Transaction needs finishing?:" + purchase.needsFinishTransaction);

        if (purchase.needsFinishTransaction) {
            trace("Finishing transaction !!");
            storeKit.finishTransaction(purchase.transaction);
        }

    }
}
}
