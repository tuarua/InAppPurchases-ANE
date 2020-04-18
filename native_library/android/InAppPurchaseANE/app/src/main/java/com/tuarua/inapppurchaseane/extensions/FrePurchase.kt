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
    ret["accountIdentifiers"] = this.accountIdentifiers
    return ret
}

fun Purchase(freObject: FREObject?): Purchase? {
    val rv = freObject ?: return null
    return Purchase(String(rv["originalJson"]), String(rv["signature"]))
}