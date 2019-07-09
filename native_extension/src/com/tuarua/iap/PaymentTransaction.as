package com.tuarua.iap {
[RemoteClass(alias="com.tuarua.iap.PaymentTransaction")]
public class PaymentTransaction {
    private var _id:String;
    public var transactionIdentifier:String;
    public var transactionDate:Date;
    public var transactionState:int;
    public var downloads:Vector.<Download> = new Vector.<Download>();

    public function PaymentTransaction(id:String) {
        this._id = id;
    }

    internal function get id():String {
        return _id;
    }
}
}
