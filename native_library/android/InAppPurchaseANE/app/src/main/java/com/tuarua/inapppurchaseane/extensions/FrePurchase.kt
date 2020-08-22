@file:Suppress("FunctionName")

package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.Purchase
import com.tuarua.frekotlin.*
import java.util.*

fun Purchase.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.iap.billing.Purchase")
    ret["developerPayload"] = developerPayload
    ret["isAcknowledged"] = isAcknowledged
    ret["isAutoRenewing"] = isAutoRenewing
    ret["orderId"] = orderId
    ret["originalJson"] = originalJson
    ret["packageName"] = packageName
    ret["purchaseState"] = purchaseState
    ret["purchaseTime"] = Date(purchaseTime)
    ret["purchaseToken"] = purchaseToken
    ret["sku"] = sku
    ret["signature"] = signature
    ret["accountIdentifiers"] = accountIdentifiers
    return ret
}

fun Purchase(freObject: FREObject?): Purchase? {
    val rv = freObject ?: return null
    val s = String(rv["originalJson"]) ?: return null
    val s1 = String(rv["signature"]) ?: return null
    return Purchase(s, s1)
}