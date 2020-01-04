package views {
import com.tuarua.InAppPurchase;
import com.tuarua.iap.BillingClient;
import com.tuarua.iap.billing.BillingResponseCode;
import com.tuarua.iap.billing.BillingResult;
import com.tuarua.iap.billing.FeatureType;
import com.tuarua.iap.billing.Purchase;
import com.tuarua.iap.billing.PurchaseHistoryRecord;
import com.tuarua.iap.billing.PurchaseState;
import com.tuarua.iap.billing.PurchasesResult;
import com.tuarua.iap.billing.SkuDetails;
import com.tuarua.iap.billing.SkuType;
import com.tuarua.iap.billing.events.BillingEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

/**
 * Figure 4 -- Serverless billing integration
 *
 *  _____                        _________________
 * |Start|----------------------|launchBillingFlow|
 *  -----                        -----------------
 *                                        |
 *                                  ______v____________
 *                                 |onPurchasesUpdated |
 *                                  -------------------
 *                                 /      |
 *                   ITEM_ALREADY_OWNED   |
 *                               /        |
 *  _____       ________________v__       |
 * |Start|-----|  queryPurchases  |      OK
 *  -----       -------------------       |
 *                               \        |
 *                               v________v_______
 *                              |processPurchases |
 *                               -----------------
 *                                        |
 *                                        |
 *                                 _______v__________
 *                                | ? isConsumable?  |
 *                                 ------------------
 *                                 |           |
 *                                 |           |
 *                                 |        ___v___________________
 *                                 |       |  acknowledge purchase |
 *                              yes|        -----------------------
 *                _________________v__         |
 *               | processConsumables |        |
 *                --------------------         |
 *                             |               |
 *                             |               |
 *                             v_______________v________
 *                            |  disburse entitlements |
 *                             -------------------------
 *                                        |
 *                                        |
 *                         _______________v_____________________
 *                        |  API / Client Interface / ViewModel |
 *                        ---------------------------------------
 *
 *
 * Here is a bit more detail on the flow depicted in Figure 4:
 *
 * 1. [launchBillingFlow] and [queryPurchases] can be called directly from the client:
 *   [launchBillingFlow] may be triggered by a button click when the user wants to buy something;
 *   [queryPurchases] may be triggered when the app launches, by a pull-to-refresh or an
 *   [Activity] lifecycle event. Hence, they are the starting points in the process.
 *
 * 2. [onPurchasesUpdated] is the callback that the Play [BillingClient] calls in response to its
 *    [launcBillingFlow][BillingClient.launchBillingFlow] being called. If the response code is
 *    [BillingClient.BillingResponseCode.OK], then developers may go straight to [processPurchases]. If, however, the
 *    response code is [BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED], then developers should call
 *    [queryPurchases] to verify if other such already-owned items exist that should be
 *    processed.
 *
 * 3. The [queryPurchases] method grabs all the active purchases of this user and makes them
 *    available to this app instance. Calling Play's [BillingClient] multiple times is relatively
 *    cheap; it involves no network calls since Play stores the data in its own local cache. The
 *    purchase data is then [processed][processPurchases] and converted to
 *    [premium contents][Entitlement].
 *
 * 4. Finally, all data that end up as part of the public interface of the [BillingRepository]
 *    (i.e. in the [BillingViewModel]), and therefore in other portions of the app, come immediately
 *    from the local cache billing client. The local cache is backed by a [Room] database and all
 *    the data visible to the clients is wrapped in [LiveData] so that changes are reflected in
 *    the clients as soon as they happen.
 */

public class BillingView extends Sprite {
    private var purchaseConsumableBtn:SimpleButton = new SimpleButton("Purchase Consumable");
    private var billingClient:BillingClient;
    private var selectedSkuDetails:SkuDetails;
    private static const INAPP_SKUS:Vector.<String> = new <String>["android.test.purchased", "android.test.canceled", "android.test.item_unavailable"];
    private static const CONSUMABLE_SKUS:Vector.<String> = new <String>["android.test.purchased"];
    private static const SUBS_SKUS:Vector.<String> = new Vector.<String>();
    private static const LOG_TAG:String = "BillingRepository";
    private static const BASE_64_ENCODED_PUBLIC_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvtXpPwVCGGuXy3nxBOlhdQVB2DUkiR1s8QLYGqTb015kSFFu0CA1ZX2KYVQS3UXdWakiCB6igMJM8eGrU56Y1O2ZDSWHC8KHYU9JYspHnZz9ZVTxQyPao3buOTk6nDgm+QIhfIFUGoRe4IihQ6Y6j60KUxVUdUdy2fFczDK+YifGi35rf7qeZCkHeJr22iIhzgvHgr2W/ob+ASQuaf5BlIawsfNGxkTQrxMcsYZ2ESPZDVxvHbbsQQwt5DWb/k6UKC9Qlim7hXTq4wfCov+lo6/efyDznx89O/pAbaN3xTJvEshaMR9A+wAm7k7oeAOQRDiGont2zrITDuMYF0SyUwIDAQAB";

    public function BillingView() {
        billingClient = InAppPurchase.billing();
        billingClient.addEventListener(BillingEvent.ON_PURCHASES_UPDATED, onPurchasesUpdated);

        connectToPlayBillingService();
    }

    private function connectToPlayBillingService():Boolean {
        trace(LOG_TAG, "connectToPlayBillingService");
        if (!billingClient.isReady) {
            billingClient.startConnection(onBillingSetupFinished);
            return true
        }
        return false
    }

    /**
     * This method is called when the app has inadvertently disconnected from the [BillingClient].
     * An attempt should be made to reconnect using a retry policy. Note the distinction between
     * [endConnection][BillingClient.endConnection] and disconnected:
     * - disconnected means it's okay to try reconnecting.
     * - endConnection means the [playStoreBillingClient] must be re-instantiated and then start
     *   a new connection because a [BillingClient] instance is invalid after endConnection has
     *   been called.
     **/
    private function onBillingServiceDisconnected():void {
        trace(LOG_TAG, "onBillingServiceDisconnected");
        connectToPlayBillingService()
    }

    /**
     * This is the callback for when connection to the Play [BillingClient] has been successfully
     * established. It might make sense to get [SkuDetails] and [Purchases][Purchase] at this point.
     */
    private function onBillingSetupFinished(billingResult:BillingResult):void {
        switch (billingResult.responseCode) {
            case BillingResponseCode.ok:
                initMenu();
                querySkuDetails(SkuType.inApp, INAPP_SKUS);
                querySkuDetails(SkuType.subs, SUBS_SKUS);
                queryPurchases();
                break;
            case BillingResponseCode.billingUnavailable:
                //Some apps may choose to make decisions based on this knowledge.
                trace(LOG_TAG, BillingResponseCode.asString(billingResult.responseCode), billingResult.debugMessage);
                break;
            default:
                //do nothing. Someone else will connect it through retry policy.
                //May choose to send to server though
                trace(LOG_TAG, BillingResponseCode.asString(billingResult.responseCode), billingResult.debugMessage);
                break;
        }
    }

    /**
     * Presumably a set of SKUs has been defined on the Google Play Developer Console. This
     * method is for requesting a (improper) subset of those SKUs. Hence, the method accepts a list
     * of product IDs and returns the matching list of SkuDetails.
     *
     * The result is passed to [onSkuDetailsResponse]
     */
    private function querySkuDetails(skuType:String, skuList:Vector.<String>):void {
        trace(LOG_TAG, "querySkuDetails for" + skuType);
        billingClient.querySkuDetails(skuList, function (result:BillingResult, skuDetails:Vector.<SkuDetails>):void {
            trace(LOG_TAG, BillingResponseCode.asString(result.responseCode), result.debugMessage);
            if (result.responseCode === BillingResponseCode.ok) {
                // localCacheBillingClient.skuDetailsDao().insertOrUpdate(it)
                for each (var product:SkuDetails in skuDetails) {
                    if (product.sku == "android.test.purchased") {
                        selectedSkuDetails = product;
                        purchaseConsumableBtn.visible = true;
                    }
                }
            }
        });
    }

    /**
     * BACKGROUND
     *
     * Google Play Billing refers to receipts as [Purchases][Purchase]. So when a user buys
     * something, Play Billing returns a [Purchase] object that the app then uses to release the
     * [Entitlement] to the user. Receipts are pivotal within the [BillingRepositor]; but they are
     * not part of the repo’s public API, because clients don’t need to know about them. When
     * the release of entitlements occurs depends on the type of purchase. For consumable products,
     * the release may be deferred until after consumption by Google Play; for non-consumable
     * products and subscriptions, the release may be deferred until after
     * [BillingClient.acknowledgePurchase] is called. You should keep receipts in the local
     * cache for augmented security and for making some transactions easier.
     *
     * THIS METHOD
     *
     * This method grabs all the active purchases of this user and makes them
     * available to this app instance. Whereas this method plays a central role in the billing
     * system, it should be called at key junctures, such as when user the app starts.
     *
     * Because purchase data is vital to the rest of the app, this method is called each time
     * the [BillingViewModel] successfully establishes connection with the Play [BillingClient]:
     * the call comes through [onBillingSetupFinished]. Recall also from Figure 4 that this method
     * gets called from inside [onPurchasesUpdated] in the event that a purchase is "already
     * owned," which can happen if a user buys the item around the same time
     * on a different device.
     */
    private function queryPurchases():void {
        trace(LOG_TAG, "queryPurchases called");
        var purchasesResult:Vector.<Purchase> = new Vector.<Purchase>();
        var result:PurchasesResult = billingClient.queryPurchases(SkuType.inApp);
        trace(LOG_TAG, "queryPurchases INAPP results: " + result.purchaseList.length);
        for each (var purchase:Purchase in result.purchaseList) {
            purchasesResult.push(purchase);
        }
        if (isSubscriptionSupported()) {
            result = billingClient.queryPurchases(SkuType.subs);
            for each (var purchaseSub:Purchase in result.purchaseList) {
                purchasesResult.push(purchaseSub);
            }
            trace(LOG_TAG, "queryPurchases SUBS results: " + result.purchaseList.length);
        }
        processPurchases(purchasesResult);
    }

    /**
     * Checks if the user's device supports subscriptions
     */
    private function isSubscriptionSupported():Boolean {
        var billingResult:BillingResult = billingClient.isFeatureSupported(FeatureType.subscriptions);
        switch (billingResult.responseCode) {
            case BillingResponseCode.serviceDisconnected:
                connectToPlayBillingService();
                break;
            case BillingResponseCode.ok:
                return true;
            default:
                trace(LOG_TAG, "isSubscriptionSupported() error:", billingResult.debugMessage);
        }
        return false
    }

    private function processPurchases(purchasesResult:Vector.<Purchase>):void {
        trace(LOG_TAG, "processPurchases called");
        var validPurchases:Vector.<Purchase> = new Vector.<Purchase>(0);
        trace(LOG_TAG, "processPurchases newBatch content " + purchasesResult);

        for each(var purchase:Purchase in purchasesResult) {
            trace(purchase);
            if (purchase.purchaseState == PurchaseState.purchased) {
                // purchase.signature == "" is for test products
                if (purchase.signature == "" || billingClient.isSignatureValid(BASE_64_ENCODED_PUBLIC_KEY, purchase)) {
                    validPurchases.push(purchase)
                }
            } else if (purchase.purchaseState == PurchaseState.pending) {
                trace(LOG_TAG, "Received a pending purchase of SKU: " + purchase.sku);
                // handle pending purchases, e.g. confirm with users about the pending
                // purchases, prompt them to complete it, etc.
            }
        }
        trace(validPurchases);

        var consumables:Vector.<Purchase> = new Vector.<Purchase>();
        var nonConsumables:Vector.<Purchase> = new Vector.<Purchase>();
        for each(var validPurchase:Purchase in validPurchases) {
            if (CONSUMABLE_SKUS.indexOf(purchase.sku) > -1) {
                consumables.push(purchase);
            } else {
                nonConsumables.push(purchase);
            }
        }
        trace(LOG_TAG, "processPurchases consumables content " + consumables);
        trace(LOG_TAG, "processPurchases non-consumables content " + nonConsumables);
        /*
          As is being done in this sample, for extra reliability you may store the
          receipts/purchases to a your own remote/local database for until after you
          disburse entitlements. That way if the Google Play Billing library fails at any
          given point, you can independently verify whether entitlements were accurately
          disbursed. In this sample, the receipts are then removed upon entitlement
          disbursement.
         */
        // var testing = localCacheBillingClient.purchaseDao().getPurchases()
        // trace(LOG_TAG, "processPurchases purchases in the lcl db ${testing?.size}");
        // localCacheBillingClient.purchaseDao().insert(*validPurchases.toTypedArray())
        handleConsumablePurchases(consumables);
        acknowledgeNonConsumablePurchases(nonConsumables);
    }

    /**
     * Recall that Google Play Billing only supports two SKU types:
     * [in-app products][SkuType.INAPP] and
     * [subscriptions][SkuType.SUBS]. In-app products are actual items that a
     * user can buy, such as a house or food; subscriptions refer to services that a user must
     * pay for regularly, such as auto-insurance. Subscriptions are not consumable.
     *
     * Play Billing provides methods for consuming in-app products because they understand that
     * apps may sell items that users will keep forever (i.e. never consume) such as a house,
     * and consumable items that users will need to keep buying such as food. Nevertheless, Google
     * Play leaves the distinction for which in-app products are consumable entirely up to you.
     *
     * If an app wants its users to be able to keep buying an item, it must call
     * [BillingClient.consume] each time they buy it. This is because Google Play won't let
     * users buy items that they've previously bought but haven't consumed. In Trivial Drive, for
     * example, consumePurchase is called each time the user buys gas; otherwise they would never be
     * able to buy gas or drive again once the tank becomes empty.
     */
    private function handleConsumablePurchases(consumables:Vector.<Purchase>):void {
        trace(LOG_TAG, "handleConsumablePurchases called");
        consumables.forEach(function (purchase:Purchase, index:int, vector:Vector.<Purchase>):void {
            trace(LOG_TAG, "handleConsumablePurchases foreach it is " + purchase.originalJson);
            billingClient.consumePurchase(purchase, function (billingResult:BillingResult, purchaseToken:String):void {
                if (billingResult.responseCode === BillingResponseCode.ok) {
                    // Update the appropriate tables/databases to grant user the items
                    disburseConsumableEntitlements(purchase)
                } else {
                    trace(LOG_TAG, "consumePurchase response is " + billingResult.debugMessage);
                }
            });
        });
    }

    /**
     * If you do not acknowledge a purchase, the Google Play Store will provide a refund to the
     * users within a few days of the transaction. Therefore you have to implement
     * [BillingClient.acknowledgePurchase] inside your app.
     */
    private function acknowledgeNonConsumablePurchases(nonConsumables:Vector.<Purchase>):void {
        nonConsumables.forEach(function (purchase:Purchase, index:int, vector:Vector.<Purchase>):void {
            billingClient.acknowledgePurchase(purchase, function (billingResult:BillingResult):void {
                if (billingResult.responseCode === BillingResponseCode.ok) {
                    disburseNonConsumableEntitlement(purchase);
                } else {
                    trace(LOG_TAG, "acknowledgeNonConsumablePurchases response is " + billingResult.debugMessage);
                }
            });
        });
    }

    /**
     * This is the final step, where purchases/receipts are converted to premium contents.
     * In this sample, once the entitlement is disbursed the receipt is thrown out.
     */
    private function disburseNonConsumableEntitlement(purchase:Purchase):void {

    }

    private function disburseConsumableEntitlements(purchase:Purchase):void {

    }

    private function initMenu():void {
        purchaseConsumableBtn.x = (stage.stageWidth - 200) / 2;
        purchaseConsumableBtn.y = 100;
        purchaseConsumableBtn.addEventListener(TouchEvent.TOUCH, onLaunchBillingFlowClick);
        purchaseConsumableBtn.visible = false;
        addChild(purchaseConsumableBtn);
    }

    private function onLaunchBillingFlowClick(event:TouchEvent):void {
        event.stopPropagation();
        var touch:Touch = event.getTouch(purchaseConsumableBtn, TouchPhase.ENDED);
        if (touch && touch.phase == TouchPhase.ENDED) {
            billingClient.launchBillingFlow(selectedSkuDetails);
        }
    }

    /**
     * This method is called by the [playStoreBillingClient] when new purchases are detected.
     * The purchase list in this method is not the same as the one in
     * [queryPurchases][BillingClient.queryPurchases]. Whereas queryPurchases returns everything
     * this user owns, [onPurchasesUpdated] only returns the items that were just now purchased or
     * billed.
     *
     * The purchases provided here should be passed along to the secure server for
     * [verification](https://developer.android.com/google/play/billing/billing_library_overview#Verify)
     * and safekeeping. And if this purchase is consumable, it should be consumed, and the secure
     * server should be told of the consumption. All that is accomplished by calling
     * [queryPurchases].
     */
    private function onPurchasesUpdated(event:BillingEvent):void {
        var result:PurchasesResult = event.result;
        var billingResult:BillingResult = result.billingResult;
        var purchaseList:Vector.<Purchase> = result.purchaseList;

        trace(BillingResponseCode.asString(billingResult.responseCode), billingResult.debugMessage);
        switch (billingResult.responseCode) {
            case BillingResponseCode.ok:
                // will handle server verification, consumables, and updating the local cache
                processPurchases(purchaseList);
                break;
            case BillingResponseCode.itemAlreadyOwned:
                // item already owned? call queryPurchases to verify and process all such items
                trace(LOG_TAG, billingResult.debugMessage);
                queryPurchases();
                break;
            case BillingResponseCode.serviceDisconnected:
                connectToPlayBillingService();
                break;
            default:
                break;
        }
    }
}
}
