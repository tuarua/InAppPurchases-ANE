package com.tuarua.inapppurchaseane.extensions

import com.adobe.fre.FREObject
import com.android.billingclient.api.AccountIdentifiers
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.set

fun AccountIdentifiers.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.iap.billing.AccountIdentifiers")
    ret["obfuscatedAccountId"] = this.obfuscatedAccountId
    ret["obfuscatedProfileId"] = this.obfuscatedProfileId
    return ret
}

operator fun FREObject?.set(name: String, value: AccountIdentifiers?) {
    this[name] = value?.toFREObject()
}