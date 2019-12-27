package com.tuarua.iap.billing.events {
import com.tuarua.iap.billing.PurchasesResult;

import flash.events.Event;

public class BillingEvent extends Event {
    public static const ON_PURCHASES_UPDATED:String = "BillingEvent.onPurchasesUpdated";
    private var _result:PurchasesResult;
    public function BillingEvent(type:String, result:PurchasesResult, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this._result = result;
    }

    public function get result():PurchasesResult {
        return _result;
    }
}
}
