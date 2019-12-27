package com.tuarua.iap.storekit {
public class FetchReceiptResult {
    private var _receiptData:String;
    private var _receiptError:ReceiptError;

    public function FetchReceiptResult(receiptData:String, receiptError:ReceiptError = null) {
        this._receiptData = receiptData;
        this._receiptError = receiptError;
    }

    public function get receiptData():String {
        return _receiptData;
    }

    public function get receiptError():ReceiptError {
        return _receiptError;
    }
}
}
