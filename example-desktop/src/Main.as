package {

import com.tuarua.FreSwift;
import com.tuarua.InAppPurchase;
import com.tuarua.iap.StoreKit;
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
import com.tuarua.iap.storekit.SubscriptionType;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifyReceiptURLType;
import com.tuarua.iap.storekit.VerifySubscriptionResult;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

import views.SimpleButton;

[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
public class Main extends Sprite {
    private var freSwiftANE:FreSwift = new FreSwift(); // must create before all others
    private var storeKit:StoreKit;
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var purchaseNonRenewSubBtn:SimpleButton = new SimpleButton("Purchase Non-Renew Sub");
    private var purchaseAutoRenewSubBtn:SimpleButton = new SimpleButton("Purchase Auto-Renew Sub");
    private var restorePurchasesBtn:SimpleButton = new SimpleButton("Restore Purchases");
    private var verifyReceiptBtn:SimpleButton = new SimpleButton("Verify Receipt");
    public static const FONT:Font = new FiraSansSemiBold();
    private var statusLabel:TextField = new TextField();

    private static const PRODUCT_IDS:Vector.<String> = new <String>[
        "com.tuarua.storekitdemo.mac.Consumable",
        "com.tuarua.storekitdemo.mac.NonConsumable",
        "com.tuarua.storekitdemo.mac.NonRenewingSubscription",
        "com.tuarua.storekitdemo.mac.AutoRenew"
    ];
    private static const CONSUMABLE_IDS:Vector.<String> = new <String>["com.tuarua.storekitdemo.mac.Consumable"];
    private var products:Vector.<Product>;

    private static const SHARED_SECRET:String = "[SHARED_SECRET]";

    public function Main() {
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        NativeApplication.nativeApplication.executeInBackground = true;
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
        start();
    }

    private function start():void {
        var tf:TextFormat = new TextFormat(Main.FONT.fontName, 13, 0x222222);
        tf.align = "center";
        tf.bold = false;

        statusLabel = new TextField();
        statusLabel.wordWrap = statusLabel.multiline = false;
        statusLabel.embedFonts = true;
        statusLabel.antiAliasType = AntiAliasType.ADVANCED;
        statusLabel.sharpness = -100;
        statusLabel.defaultTextFormat = tf;
        statusLabel.selectable = false;
        statusLabel.width = stage.stageWidth;

        purchaseConsumableBtn.addEventListener(MouseEvent.CLICK, onPurchaseConsumableClick);
        purchaseConsumableBtn.x = (stage.stageWidth - purchaseConsumableBtn.width) / 2;
        purchaseConsumableBtn.y = 50;

        purchaseNonConsumableBtn.addEventListener(MouseEvent.CLICK, onPurchaseNonConsumableClick);
        purchaseNonConsumableBtn.x = (stage.stageWidth - purchaseNonConsumableBtn.width) / 2;
        purchaseNonConsumableBtn.y = purchaseConsumableBtn.y + 80;

        purchaseNonRenewSubBtn.addEventListener(MouseEvent.CLICK, onPurchaseNonRenewSubClick);
        purchaseNonRenewSubBtn.x = (stage.stageWidth - purchaseNonRenewSubBtn.width) / 2;
        purchaseNonRenewSubBtn.y = purchaseNonConsumableBtn.y + 80;

        purchaseAutoRenewSubBtn.addEventListener(MouseEvent.CLICK, onPurchaseAutoRenewSubClick);
        purchaseAutoRenewSubBtn.x = (stage.stageWidth - purchaseAutoRenewSubBtn.width) / 2;
        purchaseAutoRenewSubBtn.y = purchaseNonRenewSubBtn.y + 80;

        restorePurchasesBtn.addEventListener(MouseEvent.CLICK, onRestorePurchasesClick);
        restorePurchasesBtn.x = (stage.stageWidth - restorePurchasesBtn.width) / 2;
        restorePurchasesBtn.y = purchaseAutoRenewSubBtn.y + 80;

        verifyReceiptBtn.addEventListener(MouseEvent.CLICK, onVerifyReceiptClick);
        verifyReceiptBtn.x = (stage.stageWidth - verifyReceiptBtn.width) / 2;
        verifyReceiptBtn.y = restorePurchasesBtn.y + 80;

        statusLabel.y = verifyReceiptBtn.y + 80;

        addChild(statusLabel);

        storeKit = InAppPurchase.storeKit();
        if (!storeKit.canMakePayments) {
            statusLabel.text = "canMakePayments is false";
            return;
        }

        addChild(purchaseConsumableBtn);
        addChild(purchaseNonConsumableBtn);
        addChild(purchaseNonRenewSubBtn);

        addChild(purchaseAutoRenewSubBtn);
        addChild(restorePurchasesBtn);
        addChild(verifyReceiptBtn);

    }

    private function onVerifyReceiptClick(event:MouseEvent):void {
        verifyReceipt();
    }

    private function onRestorePurchasesClick(event:MouseEvent):void {
        const atomically:Boolean = true;
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

    private function onPurchaseAutoRenewSubClick(event:MouseEvent):void {
        storeKit.purchaseProduct("com.tuarua.storekitdemo.mac.AutoRenew", onPurchase, true);
    }

    private function onPurchaseNonRenewSubClick(event:MouseEvent):void {
        storeKit.purchaseProduct("com.tuarua.storekitdemo.mac.NonRenewingSubscription", onPurchase, true);
    }

    private function onPurchaseConsumableClick(event:MouseEvent):void {
        storeKit.purchaseProduct("com.tuarua.storekitdemo.mac.Consumable", onPurchase, true);
    }

    private function onPurchaseNonConsumableClick(event:MouseEvent):void {
        // What does atomic / non-atomic mean? https://github.com/bizz84/SwiftyStoreKit#what-does-atomic--non-atomic-mean
        storeKit.purchaseProduct("com.tuarua.storekitdemo.mac.NonConsumable", onPurchase, false);
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
                var verifySubscriptionResult:VerifySubscriptionResult = storeKit.verifySubscription("com.tuarua.storekitdemo.NonRenewingSubscription",
                        receipt, SubscriptionType.nonRenewing);
                trace("Subscription purchased:", verifySubscriptionResult.purchased);
                trace("Subscription expired:", verifySubscriptionResult.expired);
                trace("Subscription end date:", verifySubscriptionResult.expiryDate);
            }

        })
    }

    private function onPurchase(purchase:PurchaseDetails, error:PurchaseError):void {
        statusLabel.text = "";
        if (error != null) {
            switch (error.errorID) {
                case PurchaseError.paymentCancelled:
                    statusLabel.text = "paymentCancelled: ";
                    break;
                case PurchaseError.storeProductNotAvailable:
                    statusLabel.text = "storeProductNotAvailable: ";
                    break;
            }
            statusLabel.text += error.message;
            return;
        }

        trace(JSON.stringify(purchase, null, 4));

        trace("-------------------------------------------");
        trace("Purchased", purchase.quantity, purchase.productId);
        trace("Date:", purchase.transaction.transactionDate);

        statusLabel.text = "Payment Transaction State: ";
        switch (purchase.transaction.transactionState) {
            case PaymentTransactionState.purchased:
                statusLabel.text += "purchased";
                break;
            case PaymentTransactionState.failed:
                statusLabel.text += "failed";
                break;
            case PaymentTransactionState.deferred:
                statusLabel.text += "deferred";
                break;
            case PaymentTransactionState.purchasing:
                statusLabel.text += "purchasing";
                break;
            case PaymentTransactionState.restored:
                statusLabel.text += "restored";
                break;
        }
        trace("Transaction needs finishing?:" + purchase.needsFinishTransaction);

        if (purchase.needsFinishTransaction) {
            trace("Finishing transaction !!");
            storeKit.finishTransaction(purchase.transaction);
        }

    }

    private function onExiting(event:Event):void {
        FreSwift.dispose();
        InAppPurchase.dispose();
    }
}
}
