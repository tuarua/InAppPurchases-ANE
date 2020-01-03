package {

import com.tuarua.InAppPurchase;
import com.tuarua.iap.StoreKit;
import com.tuarua.iap.storekit.FetchReceiptResult;
import com.tuarua.iap.storekit.PurchaseDetails;
import com.tuarua.iap.storekit.PurchaseError;
import com.tuarua.iap.storekit.RestoreResults;
import com.tuarua.iap.storekit.RetrieveResults;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifyReceiptURLType;
import com.tuarua.utils.os;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.BillingView;

import views.SimpleButton;

// https://developer.android.com/google/play/billing/billing_testing#billing-testing-static
// https://medium.com/bleeding-edge/testing-in-app-purchases-on-android-a6de74f78878
// https://github.com/android/play-billing-samples/blob/261215d34b8551772df67abd6c8ab1c5d65b0405/TrivialDriveKotlin/app/src/main/java/com/kotlin/trivialdrive/billingrepo/BillingRepository.kt#L749
// https://developer.android.com/google/play/billing/billing_subscriptions

public class StarlingRoot extends Sprite {
    private var getProductsBtn:SimpleButton = new SimpleButton("Get Products");
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var queryPurchasesBtn:SimpleButton = new SimpleButton("Query Purchases");
    private var storeKit:StoreKit;

    private var billingView:BillingView;

    public function StarlingRoot() {
        super();
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        if (os.isAndroid) {
            billingView = new BillingView();
            addChild(billingView);
        } else if (os.isIos) {
            storeKit = InAppPurchase.storeKit();
            if (storeKit.canMakePayments) {
                initStoreKitMenu();
            } else {
                trace("canMakePayments is false");
            }
        }
    }


    // IOS
    private function initStoreKitMenu():void {
        getProductsBtn.y = 100;
        purchaseConsumableBtn.y = 180;
        purchaseNonConsumableBtn.y = 260;
        getProductsBtn.addEventListener(TouchEvent.TOUCH, onGetProductsClick);
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseConsumableClick);
        purchaseNonConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseNonConsumableTouch);
        purchaseNonConsumableBtn.x = purchaseConsumableBtn.x = getProductsBtn.x = (stage.stageWidth - 200) / 2;

        addChild(getProductsBtn);
        addChild(purchaseConsumableBtn);
        addChild(purchaseNonConsumableBtn);
    }

    private function onGetProductsClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(getProductsBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.fetchReceipt(true, function (result:FetchReceiptResult):void {
                storeKit.verifyReceipt(VerifyReceiptURLType.sandbox, result.receiptData, function (receipt:String):void {
//                    trace("what", receipt);
//                    trace("");

                    var r:VerifyPurchaseResult = storeKit.verifyPurchase("com.tuarua.storekitdemo.10Dolla", JSON.parse(receipt));
//                    trace("r.purchased", r.purchased);
//                    trace(r.item);
                    trace("");

                }, true);
                // trace(result.receiptData);
                // trace(result.receiptError);
            });

//            var products:Vector.<String> = new Vector.<String>();
//            products.push("com.tuarua.storekitdemo.10Dolla");
//            products.push("com.tuarua.storekitdemo.RemoveAds");
//            storeKit.retrieveProductsInfo(products, function (result:RetrieveResults, error:PurchaseError):void {
//                if (error != null) {
//                    trace("Error", error.message);
//                    trace("Error", error.errorID);
//                    return;
//                }
//                trace(JSON.stringify(result, null, 4));
//                trace(result.retrievedProducts.length);
//            });
        }
    }

    private function onPurchaseConsumableClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
//            storeKit.restorePurchases(true, function (result:RestoreResults):void {
//                trace(result.restoredPurchases.length);
//                for each(var p:Purchase in result.restoredPurchases) {
//                    trace(p.sku);
//                    trace(p.originalJson)
//                }
//            });
            storeKit.purchaseProduct("com.tuarua.storekitdemo.10Dolla", onPurchase);
        }
    }

    private function onPurchaseNonConsumableTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseNonConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            storeKit.purchaseProduct("com.tuarua.storekitdemo.RemoveAds", onPurchase);
        }
    }

    private function onPurchase(details:PurchaseDetails, error:PurchaseError):void {
        if (error != null) {
            trace("Error", error.message);
            trace("Error", error.errorID);
            return;
        }
        trace(JSON.stringify(details, null, 4));
    }

    private static function onExiting(event:Event):void {
        InAppPurchase.dispose();
    }

}
}
