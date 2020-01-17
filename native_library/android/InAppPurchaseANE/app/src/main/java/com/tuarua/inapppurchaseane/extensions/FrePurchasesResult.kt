package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.Purchase
import com.tuarua.frekotlin.FREArray
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.set

fun Purchase.PurchasesResult.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.iap.billing.PurchasesResult")
    ret["billingResult"] = this.billingResult.toFREObject()
    ret["purchaseList"] = FREArray("com.tuarua.iap.billing.Purchase",
            purchasesList.size, true, items = purchasesList.map { it.toFREObject() })
    return ret
}

fun Pair<BillingResult, List<Purchase>?>.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.iap.billing.PurchasesResult") ?: return null
    ret["billingResult"] = this.first.toFREObject()
    ret["purchaseList"] = FREArray("com.tuarua.iap.billing.Purchase",
            this.second?.size ?: 0, true,
            this.second?.map { it.toFREObject() })
    return ret
}