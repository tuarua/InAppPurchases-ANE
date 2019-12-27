package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.BillingResult
import com.tuarua.frekotlin.FREObject

fun BillingResult.toFREObject(): FREObject? {
    return FREObject("com.tuarua.iap.billing.BillingResult", responseCode, debugMessage)
}
