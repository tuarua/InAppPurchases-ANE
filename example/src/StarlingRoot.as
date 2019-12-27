package {

import com.tuarua.InAppPurchase;
import com.tuarua.iap.BillingClient;
import com.tuarua.iap.StoreKit;
import com.tuarua.iap.billing.BillingResponseCode;
import com.tuarua.iap.billing.BillingResult;
import com.tuarua.iap.billing.FeatureType;
import com.tuarua.iap.billing.Purchase;
import com.tuarua.iap.billing.PurchaseState;
import com.tuarua.iap.billing.PurchasesResult;
import com.tuarua.iap.billing.SkuDetails;
import com.tuarua.iap.billing.SkuType;
import com.tuarua.iap.billing.events.BillingEvent;
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

import views.SimpleButton;

// https://medium.com/bleeding-edge/testing-in-app-purchases-on-android-a6de74f78878
// https://github.com/android/play-billing-samples/blob/261215d34b8551772df67abd6c8ab1c5d65b0405/TrivialDriveKotlin/app/src/main/java/com/kotlin/trivialdrive/billingrepo/BillingRepository.kt#L749

public class StarlingRoot extends Sprite {
    private var getProductsBtn:SimpleButton = new SimpleButton("Get Products");
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var queryPurchasesBtn:SimpleButton = new SimpleButton("Query Purchases");
    private var storeKit:StoreKit;
    private var billingClient:BillingClient;
    private var testSkuDetails:SkuDetails;

    public function StarlingRoot() {
        super();
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        if (os.isAndroid) {
            billingClient = InAppPurchase.billing();
            billingClient.addEventListener(BillingEvent.ON_PURCHASES_UPDATED, onPurchasesUpdated);
            trace("billing.isReady", billingClient.isReady);

//            var result1:BillingResult = billingClient.isFeatureSupported(FeatureType.inAppItemsOnVr);
//            trace(result1.responseCode, result1.debugMessage);
//
//            var result2:BillingResult = billingClient.isFeatureSupported(FeatureType.subscriptions);
//            trace(result2.responseCode, result2.debugMessage);

            if (!billingClient.isReady) {
                billingClient.startConnection(function (result:BillingResult):void {
                    trace("billingSetUpFinished", result.responseCode, result.debugMessage);
                    if (result.responseCode == BillingResponseCode.ok) {
                        initBillingMenu();
                    }

                });
            }
        } else if (os.isIos) {
            storeKit = InAppPurchase.storeKit();
            if (storeKit.canMakePayments) {
                initStoreKitMenu();
            } else {
                trace("canMakePayments is false");
            }
        }

    }


    // Android
    private function initBillingMenu():void {
        trace("initBillingMenu");
        queryPurchasesBtn.x = purchaseConsumableBtn.x = getProductsBtn.x = (stage.stageWidth - 200) / 2;

        getProductsBtn.y = 100;
        purchaseConsumableBtn.y = 180;
        queryPurchasesBtn.y = 260;

        getProductsBtn.addEventListener(TouchEvent.TOUCH, onQuerySkuDetailsClick);
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onLaunchBillingFlowClick);
        queryPurchasesBtn.addEventListener(TouchEvent.TOUCH, onQueryPurchasesClick);

        queryPurchasesBtn.visible = purchaseConsumableBtn.visible = false;

        addChild(getProductsBtn);
        addChild(purchaseConsumableBtn);
        addChild(queryPurchasesBtn);
    }

    private function onLaunchBillingFlowClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            billingClient.launchBillingFlow(testSkuDetails);
        }
    }

    private function onQueryPurchasesClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(queryPurchasesBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            var purchases:PurchasesResult = billingClient.queryPurchases();
            if(purchases.purchaseList.length == 0) return;
            var purchase:Purchase = purchases.purchaseList[0];
            trace(purchase.purchaseState);
            switch (purchase.purchaseState) {
                case PurchaseState.pending:
                    trace("PurchaseState.pending");
                    break;
                case PurchaseState.purchased:
                    trace("PurchaseState.purchased");
                    break;
                case PurchaseState.unspecified:
                    trace("PurchaseState.unspecified");
                    break;
            }
        }
    }

    private function onQuerySkuDetailsClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(getProductsBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            var skuList:Vector.<String> = new Vector.<String>();
            skuList.push("android.test.purchased");
            billingClient.querySkuDetails(skuList, function (result:BillingResult, skuDetails:Vector.<SkuDetails>):void {
                switch (result.responseCode) {
                    case BillingResponseCode.ok:
                        if (skuDetails.length > 0) {
                            testSkuDetails = skuDetails[0];
                            purchaseConsumableBtn.visible = true;
                            queryPurchasesBtn.visible = true;
                        }
                        trace("result ok");
                        break;
                    case BillingResponseCode.developerError:
                        trace("result developerError");
                        break;
                    case BillingResponseCode.serviceDisconnected:
                        trace("result serviceDisconnected");
                        break;

                }
            })
        }
    }

    private function onPurchasesUpdated(event:BillingEvent):void {
        var result:PurchasesResult = event.result;
        var billingResult:BillingResult = result.billingResult;
        var purchaseList:Vector.<Purchase> = result.purchaseList;


        trace(billingResult.responseCode, billingResult.debugMessage);
        trace("purchaseList.length", purchaseList.length);

        switch (billingResult.responseCode) {
            case BillingResponseCode.userCancelled:
                trace("result userCancelled");
                break;
            case BillingResponseCode.ok:
                trace("result ok, now consume the purchase");
                for each(var purchase:Purchase in purchaseList) {
                    if (purchase.purchaseState == PurchaseState.purchased) {
                        billingClient.consumePurchase(purchase.purchaseToken, function(result:BillingResult, purchaseToken:String):void {
                            trace("consumePurchase callback");
                            trace(result.responseCode, result.debugMessage);
                            trace(purchaseToken);
                        });
                    }
                }
                break;
            case BillingResponseCode.developerError:
                trace("result developerError");
                break;
            case BillingResponseCode.serviceDisconnected:
                trace("result serviceDisconnected");
                break;
            case BillingResponseCode.itemAlreadyOwned:
                trace("result itemAlreadyOwned");
                break;

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
