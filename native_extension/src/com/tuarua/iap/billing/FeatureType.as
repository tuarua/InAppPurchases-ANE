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
public final class FeatureType {
    /** Purchase/query for subscriptions. */
    public static const subscriptions:String = "subscriptions";
    /** Subscriptions update/replace. */
    public static const subscriptionsUpdate:String = "subscriptionsUpdate";
    /** Purchase/query for in-app items on VR. */
    public static const inAppItemsOnVr:String = "inAppItemsOnVr";
    /** Purchase/query for subscriptions on VR. */
    public static const subscriptionsOnVr:String = "subscriptionsOnVr";
    /** Launch a price change confirmation flow. */
    public static const priceChangeConfirmation:String = "priceChangeConfirmation";
}
}