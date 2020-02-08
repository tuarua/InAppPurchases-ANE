package {

import com.tuarua.InAppPurchase;
import com.tuarua.utils.os;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.text.TextField;

import views.BillingView;

import views.StoreKitView;

// https://developer.android.com/google/play/billing/billing_testing#billing-testing-static
// https://medium.com/bleeding-edge/testing-in-app-purchases-on-android-a6de74f78878
// https://github.com/android/play-billing-samples/blob/261215d34b8551772df67abd6c8ab1c5d65b0405/TrivialDriveKotlin/app/src/main/java/com/kotlin/trivialdrive/billingrepo/BillingRepository.kt#L749
// https://developer.android.com/google/play/billing/billing_subscriptions

public class StarlingRoot extends Sprite {
    private var billingView:BillingView;
    private var storeKitView:StoreKitView;

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
            storeKitView = new StoreKitView();
            addChild(storeKitView);
        }
    }

    private static function onExiting(event:Event):void {
        InAppPurchase.dispose();
    }

}
}
