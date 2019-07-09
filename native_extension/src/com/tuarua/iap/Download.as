package com.tuarua.iap {
[RemoteClass(alias="com.tuarua.iap.Download")]
public class Download {
    private var _id:String;
    public var contentIdentifier:String;
    public var contentLength:Number;
    public var contentURL:String;
    public var contentVersion:String;

    public function Download(id:String) {
        this._id = id;
    }

    public function get id():String {
        return _id;
    }
}
}
