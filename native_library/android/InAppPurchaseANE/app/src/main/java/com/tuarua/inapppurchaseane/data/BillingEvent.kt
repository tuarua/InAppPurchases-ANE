package com.tuarua.inapppurchaseane.data

data class BillingEvent(val callbackId:String?, val data: Map<String, Any?>? = null) {
    companion object {
        const val ON_CONSUME = "BillingEvent.onConsume"
        const val ON_PURCHASE_HISTORY = "BillingEvent.onPurchaseHistory"
        const val ON_PURCHASES_UPDATED = "BillingEvent.onPurchasesUpdated"
        const val ON_ACKNOWLEDGE_PURCHASE = "BillingEvent.onAcknowledgePurchase"
        const val ON_REWARDED_SKU = "BillingEvent.onLoadRewardedSku"
        const val ON_SETUP_FINISHED = "BillingEvent.onBillingSetupFinished"
        const val ON_SERVICE_DISCONNECTED = "BillingEvent.onBillingServiceDisconnected"
        const val ON_QUERY_SKU = "BillingEvent.onQuerySkuDetails"
    }
}