package com.tuarua.iap {

[RemoteClass(alias="com.tuarua.iap.RetrieveResults")]
public class RetrieveResults {
    public var retrievedProducts: Vector.<Product> = new Vector.<Product>();
    public var invalidProductIDs: Vector.<String> = new Vector.<String>();
    public var error:Error;
    public function RetrieveResults() {

    }
}
}