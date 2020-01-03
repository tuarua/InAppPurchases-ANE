package views {
import com.tuarua.InAppPurchase;
import com.tuarua.iap.StoreKit;
import com.tuarua.iap.storekit.FetchReceiptResult;
import com.tuarua.iap.storekit.PurchaseDetails;
import com.tuarua.iap.storekit.PurchaseError;
import com.tuarua.iap.storekit.VerifyPurchaseResult;
import com.tuarua.iap.storekit.VerifyReceiptURLType;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class StoreKitView extends Sprite {
    private var storeKit:StoreKit;
    private var getProductsBtn:SimpleButton = new SimpleButton("Get Products");
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");

    public function StoreKitView() {
        storeKit = InAppPurchase.storeKit();
        if (!storeKit.canMakePayments) {
            trace("canMakePayments is false");
            return;
        }
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
}
}
