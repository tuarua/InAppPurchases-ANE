package views {
import com.tuarua.InAppPurchase;
import com.tuarua.iap.BillingClient;
import com.tuarua.iap.billing.BillingResponseCode;
import com.tuarua.iap.billing.BillingResult;
import com.tuarua.iap.billing.FeatureType;
import com.tuarua.iap.billing.Purchase;
import com.tuarua.iap.billing.PurchaseHistoryRecord;
import com.tuarua.iap.billing.PurchaseState;
import com.tuarua.iap.billing.PurchasesResult;
import com.tuarua.iap.billing.SkuDetails;
import com.tuarua.iap.billing.SkuType;
import com.tuarua.iap.billing.events.BillingEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;


public class BillingView extends Sprite {
    private var getProductsBtn:SimpleButton = new SimpleButton("Get Products");
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var queryPurchasesBtn:SimpleButton = new SimpleButton("Query Purchases");
    private var billingClient:BillingClient;
    private var testSkuDetails:SkuDetails;

    public function BillingView() {
        billingClient = InAppPurchase.billing();
        billingClient.addEventListener(BillingEvent.ON_PURCHASES_UPDATED, onPurchasesUpdated);
        trace("billing.isReady", billingClient.isReady);

        if (!billingClient.isReady) {
            billingClient.startConnection(function (result:BillingResult):void {
                trace("billingSetUpFinished", result.responseCode, result.debugMessage);
                if (result.responseCode == BillingResponseCode.ok) {
                    if (billingClient.isFeatureSupported(FeatureType.inAppItemsOnVr).responseCode == BillingResponseCode.ok) {
                        trace("inAppItemsOnVr is supported");
                    }
                    if (billingClient.isFeatureSupported(FeatureType.subscriptions).responseCode == BillingResponseCode.ok) {
                        trace("subscriptions are supported");
                    }
                    initBillingMenu();
                }
            });
        }
    }

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

    private function onQuerySkuDetailsClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(getProductsBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            var skuList:Vector.<String> = new Vector.<String>();
            skuList.push("android.test.purchased");
            skuList.push("android.test.canceled");
            skuList.push("android.test.item_unavailable");

            billingClient.querySkuDetails(skuList, function (result:BillingResult, skuDetails:Vector.<SkuDetails>):void {
                trace(BillingResponseCode.asString(result.responseCode), result.debugMessage);
                if (result.responseCode === BillingResponseCode.ok) {
                    trace("result ok");
                    for each (var product:SkuDetails in skuDetails) {
                        trace(product.title, product.sku);
                        if (product.sku == "android.test.canceled") {
                            testSkuDetails = product;
                            purchaseConsumableBtn.visible = true;
                        }
                    }
                    if (skuDetails.length > 0) {
                        queryPurchasesBtn.visible = true;
                    }
                }
            })
        }
    }

    private function onQueryPurchasesClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(queryPurchasesBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
//            billingClient.queryPurchaseHistory(SkuType.inApp, function (result:BillingResult,
//                                                                        list:Vector.<PurchaseHistoryRecord>):void {
//                trace(result.responseCode, result.debugMessage);
//                switch (result.responseCode) {
//                    case BillingResponseCode.ok:
//                        trace("result ok");
//                        break;
//                    case BillingResponseCode.developerError:
//                        trace("result developerError");
//                        break;
//                    case BillingResponseCode.serviceDisconnected:
//                        trace("result serviceDisconnected");
//                        break;
//                }
//                trace(list.length);
//            });
//
//            return;
            var purchases:PurchasesResult = billingClient.queryPurchases();
            if (purchases.purchaseList.length == 0) return;
            var purchase:Purchase = purchases.purchaseList[0];
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

    private function onPurchasesUpdated(event:BillingEvent):void {
        var result:PurchasesResult = event.result;
        var billingResult:BillingResult = result.billingResult;
        var purchaseList:Vector.<Purchase> = result.purchaseList;

        trace(BillingResponseCode.asString(billingResult.responseCode), billingResult.debugMessage);
        trace("purchaseList.length", purchaseList.length);

        switch (billingResult.responseCode) {
            case BillingResponseCode.itemAlreadyOwned:
                trace("result userCancelled");
                // queryPurchases
                break;
            case BillingResponseCode.ok:

                trace("result ok, now consume the purchase");
                for each(var purchase:Purchase in purchaseList) {
                    if (purchase.purchaseState == PurchaseState.purchased) {
                        billingClient.consumePurchase(purchase, function (result:BillingResult, purchaseToken:String):void {
                            trace("consumePurchase callback");
                            trace(result.responseCode, result.debugMessage);
                            trace(purchaseToken);
                        });
                    }
                }
                break;
        }
    }
}
}
