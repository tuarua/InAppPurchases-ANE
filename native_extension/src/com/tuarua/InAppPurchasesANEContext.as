package com.tuarua {
import com.tuarua.fre.ANEError;
import com.tuarua.iap.PurchaseError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

/** @private */
public class InAppPurchasesANEContext {
    internal static const NAME:String = "InAppPurchasesANE";
    internal static const TRACE:String = "TRACE";

    private static const PRODUCT_INFO:String = "InAppPurchaseEvent.ProductInfo";
    private static const PURCHASE:String = "InAppPurchaseEvent.Purchase";
    private static const RESTORE:String = "InAppPurchaseEvent.Restore";

    public static var closures:Dictionary = new Dictionary();
    public static var closureCallers:Dictionary = new Dictionary();
    private static var _context:ExtensionContext;
    private static var _isDisposed:Boolean;
    private static var argsAsJSON:Object;

    public function InAppPurchasesANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isDisposed = false;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createEventId(listener:Function):String{
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        var closure:Function;
        var ret:* = null;
        var err:PurchaseError = null;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case PRODUCT_INFO:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new PurchaseError(pObj.error.text, pObj.error.id);
                    } else {
                        ret = _context.call("getProductsInfo", pObj.eventId);
                    }
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    closure.call(null, ret, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case PURCHASE:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;

                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new PurchaseError(pObj.error.text, pObj.error.id);
                    } else {
                        ret = _context.call("getPurchaseProduct", pObj.eventId);
                    }
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    closure.call(null, ret, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case RESTORE:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    ret = _context.call("getRestore", pObj.eventId);
                    if (ret is ANEError) {
                        printANEError(ret as ANEError);
                        return;
                    }
                    closure.call(null, ret);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    /** @private */
    private static function printANEError(error:ANEError):void {
        trace("[" + NAME + "] Error: ", error.type, error.errorID, "\n", error.source, "\n", error.getStackTrace());
    }

    public static function dispose():void {
        if (_context == null) return;
        _isDisposed = true;
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
    }

    public static function get isDisposed():Boolean {
        return _isDisposed;
    }

}
}
