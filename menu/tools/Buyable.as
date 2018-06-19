package menu.tools
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import globz.*;
    import menu.screens.*;
    import tools.*;

    public class Buyable extends Sprite
    {
        private var vShop:Shop;
        private var vType:String;
        public var vCode:String;
        private var vPrice:String;
        private var vPriceValue:int;
        private var vNb:int;
        private var vItem:ShopItem;
        private var vTitle:String;
        private var vCanBuy:Boolean;
        private var vBuyDirect:Boolean = false;
        private var vActionCondition:Function;
        private var vStatTimer:int;

        public function Buyable(param1:Shop, param2:String, param3:String, param4:String, param5:int, param6:int = 0) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            this.vShop = param1;
            this.vType = param2;
            this.vCode = param3;
            this.vNb = param5;
            this.vPrice = param4;
            this.vItem = new ShopItem();
            addChild(this.vItem);
            if (param2 == "Gold")
            {
                _loc_8 = buildGraf(param2, param3, param5);
                this.vItem.gotoAndStop(2);
                _loc_10 = param3.split("_")[1];
                this.vTitle = Global.getText("txtPack" + _loc_10);
                _loc_11 = new SparkleAnimation(2);
                var _loc_15:* = 0.8;
                _loc_11.scaleY = 0.8;
                _loc_11.scaleX = _loc_15;
                _loc_8.addChild(_loc_11);
            }
            else if (param2 == "Card")
            {
                _loc_8 = buildGraf(param2, param3, 0);
                this.vTitle = Card.getTitle(param3);
            }
            else if (param2 == "Pack")
            {
                _loc_8 = buildGraf(param2, param3, this.vNb);
                _loc_12 = param3.split("_");
                if (_loc_12.length == 1)
                {
                    if (this.vNb == 1)
                    {
                        this.vTitle = Global.getText("txtPack1");
                    }
                    else
                    {
                        this.vTitle = Global.getText("txtPackN").replace(/#/, this.vNb.toString());
                    }
                }
                else
                {
                    _loc_13 = _loc_12[1];
                    this.vTitle = Global.getText("txtPack_" + _loc_13);
                }
            }
            else
            {
                Global.addLogTrace("Buyable unknown type=" + this.vType, "Buyable");
                return;
            }
            _loc_8.x = this.vItem.mcCard.x;
            _loc_8.y = this.vItem.mcCard.y;
            var _loc_15:* = this.vItem.mcCard.scaleX;
            _loc_8.scaleY = this.vItem.mcCard.scaleX;
            _loc_8.scaleX = _loc_15;
            this.vItem.addChild(_loc_8);
            this.vItem.txtTitle.htmlText = "<B>" + this.vTitle + "</B>";
            Global.vLang.checkSans(this.vItem.txtTitle);
            Toolz.textReduce(this.vItem.txtTitle);
            var _loc_9:* = false;
            if (this.vType == "Gold")
            {
                _loc_9 = true;
            }
            else if (Global.vServer.vUser.vHardCurrency >= parseInt(this.vPrice))
            {
                _loc_9 = true;
            }
            this.setPrice(this.vPrice);
            if (Capabilities.isDebugger)
            {
                this.vItem.addEventListener(MouseEvent.CLICK, this.buyGood);
            }
            else
            {
                this.vItem.addEventListener(TouchEvent.TOUCH_TAP, this.buyGood);
            }
            this.vCanBuy = _loc_9;
            if (!_loc_9)
            {
                this.vItem.txtGold.textColor = 16711680;
            }
            if (param6 > 0)
            {
                this.vBuyDirect = true;
                _loc_14 = new Countdown(this.reloadStore, param6);
                _loc_14.setRefreshIcon();
                _loc_14.y = this.vItem.mcCountDown.y;
                this.vItem.addChild(_loc_14);
            }
            return;
        }// end function

        public function setActionCondition(param1:Function) : void
        {
            this.vActionCondition = param1;
            return;
        }// end function

        public function setPrice(param1:String) : void
        {
            this.vPrice = param1;
            this.vItem.txtGold.htmlText = "<B>" + this.vPrice + "</B>";
            Global.vLang.checkSans(this.vItem.txtGold);
            Toolz.textReduce(this.vItem.txtGold);
            return;
        }// end function

        private function buyGood(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (this.vActionCondition != null)
            {
                if (this.vActionCondition.call() == false)
                {
                    return;
                }
            }
            Global.vSound.onButton();
            if (!this.vCanBuy)
            {
                _loc_2 = Global.getText("txtNotEnoughGold");
                _loc_5 = parseInt(this.vPrice) - Global.vServer.vUser.vHardCurrency;
                _loc_2 = _loc_2.replace(/#/, _loc_5.toString());
                new MsgBox(this, _loc_2);
                return;
            }
            if (this.vType == "Gold")
            {
                if (!Shop.vCanInApp)
                {
                    return;
                }
            }
            var _loc_4:* = "";
            if (this.vCode == "Pack_A")
            {
                _loc_4 = Global.getText("txtPack_A_help");
            }
            if (this.vCode == "Pack_B")
            {
                _loc_4 = Global.getText("txtPack_B_help");
            }
            if (this.vCode == "Pack_S")
            {
                _loc_4 = Global.getText("txtPack_S_help");
            }
            if (this.vCode == "Pack_P")
            {
                _loc_4 = Global.getText("txtPack_P_help");
            }
            if (this.vCode == "Pack_E")
            {
                _loc_4 = Global.getText("txtPack_E_help");
            }
            if (this.vCode == "Pack10")
            {
                _loc_4 = Global.getText("txtPack10_help");
            }
            if (this.vType == "Gold")
            {
                _loc_2 = Global.getText("txtBuyGold");
                _loc_2 = _loc_2.replace(/#/, this.vNb.toString());
                if (!Global.vGoldConfirmation)
                {
                    this.buyGoodConfirm(true, {type:this.vType, value:this.vCode, nb:this.vNb, price:this.vPrice});
                    return;
                }
                _loc_3 = buildGraf(this.vType, this.vCode, this.vNb, false);
                _loc_6 = this.vCode.split("_");
                _loc_7 = _loc_6[1];
                _loc_4 = Global.getText("txtPack" + _loc_7);
                new MsgBox(Global.vRoot.vMenu, _loc_2, this.buyGoodConfirm, MsgBox.TYPE_AskBeforeBuy, {graf:_loc_3, subtext:_loc_4, sparkle:true});
                return;
            }
            else
            {
                _loc_2 = Global.getText("txtBuyConfirmGold");
                _loc_2 = _loc_2.replace(/µ/, this.vPrice);
                _loc_2 = _loc_2.replace(/#/, "\'" + this.vTitle + "\'");
                _loc_3 = Buyable.buildGraf(this.vType, this.vCode, this.vNb, false, true);
            }
            new MsgBox(Global.vRoot.vMenu, _loc_2, this.buyGoodConfirm, MsgBox.TYPE_AskBeforeBuy, {graf:_loc_3, subtext:_loc_4});
            return;
        }// end function

        private function buyGoodConfirm(param1:Boolean, param2:Object = null) : void
        {
            if (!param1)
            {
                return;
            }
            if (this.vType == "Gold")
            {
                this.vStatTimer = getTimer();
                Global.vStats.Stats_Event("InAppPurchase", "IAP_Start", this.vCode);
                Global.vMyInApp.purchaseItem(this.onPurchaseItem, this.vCode);
            }
            else
            {
                this.vShop.buyGood(this.vCode, this.vBuyDirect);
            }
            return;
        }// end function

        private function validateGoldDebug(param1:int) : void
        {
            return;
        }// end function

        private function onPurchaseItem(param1:String, param2:String = "", param3:String = "") : void
        {
            Global.addLogTrace("onPurchaseItem pResult=" + param1 + " pTransactionId=" + param2, "Buyable");
            if (param1 == "ok")
            {
                Global.vServer.validatePurchase(this.onValidateResult, param2, param3);
            }
            var _loc_4:* = Math.round((getTimer() - this.vStatTimer) / 1000);
            Global.vStats.Stats_Event("InAppPurchase", "IAP_Result_" + param1, this.vCode, _loc_4);
            return;
        }// end function

        private function onValidateResult(param1:String, param2:int = 0, param3:Object = null) : void
        {
            var _loc_4:* = null;
            Global.addLogTrace("onValidateResult pResult=" + param1, "Buyable");
            if (param1 == "ok")
            {
                Global.vSound.onGift();
                _loc_4 = Global.getText("txtGoldBought").replace(/#/, param2.toString());
                new MsgBox(Global.vRoot, _loc_4, this.onGoldAdded, MsgBox.TYPE_SimpleText, {gold:param2});
            }
            return;
        }// end function

        private function onGoldAdded(param1:Object) : void
        {
            if (Global.vTopBar != null)
            {
                Global.vTopBar.onGoldAdded(param1.gold);
            }
            TweenMax.delayedCall(2, this.reloadStore);
            return;
        }// end function

        private function reloadStore() : void
        {
            this.vShop.reloadStore();
            return;
        }// end function

        public static function buildGraf(param1:String, param2:String, param3:int, param4:Boolean = true, param5:Boolean = false) : Sprite
        {
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_6:* = new Sprite();
            var _loc_7:* = "";
            if (param5)
            {
                _loc_7 = "_hidden";
            }
            var _loc_8:* = new MovieClip();
            if (param1 == "Gold")
            {
                _loc_8.addChild(new Card("Gold", param2, param3, false));
            }
            else if (param1 == "Card")
            {
                _loc_8.addChild(new Card("Card", param2, param3, false));
            }
            else if (param1 == "Pack")
            {
                _loc_9 = param2.split("_");
                if (_loc_9.length == 1)
                {
                    if (param3 == 1)
                    {
                        _loc_8 = getPackGraf("Pack1" + _loc_7);
                    }
                    else if (param3 == 5)
                    {
                        _loc_8 = getPackGraf("Pack5" + _loc_7);
                    }
                    else if (param3 == 10)
                    {
                        _loc_8 = getPackGraf("Pack10" + _loc_7);
                    }
                    else
                    {
                        _loc_10 = 10;
                        _loc_11 = 4;
                        _loc_12 = 0;
                        while (_loc_12 < param3)
                        {
                            
                            _loc_13 = new Card("Card", "?", 0, false);
                            _loc_13.x = _loc_12 * _loc_10 - _loc_10 * (param3 - 1) / 2;
                            _loc_13.y = 0;
                            var _loc_15:* = 1 - (param3 - 1) * 0.04;
                            _loc_13.scaleY = 1 - (param3 - 1) * 0.04;
                            _loc_13.scaleX = _loc_15;
                            _loc_13.rotation = _loc_12 * _loc_11 - _loc_11 * (param3 - 1) / 2;
                            _loc_8.addChild(_loc_13);
                            _loc_12++;
                        }
                    }
                }
                else
                {
                    _loc_14 = _loc_9[1];
                    if (_loc_14 == "A")
                    {
                        _loc_8 = getPackGraf("Amelioration" + _loc_7);
                    }
                    else if (_loc_14 == "S")
                    {
                        _loc_8 = getPackGraf("Shirt" + _loc_7);
                    }
                    else if (_loc_14 == "P")
                    {
                        _loc_8 = getPackGraf("Player" + _loc_7);
                    }
                    else if (_loc_14 == "E")
                    {
                        _loc_8 = getPackGraf("Energy" + _loc_7);
                    }
                    else
                    {
                        _loc_8 = new MovieClip();
                    }
                }
                ;
            }
            if (param4)
            {
                _loc_6.addChild(new ButtonGrafBitmap(_loc_8));
            }
            else
            {
                _loc_6.addChild(_loc_8);
            }
            return _loc_6;
        }// end function

        public static function getPackGraf(param1:String) : MovieClip
        {
            var _loc_2:* = new DefaultPackButton();
            _loc_2.gotoAndStop(param1);
            var _loc_3:* = 0.9;
            _loc_2.scaleY = 0.9;
            _loc_2.scaleX = _loc_3;
            return _loc_2;
        }// end function

    }
}
