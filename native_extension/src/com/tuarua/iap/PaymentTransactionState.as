package com.tuarua.iap {
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
