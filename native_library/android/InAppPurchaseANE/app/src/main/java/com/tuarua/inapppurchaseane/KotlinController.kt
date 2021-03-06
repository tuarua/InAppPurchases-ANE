/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.inapppurchaseane

import android.app.Activity
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.android.billingclient.api.*
import com.android.billingclient.api.BillingClient.*
import com.google.gson.Gson
import com.tuarua.frekotlin.*
import com.tuarua.inapppurchaseane.data.BillingEvent
import com.tuarua.inapppurchaseane.extensions.Purchase
import com.tuarua.inapppurchaseane.extensions.SkuDetails
import com.tuarua.inapppurchaseane.extensions.toFREObject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController, PurchasesUpdatedListener {
    private lateinit var activity: Activity
    private lateinit var client: BillingClient
    private var purchasesUpdates: MutableMap<String, Pair<BillingResult, List<Purchase>?>> = mutableMapOf()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    override fun onPurchasesUpdated(billingResult: BillingResult, purchases: List<Purchase>?) {
        val uuid = UUID.randomUUID().toString()
        purchasesUpdates[uuid] = Pair(billingResult, purchases)
        dispatchEvent(BillingEvent.ON_PURCHASES_UPDATED, Gson().toJson(BillingEvent(uuid)))
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        activity = context?.activity ?: return FreException("No activity").getError()

        val builder = newBuilder(activity.applicationContext).setListener(this)
        builder.enablePendingPurchases()
        client = builder.build()
        return true.toFREObject()
    }

    fun startConnection(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()

        val finishedCallbackId = String(argv[0]) ?: return null
        val disconnectedCallbackId = String(argv[1])

        client.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                dispatchEvent(BillingEvent.ON_SETUP_FINISHED,
                        Gson().toJson(BillingEvent(finishedCallbackId,
                                mapOf("billingResult" to mapOf("debugMessage" to billingResult.debugMessage,
                                        "responseCode" to billingResult.responseCode))
                        ))
                )
            }

            override fun onBillingServiceDisconnected() {
                if (disconnectedCallbackId == null) return
                dispatchEvent(BillingEvent.ON_SERVICE_DISCONNECTED,
                        Gson().toJson(BillingEvent(disconnectedCallbackId))
                )
            }
        })

        return null
    }

    fun endConnection(ctx: FREContext, argv: FREArgv): FREObject? {
        if (client.isReady) client.endConnection()
        return null
    }

    fun isReady(ctx: FREContext, argv: FREArgv): FREObject? {
        return client.isReady.toFREObject()
    }

    fun isFeatureSupported(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val feature = String(argv[0]) ?: return null
        return client.isFeatureSupported(feature).toFREObject()
    }

    fun querySkuDetails(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val skuList = List<String>(argv[0])
        val skuType = String(argv[1]) ?: return null
        val callbackId = String(argv[2]) ?: return null

        val builder = SkuDetailsParams.newBuilder()
        builder.setSkusList(skuList)
        builder.setType(skuType)

        GlobalScope.launch(Dispatchers.IO) {
            val result = withContext(this.coroutineContext) {
                client.querySkuDetails(builder.build())
            }
            val billingResult = result.billingResult
            val skuDetailsList = result.skuDetailsList
            dispatchEvent(BillingEvent.ON_QUERY_SKU,
                    Gson().toJson(BillingEvent(callbackId,
                            mapOf("skuDetailsList" to skuDetailsList?.map { it.originalJson },
                                    "billingResult" to mapOf("debugMessage" to billingResult.debugMessage,
                                            "responseCode" to billingResult.responseCode))
                    ))
            )
        }

        return null
    }

    fun launchBillingFlow(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 4 } ?: return FreArgException()
        val skuDetails = SkuDetails(argv[0]) ?: return null
        val obfuscatedAccountId = String(argv[1])
        val obfuscatedProfileId = String(argv[2])
        val vrPurchaseFlow = Boolean(argv[3])
        val replaceSkusProrationMode = Int(argv[4])

        val builder = BillingFlowParams.newBuilder()
        builder.setSkuDetails(skuDetails)
        if (!obfuscatedAccountId.isNullOrEmpty()) builder.setObfuscatedAccountId(obfuscatedAccountId)
        if (!obfuscatedProfileId.isNullOrEmpty()) builder.setObfuscatedProfileId(obfuscatedProfileId)
        if (vrPurchaseFlow == true) builder.setVrPurchaseFlow(true)
        if (replaceSkusProrationMode != null && replaceSkusProrationMode > -1) {
            builder.setReplaceSkusProrationMode(replaceSkusProrationMode)
        }
        return client.launchBillingFlow(activity, builder.build()).toFREObject()
    }

    fun launchPriceChangeConfirmationFlow(ctx: FREContext, argv: FREArgv): FREObject? {
        val skuDetails = SkuDetails(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null

        val params = PriceChangeFlowParams.newBuilder().setSkuDetails(skuDetails).build()
        client.launchPriceChangeConfirmationFlow(activity, params) { result ->
            dispatchEvent(BillingEvent.ON_PRICE_CHANGE,
                    Gson().toJson(BillingEvent(callbackId,
                            mapOf("billingResult" to mapOf("debugMessage" to result.debugMessage,
                                    "responseCode" to result.responseCode))
                    ))
            )
        }
        return null
    }

    fun acknowledgePurchase(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val purchaseToken = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        val builder = AcknowledgePurchaseParams.newBuilder()
        builder.setPurchaseToken(purchaseToken)

        GlobalScope.launch(Dispatchers.IO) {
            val result = withContext(this.coroutineContext) {
                client.acknowledgePurchase(builder.build())
            }
            dispatchEvent(BillingEvent.ON_ACKNOWLEDGE_PURCHASE,
                    Gson().toJson(BillingEvent(callbackId,
                            mapOf("billingResult" to mapOf("debugMessage" to result.debugMessage,
                                    "responseCode" to result.responseCode))
                    ))
            )
        }

        return null
    }

    fun consumePurchase(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val token = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null

        val builder = ConsumeParams.newBuilder()
        builder.setPurchaseToken(token)

        GlobalScope.launch(Dispatchers.IO) {
            val result = withContext(this.coroutineContext) {
                client.consumePurchase(builder.build())
            }
            val purchaseToken = result.purchaseToken
            val billingResult = result.billingResult
            dispatchEvent(BillingEvent.ON_CONSUME,
                    Gson().toJson(BillingEvent(callbackId,
                            mapOf("purchaseToken" to purchaseToken,
                                    "billingResult" to mapOf("debugMessage" to billingResult.debugMessage,
                                            "responseCode" to billingResult.responseCode))
                    ))
            )
        }
        return null
    }

    fun queryPurchases(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val skuType = String(argv[0]) ?: return null
        return client.queryPurchases(skuType).toFREObject()
    }

    override fun dispose() {
        super.dispose()
        if (client.isReady) client.endConnection()
    }

    fun queryPurchaseHistory(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val skuType = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null

        GlobalScope.launch(Dispatchers.IO) {
            val result = withContext(this.coroutineContext) {
                client.queryPurchaseHistory(skuType)
            }
            val billingResult = result.billingResult
            val purchasesList = result.purchaseHistoryRecordList
            dispatchEvent(BillingEvent.ON_PURCHASE_HISTORY,
                    Gson().toJson(BillingEvent(callbackId,
                            mapOf("purchasesList" to purchasesList?.map {
                                mapOf("originalJson" to it.originalJson, "signature" to it.signature)
                            },
                                    "billingResult" to mapOf("debugMessage" to billingResult.debugMessage,
                                            "responseCode" to billingResult.responseCode))
                    ))
            )
        }
        return null
    }

    fun isSignatureValid(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val publicKey = String(argv[0]) ?: return null
        val purchase = Purchase(argv[1]) ?: return null
        return Security.verifyPurchase(publicKey, purchase.originalJson, purchase.signature).toFREObject()
    }

    fun getOnPurchasesUpdates(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val ret = purchasesUpdates[id]?.toFREObject()
        purchasesUpdates.remove(id)
        return ret
    }

    override val TAG: String
        get() = this::class.java.simpleName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }
}

