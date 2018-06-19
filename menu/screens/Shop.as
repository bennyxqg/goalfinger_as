package menu.screens
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.geom.*;
    import globz.*;
    import menu.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class Shop extends MenuXXX
    {
        private var vGoods:Array;
        private var vBuyableGold:Vector.<Buyable>;
        private var vPanel:SlidePanel;
        private var vBuyableDirectBuy:Buyable;
        private var vStoreId:String = "PlayersA";
        private var vDirectBuy:Boolean = false;
        public static var vDirectGold:Boolean = false;
        public static var vCardsBought:Array;
        public static var vBuyables:Vector.<Buyable>;
        public static var vCanInApp:Boolean = true;

        public function Shop()
        {
            vTag = "Shop";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            Global.vTopBar.setTab(1);
            initMenu();
            this.loadStore();
            Global.vStats.Stats_PageView("Shop");
            return;
        }// end function

        private function loadStore() : void
        {
            showLoading();
            if (!Global.vMyInApp.initDone)
            {
                Global.vMyInApp.initAndroid(this.onInitAndroid);
                Global.vTopBar.vTransitionRunning = false;
                return;
            }
            this.loadItemsToBuy();
            return;
        }// end function

        private function loadItemsToBuy() : void
        {
            Global.vServer.getShopVirtualGoods(this.onShopVirtualGoods);
            return;
        }// end function

        private function onShopVirtualGoods(param1:Boolean, param2:Array) : void
        {
            Global.vTopBar.vTransitionRunning = false;
            if (!param1)
            {
                Global.vRoot.goMainMenu();
                return;
            }
            this.vGoods = param2;
            this.showMenu();
            return;
        }// end function

        private function showNoStore() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vBuyableGold.length)
            {
                
                this.vBuyableGold[_loc_1].visible = false;
                _loc_1++;
            }
            new MsgBox(this, Global.getText("txtStoreUnavailable"));
            return;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_15:* = null;
            Global.vRoot.vKillOnDeactivate = false;
            cleanMenu();
            var _loc_7:* = 200;
            var _loc_8:* = -200;
            var _loc_9:* = 0;
            var _loc_10:* = -1;
            var _loc_11:* = false;
            var _loc_12:* = 0;
            var _loc_13:* = new Sprite();
            this.vBuyableGold = new Vector.<Buyable>;
            _loc_9 = _loc_9 + addMarge(_loc_13, 0, _loc_9);
            _loc_9 = _loc_9 - 30;
            _loc_9 = this.addTitle(_loc_13, "txtShopCards", _loc_9);
            vBuyables = new Vector.<Buyable>;
            if (this.vGoods == null)
            {
                return;
            }
            _loc_5 = 0;
            while (_loc_5 < this.vGoods.length)
            {
                
                _loc_6 = this.vGoods[_loc_5];
                if (!_loc_11)
                {
                    if (_loc_6.type == "Gold")
                    {
                        if (_loc_10 > -1)
                        {
                            _loc_10 = -1;
                            _loc_9 = _loc_9 + _loc_2.height;
                        }
                        _loc_12 = _loc_9;
                        _loc_9 = this.addTitle(_loc_13, "txtShopGold", _loc_9);
                        _loc_11 = true;
                    }
                }
                _loc_15 = _loc_6.price;
                if (_loc_6.type == "Gold")
                {
                    _loc_15 = "...";
                }
                _loc_2 = new Buyable(this, _loc_6.type, _loc_6.code, _loc_15, _loc_6.nb, _loc_6.time);
                if (_loc_6.time > 0)
                {
                    this.vBuyableDirectBuy = _loc_2;
                }
                _loc_2.setActionCondition(this.checkSlideDone);
                if (_loc_6.type == "Gold")
                {
                    this.vBuyableGold.push(_loc_2);
                }
                _loc_2.x = _loc_10 * 200;
                _loc_2.y = _loc_9 + _loc_2.height / 2;
                _loc_10++;
                if (_loc_10 == 2)
                {
                    _loc_10 = -1;
                    _loc_9 = _loc_9 + (_loc_2.height + 20);
                }
                _loc_13.addChild(_loc_2);
                vBuyables.push(_loc_2);
                _loc_5++;
            }
            if (_loc_10 > -1)
            {
                _loc_9 = _loc_9 + (_loc_2.height + 50);
            }
            _loc_9 = _loc_9 + addMarge(_loc_13, 0, _loc_9);
            var _loc_14:* = new Point(640, 740);
            _loc_14.y = _loc_14.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            this.vPanel = new SlidePanel(_loc_13, _loc_14);
            this.vPanel.x = 0;
            this.vPanel.y = -20;
            layerMenu.addChild(this.vPanel);
            this.vPanel.forceX(Global.vSize.x / 2);
            this.loadGoldPrices();
            if (vDirectGold)
            {
                vDirectGold = false;
                this.vPanel.vContent.y = -_loc_12;
            }
            Global.vNewShopCard = false;
            if (Global.vTopBar != null)
            {
                Global.vTopBar.refreshNewShopCard();
            }
            if (vCardsBought != null)
            {
                TweenMax.delayedCall(0.5, this.showCardsBought);
            }
            return;
        }// end function

        private function showCardsBought() : void
        {
            if (vCardsBought != null)
            {
                new MsgBox(this, "", this.reloadStore, MsgBox.TYPE_NewCard, {cards:vCardsBought, direct:true});
                vCardsBought = null;
            }
            return;
        }// end function

        private function checkSlideDone() : Boolean
        {
            if (this.vPanel == null)
            {
                return true;
            }
            if (this.vPanel.isSlideDone)
            {
                return false;
            }
            return true;
        }// end function

        private function addTitle(param1:Sprite, param2:String, param3:Number) : Number
        {
            var _loc_4:* = new ListTitle();
            _loc_4.txtListTitle.htmlText = "<B>" + Global.getText(param2) + "</B>";
            Global.vLang.checkSans(_loc_4.txtListTitle);
            _loc_4.y = param3 + _loc_4.height / 2;
            param1.addChild(new ButtonGrafBitmap(_loc_4));
            param3 = param3 + _loc_4.height;
            return param3;
        }// end function

        private function goBack() : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function loadGoldPrices() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = new Array();
            if (this.vBuyableGold == null)
            {
                return;
            }
            var _loc_3:* = 0;
            while (_loc_3 < this.vBuyableGold.length)
            {
                
                _loc_1 = this.vBuyableGold[_loc_3];
                _loc_2.push(_loc_1.vCode);
                _loc_3++;
            }
            if (_loc_2.length == 0)
            {
                this.showMenu();
            }
            else
            {
                if (Global.vMyInApp == null)
                {
                    Global.vMyInApp = new MyInApp();
                }
                if (!Global.vMyInApp.isAvailable)
                {
                    TweenMax.delayedCall(0.5, this.showNoStore);
                    return;
                }
                Global.vMyInApp.getPrices(this.onPrices);
            }
            return;
        }// end function

        private function onPrices(param1:Array) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 0;
            while (_loc_2 < param1.length)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.vBuyableGold.length)
                {
                    
                    if (this.vBuyableGold[_loc_3].vCode == param1[_loc_2].code)
                    {
                        this.vBuyableGold[_loc_3].setPrice(param1[_loc_2].price);
                    }
                    _loc_3++;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function buyGold(param1:int) : void
        {
            return;
        }// end function

        public function buyGood(param1:String, param2:Boolean = false) : void
        {
            this.vDirectBuy = param2;
            Global.vServer.buyVirtualGood(this.afterBuyVG, param1);
            return;
        }// end function

        private function afterBuyVG(param1:Boolean, param2:Array = null) : void
        {
            var _loc_3:* = null;
            Toolz.traceObject(param2, "afterBuyVG");
            Global.vTopBar.refresh();
            if (!param1)
            {
                new MsgBox(this, "Buy Error", this.reloadStore);
                return;
            }
            this.showMenu();
            if (param2 != null)
            {
                if (this.vDirectBuy)
                {
                    vCardsBought = param2;
                    this.showCardsBought();
                }
                else
                {
                    new MsgBox(this, "", null, MsgBox.TYPE_NewCard, {cards:param2, direct:this.vDirectBuy});
                }
            }
            return;
        }// end function

        private function afterDirectBuy(param1) : void
        {
            if (this.vBuyableDirectBuy != null)
            {
                this.vBuyableDirectBuy.visible = false;
            }
            TweenMax.delayedCall(1, this.reloadStore);
            return;
        }// end function

        public function reloadStore(param1 = null) : void
        {
            Global.vTopBar.refresh();
            Global.vRoot.launchMenu(Shop);
            return;
        }// end function

        private function onInitAndroid(param1:Boolean) : void
        {
            Global.addLogTrace("onInitAndroid pSuccess=" + param1);
            this.loadItemsToBuy();
            return;
        }// end function

    }
}
