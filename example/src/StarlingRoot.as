package {

import com.tuarua.InAppPurchasesANE;
import com.tuarua.iap.PurchaseDetails;
import com.tuarua.iap.PurchaseError;
import com.tuarua.iap.RetrieveResults;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.SimpleButton;

public class StarlingRoot extends Sprite {
    private var getProductsBtn:SimpleButton = new SimpleButton("Get Products");
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var purchaseNonConsumableBtn:SimpleButton = new SimpleButton("Purchase Non-Consumable");
    private var iap:InAppPurchasesANE;

    public function StarlingRoot() {
        super();
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        iap = InAppPurchasesANE.iap;
        if (iap.canMakePayments) {
            initMenu();
        } else {
            trace("canMakePayments is false");
        }
    }

    private function initMenu():void {
        getProductsBtn.y = 100;
        purchaseConsumableBtn.y = 180;
        purchaseNonConsumableBtn.y = 260;
        getProductsBtn.addEventListener(TouchEvent.TOUCH, onGetProductsTouch);
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseConsumableTouch);
        purchaseNonConsumableBtn.addEventListener(TouchEvent.TOUCH, onPurchaseNonConsumableTouch);
        purchaseNonConsumableBtn.x = purchaseConsumableBtn.x = getProductsBtn.x = (stage.stageWidth - 200) / 2;

        addChild(getProductsBtn);
        addChild(purchaseConsumableBtn);
        addChild(purchaseNonConsumableBtn);
    }

    private function onGetProductsTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(getProductsBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            var products:Vector.<String> = new Vector.<String>();
            products.push("com.tuarua.storekitdemo.10Dolla");
            products.push("com.tuarua.storekitdemo.RemoveAds");
            iap.retrieveProductsInfo(products, function (result:RetrieveResults, error:PurchaseError):void {
                if (error != null) {
                    trace("Error", error.message);
                    trace("Error", error.errorID);
                    return;
                }
                trace(JSON.stringify(result, null, 4));
                trace(result.retrievedProducts.length);
            });
        }
    }

    private function onPurchaseConsumableTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            iap.purchaseProduct("com.tuarua.storekitdemo.10Dolla", onPurchase);
        }
    }

    private function onPurchaseNonConsumableTouch(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseNonConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            iap.purchaseProduct("com.tuarua.storekitdemo.RemoveAds", onPurchase);
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
        InAppPurchasesANE.dispose();
    }

}
}
