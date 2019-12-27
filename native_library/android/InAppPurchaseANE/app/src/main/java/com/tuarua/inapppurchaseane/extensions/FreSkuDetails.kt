package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.SkuDetails
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun SkuDetails(freObject: FREObject?): SkuDetails? {
    val rv = freObject ?: return null
    val json = String(rv["originalJson"])
    return SkuDetails(json)
}