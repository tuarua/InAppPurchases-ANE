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
/** The payment mode indicates if the discount price is charged one time, multiple times, or if the discount is a free trial.
 * The payment mode may determine the wording you choose to phrase the offer in your app's UI.*/
public final class ProductDiscountPaymentMode {
    /**
     * A constant indicating that the payment mode of a product discount is billed over a single or multiple billing periods.
     *
     * <p>With a pay as you go payment mode, users pay the discounted price at each billing period during the
     * discount period.</p>
     * */
    public static const payAsYouGo:uint = 0;
    /**
     *  A constant indicating that the payment mode of a product discount is paid up front.
     *
     * <p>With a pay up front payment mode, users pay the discounted price one time, and receive the
     * product for duration of the discount period.</p>
     * */
    public static const payUpFront:uint = 1;

    /**
     *  A constant that indicates that the payment mode is a free trial.
     *
     * <p>With a free trial payment mode, the price is 0, so users pay nothing during the discount period.</p>
     * */
    public static const freeTrial:uint = 2;

}
}
