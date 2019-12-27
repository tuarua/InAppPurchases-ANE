package com.tuarua.iap.storekit {
[RemoteClass(alias="com.tuarua.iap.storekit.VerifySubscriptionResult")]
public class VerifySubscriptionResult {
    public var purchased:Boolean;
    public var expired:Boolean;
    public var items:Vector.<ReceiptItem> = new Vector.<ReceiptItem>();
    public var expiryDate:Date;
    public function VerifySubscriptionResult() {
    }
}
}
