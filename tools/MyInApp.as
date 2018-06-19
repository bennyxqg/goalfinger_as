package tools
{
    import __AS3__.vec.*;
    import com.milkmangames.nativeextensions.android.*;
    import com.milkmangames.nativeextensions.android.events.*;
    import menu.screens.*;

    public class MyInApp extends Object
    {
        public var isAvailable:Boolean = false;
        public var initDone:Boolean = false;
        public var vPriceList:Array;
        private var vGetPricesCallback:Function;
        private var vPurchaseCallback:Function;
        public var vPurchaseCode:String;
        private var vTransactionId:String;
        private var vInitAndroidCallback:Function;
        private var vAndroidIdGoogle2Sparks:Object;
        private var vAndroidItemId:String = "";
        public static const vPublicKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAgW9oGRdlOJkCJ6V4KAPlsyVrPj+6bYR1uyOo0X5yp0eyJYhrfVSLGm4q1HnFOktbKXNz8rhDxu8V/pelLUHt5DCysXK0QuFFX0MauPDOqJn6iE7YxV9QyFozzx9OhbutQQj8dvA/4v3GWiFsk6aHKiIdG0P2u5iFQemsATTG83wEtwUxm6FwrmoNXOCP4gW2tWaJuWlBDynb5av10qBP6xQ00q3Ey1YlJSSAG9y0S8N527bLBK8WywMPwRopZC+CpYNfKdMHKhAqpxm26RYELyKbC7s6l11+bLfa3NPcZMQFTU8FqUmY86PG16vJTKbrXT1XpKnU6ZR4GmLB40z3uwIDAQAB";

        public function MyInApp()
        {
            this.vPriceList = ["Gold_A", "Gold_B", "Gold_C", "Gold_D", "Gold_E", "Gold_E2", "Gold_F", "Gold_G", "Gold_H", "PromoPack_Starting", "PromoPack_Performance", "PromoPack_Competitor", "PromoPack_Ultimate"];
            if (AndroidIAB.isSupported())
            {
                AndroidIAB.create();
                ;
            }
            return;
        }// end function

        public function getPrices(param1:Function) : void
        {
            var _loc_4:* = null;
            this.vGetPricesCallback = param1;
            var _loc_2:* = new Vector.<String>;
            var _loc_3:* = 0;
            while (_loc_3 < this.vPriceList.length)
            {
                
                _loc_2.push(this.vPriceList[_loc_3]);
                _loc_3++;
            }
            if (!this.isAvailable)
            {
                param1.call(0, new Array());
                return;
            }
            this.vAndroidIdGoogle2Sparks = new Object();
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = _loc_2[_loc_3];
                _loc_2[_loc_3] = _loc_4.toLowerCase();
                this.vAndroidIdGoogle2Sparks[_loc_2[_loc_3]] = _loc_4;
                _loc_3++;
            }
            AndroidIAB.androidIAB.loadItemDetails(_loc_2);
            return;
        }// end function

        public function purchaseItem(param1:Function, param2:String) : void
        {
            if (!Shop.vCanInApp)
            {
                Global.addLogTrace("Shop.vCanInApp=" + Shop.vCanInApp, "MyInApp");
                return;
            }
            Shop.vCanInApp = false;
            this.vPurchaseCallback = param1;
            this.vPurchaseCode = param2;
            param2 = param2.toLowerCase();
            Global.addLogTrace("purchaseItem pCode=" + param2, "MyInApp");
            this.traceEvent("purchaseItem:" + param2);
            AndroidIAB.androidIAB.purchaseItem(param2);
            return;
        }// end function

        private function traceEvent(param1:String, param2:String = "", param3:int = 0) : void
        {
            return;
        }// end function

        private function onEndPurchase(param1:String, param2:String = "", param3:String = "") : void
        {
            Global.addLogTrace("onEndPurchase pCode=" + param1 + " pReceipt=" + param2 + " pSignature=" + param3, "MyInApp");
            if (this.vPurchaseCallback == null)
            {
                this.manualFinishTransaction();
                return;
            }
            this.vPurchaseCallback.call(0, param1, param2, param3);
            this.vPurchaseCallback = null;
            this.vAndroidItemId = "";
            Shop.vCanInApp = true;
            return;
        }// end function

        public function manualFinishTransaction() : void
        {
            return;
        }// end function

        public function initAndroid(param1:Function) : void
        {
            this.vInitAndroidCallback = param1;
            if (AndroidIAB.isSupported())
            {
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_READY, this.onAndroidReady);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.SERVICE_NOT_SUPPORTED, this.onAndroidUnsupported);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.ITEM_DETAILS_LOADED, this.onAndroidItemDetails);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.ITEM_DETAILS_FAILED, this.onAndroidDetailsFailed);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.PURCHASE_SUCCEEDED, this.onAndroidPurchaseSuccess);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.PURCHASE_FAILED, this.onAndroidPurchaseFailed);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.INVENTORY_LOADED, this.onAndroidInventoryLoaded);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.LOAD_INVENTORY_FAILED, this.onAndroidInventoryFailed);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingEvent.CONSUME_SUCCEEDED, this.onAndroidItemConsumed);
                AndroidIAB.androidIAB.addEventListener(AndroidBillingErrorEvent.CONSUME_FAILED, this.onAndroidConsumeFailed);
                AndroidIAB.androidIAB.startBillingService(vPublicKey);
            }
            else
            {
                this.isAvailable = false;
                this.vInitAndroidCallback.call(0, false);
            }
            this.initDone = true;
            return;
        }// end function

        private function onAndroidReady(event:AndroidBillingEvent) : void
        {
            Global.addLogTrace("service now ready- you can now make purchases.", "MyInApp");
            this.isAvailable = true;
            this.vInitAndroidCallback.call(0, true);
            return;
        }// end function

        private function onAndroidUnsupported(event:AndroidBillingEvent) : void
        {
            this.isAvailable = false;
            Global.addLogTrace("sorry, in app billing won\'t work on this phone!", "MyInApp");
            this.vInitAndroidCallback.call(0, false);
            return;
        }// end function

        private function onAndroidItemDetails(event:AndroidBillingEvent) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = new Array();
            for each (_loc_4 in event.itemDetails)
            {
                
                _loc_3 = new Object();
                _loc_3.code = this.vAndroidIdGoogle2Sparks[_loc_4.itemId];
                _loc_3.price = _loc_4.price;
                _loc_2.push(_loc_3);
            }
            this.vGetPricesCallback.call(0, _loc_2);
            return;
        }// end function

        private function onAndroidDetailsFailed(event:AndroidBillingErrorEvent) : void
        {
            Global.vStats.Stats_Error("inApp Android:" + event.text);
            this.vGetPricesCallback.call(0, new Array());
            return;
        }// end function

        private function onAndroidPurchaseSuccess(event:AndroidBillingEvent) : void
        {
            Global.addLogTrace("onAndroidPurchaseSuccess", "MyInApp");
            var _loc_2:* = event.purchases[0];
            this.vAndroidItemId = _loc_2.itemId;
            AndroidIAB.androidIAB.loadPlayerInventory();
            return;
        }// end function

        private function onAndroidPurchaseFailed(event:AndroidBillingErrorEvent) : void
        {
            Global.addLogTrace("onAndroidPurchaseFailed e.errorID=" + event.errorID + " e.text=" + event.text, "MyInApp");
            if (event.errorID == 7)
            {
                this.vAndroidItemId = event.itemId;
                AndroidIAB.androidIAB.loadPlayerInventory();
                return;
            }
            Global.addLogTrace("Something went wrong with the purchase of " + event.itemId + ": " + event.text, "MyInApp");
            this.onEndPurchase("fail");
            return;
        }// end function

        private function onAndroidInventoryLoaded(event:AndroidBillingEvent) : void
        {
            if (this.vAndroidItemId != "")
            {
                AndroidIAB.androidIAB.consumeItem(this.vAndroidItemId);
            }
            return;
        }// end function

        private function onAndroidInventoryFailed(event:AndroidBillingErrorEvent) : void
        {
            Global.vStats.Stats_Error("inApp onAndroidInventoryFailed:" + event.text);
            this.onEndPurchase("fail");
            return;
        }// end function

        private function onAndroidItemConsumed(event:AndroidBillingEvent) : void
        {
            this.onEndPurchase("ok", event.jsonData, event.signature);
            this.vAndroidItemId = "";
            return;
        }// end function

        private function onAndroidConsumeFailed(event:AndroidBillingErrorEvent) : void
        {
            return;
        }// end function

    }
}
