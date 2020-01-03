@file:Suppress("FunctionName")

package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.Purchase
import com.tuarua.frekotlin.*
import java.util.*

fun Purchase.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.iap.billing.Purchase")
    ret["developerPayload"] = developerPayload?.toFREObject()
    ret["isAcknowledged"] = isAcknowledged.toFREObject()
    ret["isAutoRenewing"] = isAutoRenewing.toFREObject()
    ret["orderId"] = orderId.toFREObject()
    ret["originalJson"] = originalJson.toFREObject()
    ret["packageName"] = packageName.toFREObject()
    ret["purchaseState"] = purchaseState.toFREObject()
    ret["purchaseTime"] = Date(purchaseTime).toFREObject()
    ret["purchaseToken"] = purchaseToken.toFREObject()
    ret["sku"] = sku.toFREObject()
    ret["signature"] = signature.toFREObject()
    return ret
}

fun Purchase(freObject: FREObject?): Purchase? {
    val rv = freObject ?: return null
    return Purchase(String(rv["originalJson"]), String(rv["signature"]))
}