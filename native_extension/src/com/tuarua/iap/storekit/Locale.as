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
public class Locale {
    /**
     * Returns the currency code of the locale.
     *
     * <p>For example, for "zh-Hant-HK", returns "HKD".</p>
     */
    public var currencyCode:String;
    /**
     * Returns the currency symbol of the locale.
     *
     * <p>For example, for "zh-Hant-HK", returns "HK$".</p>
     */
    public var currencySymbol:String;
    /** Returns the identifier of the locale. */
    public var identifier:String;
    public function Locale() {
    }
}
}
