/* Copyright 2018 Tua Rua Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

package com.tuarua.iap.billing {
public class SkuDetails {
    /** Returns the description of the product. */
    private var _description:String;
    /**
     * Trial period configured in Google Play Console, specified in ISO 8601 format. For example, P7D
     * equates to seven days. To learn more about free trial eligibility, see In-app Subscriptions.
     *
     * <p>Note: Returned only for subscriptions which have a trial period configured.
     */
    private var _freeTrialPeriod:String;
    /**
     * Returns the icon of the product if present.
     */
    private var _iconUrl:String;
    /**
     * Formatted introductory price of a subscription, including its currency sign, such as €3.99. The
     * price doesn't include tax.
     *
     * <p>Note: Returned only for subscriptions which have an introductory period configured.
     */
    private var _introductoryPrice:String;
    /**
     * Introductory price in micro-units. The currency is the same as price_currency_code.
     *
     * <p>Note: Returned only for subscriptions which have an introductory period configured.
     */
    private var _introductoryPriceAmountMicros:Number;
    /**
     * The number of subscription billing periods for which the user will be given the introductory
     * price, such as 3.
     *
     * <p>Note: Returned only for subscriptions which have an introductory period configured.
     */
    private var _introductoryPriceCycles:String;
    /**
     * The billing period of the introductory price, specified in ISO 8601 format.
     *
     * <p>Note: Returned only for subscriptions which have an introductory period configured.
     */
    private var _introductoryPricePeriod:String;
    /**
     * Returns true if sku is rewarded instead of paid.  If rewarded, developer should call
     * loadRewardedSku before attempting to launch purchase for in order to
     * ensure the reward is available to the user.
     */
    private var _isRewarded:Boolean;
    /** Returns a String in JSON format that contains Sku details. */
    private var _originalJson:String;
    /**
     * Returns formatted original price of the item, including its currency sign. The price does not
     * include tax.
     *
     * <p>The original price is the price of the item before any applicable sales have been applied.
     */
    private var _originalPrice:String;
    /**
     * Returns the original price in micro-units, where 1,000,000 micro-units equal one unit of the
     * currency.
     *
     * <p>The original price is the price of the item before any applicable sales have been applied.
     *
     * <p>For example, if original price is "€7.99", original_price_amount_micros is "7990000". This
     * value represents the localized, rounded price for a particular currency.
     */
    private var _originalPriceAmountMicros:Number;
    /**
     * Returns formatted price of the item, including its currency sign. The price does not include
     * tax.
     */
    private var _price:String;
    /**
     * Returns price in micro-units, where 1,000,000 micro-units equal one unit of the currency.
     *
     * <p>For example, if price is "€7.99", price_amount_micros is "7990000". This value represents
     * the localized, rounded price for a particular currency.
     */
    private var _priceAmountMicros:Number;
    /**
     * Returns ISO 4217 currency code for price and original price.
     *
     * <p>For example, if price is specified in British pounds sterling, price_currency_code is "GBP".
     */
    private var _priceCurrencyCode:String;
    /** Returns the product Id. */
    private var _sku:String;

    private var _skuDetailsToken:String;

    /**
     * Subscription period, specified in ISO 8601 format. For example, P1W equates to one week, P1M
     * equates to one month, P3M equates to three months, P6M equates to six months, and P1Y equates
     * to one year.
     *
     * <p>Note: Returned only for subscriptions.
     */
    private var _subscriptionPeriod:String;
    /** Returns the title of the product. */
    private var _title:String;
    /** Returns SKU type. */
    private var _type:String;

    public function SkuDetails(jsonSkuDetails:String = null) {
        var json:Object = JSON.parse(jsonSkuDetails);
        this._description = json["description"];
        this._freeTrialPeriod = json["freeTrialPeriod"];
        this._iconUrl = json["iconUrl"];
        this._introductoryPrice = json["introductoryPrice"];
        if (json.hasOwnProperty("introductoryPriceAmountMicros")) {
            this._introductoryPriceAmountMicros = json["introductoryPriceAmountMicros"];
        }
        this._introductoryPriceCycles = json["introductoryPriceCycles"];
        this._introductoryPricePeriod = json["introductoryPricePeriod"];
        this._isRewarded = json.hasOwnProperty("rewardToken");
        this._price = json["price"];
        this._priceAmountMicros = json["price_amount_micros"];
        this._originalJson = jsonSkuDetails;
        this._originalPrice = json.hasOwnProperty("original_price")
                ? json["original_price"]
                : this._price;
        this._originalPriceAmountMicros = json.hasOwnProperty("original_price_micros")
                ? json["original_price_micros"]
                : this._priceAmountMicros;
        this._priceCurrencyCode = json["price_currency_code"];
        this._sku = json["productId"];
        this._skuDetailsToken = json["skuDetailsToken"];
        this._subscriptionPeriod = json["subscriptionPeriod"];
        this._title = json["title"];
        this._type = json["type"];

    }

    public function get description():String {
        return _description;
    }

    public function get freeTrialPeriod():String {
        return _freeTrialPeriod;
    }

    public function get iconUrl():String {
        return _iconUrl;
    }

    public function get introductoryPrice():String {
        return _introductoryPrice;
    }

    public function get introductoryPriceAmountMicros():Number {
        return _introductoryPriceAmountMicros;
    }

    public function get introductoryPriceCycles():String {
        return _introductoryPriceCycles;
    }

    public function get introductoryPricePeriod():String {
        return _introductoryPricePeriod;
    }

    public function get isRewarded():Boolean {
        return _isRewarded;
    }

    public function get originalJson():String {
        return _originalJson;
    }

    public function get originalPrice():String {
        return _originalPrice;
    }

    public function get originalPriceAmountMicros():Number {
        return _originalPriceAmountMicros;
    }

    public function get price():String {
        return _price;
    }

    public function get priceAmountMicros():Number {
        return _priceAmountMicros;
    }

    public function get priceCurrencyCode():String {
        return _priceCurrencyCode;
    }

    public function get sku():String {
        return _sku;
    }

    public function get subscriptionPeriod():String {
        return _subscriptionPeriod;
    }

    public function get title():String {
        return _title;
    }

    public function get type():String {
        return _type;
    }

    public function get skuDetailsToken():String {
        return _skuDetailsToken;
    }
}
}
