package com.tuarua.iap {
[RemoteClass(alias="com.tuarua.iap.PurchaseDetails")]
public class PurchaseDetails {
    private var _id:String;
    public var productId:String;
    public var quantity:int;
    public var product:Product;
    public var needsFinishTransaction:Boolean;
    public var transaction:PaymentTransaction;
    public var originalTransaction:PaymentTransaction;

    public function PurchaseDetails(id:String) {
        this._id = id;
    }

    public function get id():String {
        return _id;
    }
}
}