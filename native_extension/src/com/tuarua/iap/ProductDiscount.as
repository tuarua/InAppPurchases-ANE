package com.tuarua.iap {
import flash.globalization.LocaleID;

[RemoteClass(alias="com.tuarua.iap.ProductDiscount")]
public class ProductDiscount {
    public var numberOfPeriods:int;
    public var paymentMode:uint;
    public var price:Number;
    public var priceLocale:LocaleID;
    public var subscriptionPeriod:ProductSubscriptionPeriod;

    public function ProductDiscount() {
    }
}
}