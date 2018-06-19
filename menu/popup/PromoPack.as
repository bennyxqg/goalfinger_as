package menu.popup
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import globz.*;
    import menu.*;
    import menu.tools.*;
    import tools.*;

    public class PromoPack extends MenuXXX
    {
        private var vPackId:String;
        private var vData:Object;
        private var vScreen:PromoPackGraf;
        private var vBuyButton:MovieClip;
        private var vBuyButtonDisabled:MovieClip;
        private var vCountdown:Countdown;
        private var vPriceCallback:Function;
        private var vPrices:Object;
        private var vStatTimer:int;
        private var vIAPStarted:Boolean = false;

        public function PromoPack()
        {
            return;
        }// end function

        override protected function init() : void
        {
            if (!Global.vMyInApp.initDone)
            {
                Global.vMyInApp.initAndroid(this.onAndroidReady);
                return;
            }
            this.loadInfos();
            return;
        }// end function

        private function onDown(event:Event) : void
        {
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function onAndroidReady(param1:Boolean) : void
        {
            if (param1)
            {
                this.loadInfos();
            }
            else
            {
                this.goQuit();
            }
            return;
        }// end function

        private function loadInfos() : void
        {
            this.vPackId = "";
            if (Global.vServer.vUser.vPromoPack != null)
            {
                this.vPackId = Global.vServer.vUser.vPromoPack.id;
            }
            if (this.vPackId == "")
            {
                this.goQuit();
                return;
            }
            Global.vServer.loadPromoPackInfos(this.onInfos, this.vPackId);
            return;
        }// end function

        private function onInfos(param1:Object) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_14:* = null;
            var _loc_17:* = undefined;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = null;
            if (param1 == null)
            {
                this.goQuit();
                return;
            }
            this.vData = param1;
            this.vScreen = new PromoPackGraf();
            var _loc_2:* = new PromoPackGrafTitle();
            _loc_2.txtTitle.htmlText = "<B>" + Global.getText("txtPromoPackTitle" + this.vPackId) + "</B>";
            Global.vLang.checkSans(_loc_2.txtTitle);
            _loc_2.x = this.vScreen.mcTitle.x;
            _loc_2.y = this.vScreen.mcTitle.y;
            this.vScreen.addChild(new ButtonGrafBitmap(_loc_2));
            this.vScreen.txtInvite.htmlText = "<b>" + Global.getText("txtPromoPackInvite" + this.vPackId) + "</b>";
            Global.vLang.checkSans(this.vScreen.txtInvite);
            Toolz.textReduce(this.vScreen.txtInvite);
            this.vScreen.txtInvite.y = this.vScreen.txtInvite.y - this.vScreen.txtInvite.textHeight / 2;
            this.addChild(this.vScreen);
            var _loc_3:* = 1.5;
            var _loc_8:* = "";
            if (this.vData.pack == null)
            {
                this.goQuit();
                return;
            }
            _loc_10 = this.vData.pack.items;
            if (_loc_10 == null)
            {
                this.goQuit();
                return;
            }
            var _loc_11:* = 0;
            while (_loc_11 < _loc_10.length)
            {
                
                _loc_4 = this.vScreen["mc" + (_loc_11 + 1)];
                if (_loc_4 != null)
                {
                    for (_loc_17 in _loc_10[_loc_11])
                    {
                        
                        if (_loc_17 == "nbCards")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "?";
                        }
                        else if (_loc_17 == "nbCardA")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "TypeA";
                        }
                        else if (_loc_17 == "nbCardPA")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "PA";
                        }
                        else if (_loc_17 == "nbCardPB")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "PB";
                        }
                        else if (_loc_17 == "nbCardPC")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "PC";
                        }
                        else if (_loc_17 == "nbCardE100")
                        {
                            _loc_9 = "Cards";
                            _loc_6 = "E100";
                        }
                        else
                        {
                            _loc_9 = _loc_17;
                        }
                        if (_loc_9 == "nbGold")
                        {
                            _loc_5 = new Card("Gold", "Gold_B", _loc_27[_loc_17]);
                            _loc_5.x = _loc_4.mcRep.x;
                            _loc_5.y = _loc_4.mcRep.y;
                            var _loc_28:* = 0.6 * _loc_3;
                            _loc_5.scaleY = 0.6 * _loc_3;
                            _loc_5.scaleX = _loc_28;
                            _loc_4.addChild(_loc_5);
                            _loc_8 = Global.getText("txtPromoPackGold").replace(/#/, _loc_27[_loc_17]);
                            continue;
                        }
                        if (_loc_9 == "Cards")
                        {
                            _loc_18 = 10;
                            _loc_19 = 4;
                            _loc_20 = _loc_27[_loc_17];
                            _loc_5 = new Card("Card", _loc_6);
                            _loc_5.x = _loc_4.mcRep.x - 20;
                            _loc_5.y = _loc_4.mcRep.y;
                            var _loc_28:* = 0.7;
                            _loc_5.scaleY = 0.7;
                            _loc_5.scaleX = _loc_28;
                            _loc_4.addChild(_loc_5);
                            _loc_21 = new CardMultiplier();
                            _loc_21.txtTitle.htmlText = "<B>x" + _loc_20.toString() + "</B>";
                            _loc_7 = new ButtonGrafBitmap(_loc_21);
                            _loc_7.x = _loc_4.mcRep.x + 50;
                            _loc_7.y = _loc_4.mcRep.y;
                            _loc_4.addChild(_loc_7);
                            if (_loc_6 == "?")
                            {
                                _loc_8 = Global.getText("txtPromoPackCardsAmelioration");
                            }
                            else if (_loc_6 == "TypeA")
                            {
                                _loc_8 = Global.getText("txtPromoPackCardsAmelioration");
                            }
                            else if (_loc_6 == "E100")
                            {
                                _loc_8 = Global.getText("txtCardEX").replace(/#/, "100");
                                _loc_8 = Global.getText("txtPromoPackCardsSpecific").replace(/µ/, _loc_8);
                            }
                            else
                            {
                                _loc_8 = Global.getText("txtCard" + _loc_6);
                                _loc_8 = Global.getText("txtPromoPackCardsSpecific").replace(/µ/, _loc_8);
                            }
                            _loc_8 = _loc_8.replace(/#/, _loc_27[_loc_17]);
                            continue;
                        }
                        if (_loc_9 == "character")
                        {
                            _loc_22 = _loc_27[_loc_17];
                            _loc_23 = new PersoGrafMain();
                            _loc_23.init();
                            _loc_23.setHead(_loc_22, Global.vSWFImages, Global.vSWFLoader);
                            _loc_23.x = _loc_4.mcRep.x;
                            _loc_23.y = _loc_4.mcRep.y + 8;
                            var _loc_28:* = 1.7 * _loc_3;
                            _loc_23.scaleY = 1.7 * _loc_3;
                            _loc_23.scaleX = _loc_28;
                            _loc_4.addChild(new ButtonGrafBitmap(_loc_23));
                            _loc_8 = Global.getText("txtPromoPackChar1");
                            continue;
                        }
                        if (_loc_9 == "shirt")
                        {
                            _loc_24 = _loc_27[_loc_17];
                            _loc_25 = new Shirt(_loc_24);
                            _loc_25.x = _loc_4.mcRep.x;
                            _loc_25.y = _loc_4.mcRep.y;
                            var _loc_28:* = 0.65 * _loc_3;
                            _loc_25.scaleY = 0.65 * _loc_3;
                            _loc_25.scaleX = _loc_28;
                            _loc_25.y = 16;
                            _loc_4.addChild(_loc_25);
                            _loc_8 = Global.getText("txtPromoPackShirt");
                        }
                    }
                    _loc_4.txtContent.htmlText = "<b>" + _loc_8 + "</b>";
                    Global.vLang.checkSans(_loc_4.txtContent);
                    _loc_4.txtContent.y = _loc_4.txtContent.y - _loc_4.txtContent.textHeight / 2;
                }
                _loc_11++;
            }
            if (Capabilities.isDebugger)
            {
                this.vScreen.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            }
            else
            {
                this.vScreen.addEventListener(TouchEvent.TOUCH_BEGIN, this.onDown);
            }
            var _loc_12:* = new SparkleAnimation(3);
            var _loc_26:* = 1.7;
            _loc_12.scaleY = 1.7;
            _loc_12.scaleX = _loc_26;
            this.vScreen.addChild(_loc_12);
            var _loc_13:* = new ButtonTextBitmap(Menu_TextButtonFinish, Global.getText("txtPromoPackButton"), 1.5);
            _loc_14 = new MovieClip();
            _loc_14.addChild(_loc_13);
            _loc_14.x = this.vScreen.mcButton.x;
            _loc_14.y = this.vScreen.mcButton.y;
            this.vScreen.addChild(_loc_14);
            this.vBuyButton = _loc_14;
            if (Capabilities.isDebugger)
            {
                _loc_14.addEventListener(MouseEvent.MOUSE_DOWN, this.goBuy);
            }
            else
            {
                _loc_14.addEventListener(TouchEvent.TOUCH_BEGIN, this.goBuy);
            }
            var _loc_15:* = Global.vServer.getTimeTo(Global.vServer.vUser.vPromoPack.endTime / 1000);
            var _loc_16:* = new Countdown(null, _loc_15, true, null, null, null, true, "#000000");
            _loc_16.x = this.vScreen.mcTimer.x;
            _loc_16.y = this.vScreen.mcTimer.y;
            var _loc_26:* = 1.2;
            _loc_16.scaleY = 1.2;
            _loc_16.scaleX = _loc_26;
            this.vScreen.addChild(_loc_16);
            this.vCountdown = _loc_16;
            this.x = Global.vSize.x / 2;
            this.y = Global.vSize.y / 2;
            Global.vSound.onSlide();
            this.loadGoldPrices(this.onPricesLoaded);
            return;
        }// end function

        private function goQuit(event:Event = null) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function onPricesLoaded() : void
        {
            var _loc_1:* = null;
            this.vScreen.gotoAndStop(2);
            var _loc_2:* = new PromoPackPrice();
            _loc_1 = "";
            if (this.vPrices[this.vData.pack.fakePrice] != null)
            {
                _loc_1 = this.vPrices[this.vData.pack.fakePrice];
            }
            _loc_2.txtPriceFake.htmlText = "<b>" + _loc_1 + "<b>";
            Global.vLang.checkSans(_loc_2.txtPriceFake);
            _loc_1 = "";
            var _loc_3:* = this.getFullPackId();
            if (this.vPrices[_loc_3] != null)
            {
                _loc_1 = this.vPrices[_loc_3];
            }
            _loc_2.txtPriceReal.htmlText = "<b>" + _loc_1 + "<b>";
            Global.vLang.checkSans(_loc_2.txtPriceReal);
            var _loc_4:* = new ButtonGrafBitmap(_loc_2);
            _loc_4.x = this.vScreen.mcPrice.x;
            _loc_4.y = this.vScreen.mcPrice.y;
            this.vScreen.addChild(_loc_4);
            return;
        }// end function

        private function getFullPackId() : String
        {
            return "PromoPack_" + this.vPackId;
        }// end function

        private function loadGoldPrices(param1:Function) : void
        {
            this.vPriceCallback = param1;
            if (Global.vDev)
            {
            }
            if (this.vPrices != null)
            {
                this.vPriceCallback.call();
                return;
            }
            if (Global.vMyInApp == null)
            {
                Global.vMyInApp = new MyInApp();
            }
            if (!Global.vMyInApp.isAvailable)
            {
                return;
            }
            Global.vMyInApp.getPrices(this.onPrices);
            return;
        }// end function

        private function onPrices(param1:Array) : void
        {
            this.vPrices = new Object();
            var _loc_2:* = 0;
            while (_loc_2 < param1.length)
            {
                
                this.vPrices[param1[_loc_2].code] = param1[_loc_2].price;
                _loc_2++;
            }
            if (!this.stage)
            {
                return;
            }
            this.vPriceCallback.call();
            return;
        }// end function

        private function goBuy(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            this.vBuyButton.visible = false;
            this.vCountdown.visible = false;
            Global.vSound.onButton();
            if (this.vBuyButtonDisabled == null)
            {
                _loc_2 = new ButtonTextBitmap(Menu_TextButtonFinishGrey, Global.getText("txtPromoPackButton"), 1.5);
                _loc_3 = new MovieClip();
                _loc_3.addChild(_loc_2);
                _loc_3.x = this.vScreen.mcButton.x;
                _loc_3.y = this.vScreen.mcButton.y;
                this.vScreen.addChild(_loc_3);
                this.vBuyButtonDisabled = _loc_3;
            }
            else
            {
                this.vBuyButtonDisabled.visible = true;
            }
            if (Global.vDev)
            {
            }
            if (this.vIAPStarted)
            {
                return;
            }
            event.stopPropagation();
            this.vIAPStarted = true;
            this.vStatTimer = getTimer();
            if (Global.vMyInApp == null)
            {
                return;
            }
            Global.vStats.Stats_Event("InAppPurchase", "IAP_Start", this.getFullPackId());
            Global.vMyInApp.purchaseItem(this.onPurchaseItem, this.getFullPackId());
            return;
        }// end function

        private function onPurchaseItem(param1:String, param2:String = "", param3:String = "") : void
        {
            Global.addLogTrace("onPurchaseItem pResult=" + param1 + " pTransactionId=" + param2);
            this.vIAPStarted = false;
            if (param1 == "ok")
            {
                Global.vServer.validatePurchase(this.onValidateResult, param2, param3);
            }
            else if (param1 === "fail")
            {
                this.vBuyButton.visible = true;
                this.vBuyButtonDisabled.visible = false;
            }
            var _loc_4:* = Math.round((getTimer() - this.vStatTimer) / 1000);
            Global.vStats.Stats_Event("InAppPurchase", "IAP_Result_" + param1, this.vPackId, _loc_4);
            return;
        }// end function

        private function onValidateResult(param1:String, param2:int = 0, param3:Object = null) : void
        {
            Global.addLogTrace("onValidateResult pResult=" + param1 + " pGoldAdded=" + param2 + " pData=" + JSON.stringify(param3));
            if (param1 == "ok")
            {
                if (param3 != null)
                {
                    if (param3.pack != null)
                    {
                        this.onPackWon(param3.pack);
                        Global.vRoot.goMainMenu();
                    }
                }
            }
            this.goQuit();
            return;
        }// end function

        private function onPackWon(param1:Array) : void
        {
            Global.vServer.vUser.vPromoPack = null;
            Global.addLogTrace(JSON.stringify(param1), "PromoPack");
            if (Global.vTopBar != null)
            {
                Global.vTopBar.vPackWon = param1;
            }
            return;
        }// end function

    }
}
