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

package com.tuarua.iap.storekit {
public final class PaymentTransactionState {
    /** Transaction is being added to the server queue. */
    public static const purchasing:int = 0;
    /** Transaction is in queue, user has been charged.  Client should complete the transaction.*/
    public static const purchased:int = 1;
    /** Transaction was cancelled or failed before being added to the server queue.*/
    public static const failed:int = 2;
    /** Transaction was restored from user's purchase history.  Client should complete the transaction.*/
    public static const restored:int = 3;
    /** The transaction is in the queue, but its final status is pending external action.*/
    public static const deferred:int = 4;
}
}
