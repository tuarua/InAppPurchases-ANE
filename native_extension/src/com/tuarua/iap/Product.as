package com.tuarua.iap {
import flash.globalization.LocaleID;

[RemoteClass(alias="com.tuarua.iap.Product")]
public class Product {
    public var localizedTitle:String;
    public var localizedPrice:String;
    public var price:Number;
    public var localizedDescription:String;
    public var isDownloadable:Boolean;
    public var downloadContentLengths:Vector.<Number> = new Vector.<Number>();
    public var downloadContentVersion:String;
    public var priceLocale:LocaleID;
    public var productIdentifier:String;
    public var subscriptionGroupIdentifier:String;
    public var introductoryPrice:ProductDiscount;
    public var subscriptionPeriod:ProductSubscriptionPeriod;

    public function Product() {
    }
}
}