/* Copyright 2019 Tua Rua Ltd.

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

package com.tuarua.iap.storekit {

[RemoteClass(alias="com.tuarua.iap.storekit.Product")]
public class Product {
    /** The name of the product. */
    public var localizedTitle:String;
    /** The cost of the product in the local currency. */
    public var localizedPrice:String;
    /** The cost of the product in the local currency. */
    public var price:Number;
    /** A description of the product. */
    public var localizedDescription:String;
    public var isDownloadable:Boolean;
    /** The lengths of the downloadable files available for this product. */
    public var downloadContentLengths:Vector.<Number> = new Vector.<Number>();
    /**
     * A string that identifies which version of the content is available for download.
     *
     * <p>The version string is formatted as a series of integers separated by periods.</p>
     * */
    public var downloadContentVersion:String;
    /** The locale used to format the price of the product. */
    public var priceLocale:Locale;
    /** The string that identifies the product to the Apple App Store. */
    public var productIdentifier:String;
    /**
     * The identifier of the subscription group to which the subscription belongs.
     *
     * <p>All auto-renewable subscriptions must be a part of a group. You create the group identifiers in App Store Connect.
     * This property is null if the Product is not an auto-renewable subscription.</p>
     * iOS 12.0+
     * */
    public var subscriptionGroupIdentifier:String;
    /**
     * The object containing introductory price information for the product.
     *
     * <p>If you've set up introductory prices in App Store Connect, the introductory price property will be populated.
     * This property is null if the product has no introductory price.
     * Before displaying UI that offers the introductory price, you must first determine if the user is eligible to
     * receive it. See Implementing Introductory Offers in Your App for information on determining eligibility and
     * displaying introductory prices.</p>
     * iOS 11.2+
     * */
    public var introductoryPrice:ProductDiscount;
    /**
     * The period details for products that are subscriptions.
     *
     * <p>This read-only property is null if the product is not a subscription.
     * A subscription period is described in terms of a unit and the number of units that make up a single period.</p>
     * iOS 11.2+
     * */
    public var subscriptionPeriod:ProductSubscriptionPeriod;

    public function Product() {
    }
}
}