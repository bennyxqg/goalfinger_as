package menu.screens
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.tools.*;
    import tools.*;

    public class ShirtManager extends MenuXXX
    {
        private var vShirts:Array;
        private var vShirtBought:String = "";
        private var vPanel:SlidePanel;
        private var vSlotHeight:int = 208;
        private var vCurShirt:Shirt;
        private var vShirtSelected:MovieClip;
        private var vShirtPreviousCode:String;

        public function ShirtManager()
        {
            vTag = "ShirtManager";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            initMenu();
            this.vShirts = new Array();
            this.showMenu();
            this.loadShirts();
            Global.vStats.Stats_PageView("ShirtManager");
            return;
        }// end function

        private function loadShirts() : void
        {
            Global.vServer.getShirtList(this.onList);
            return;
        }// end function

        private function onList(param1:Object) : void
        {
            if (param1 == null || param1.shirts == null)
            {
                Global.addLogTrace("getShirtList NULL");
                return;
            }
            this.vShirts = param1.shirts;
            this.vShirts.sort(this.sortShirts);
            this.showMenu();
            return;
        }// end function

        private function sortShirts(param1:Object, param2:Object) : int
        {
            if (param1.Categ < param2.Categ)
            {
                return -1;
            }
            if (param1.Categ > param2.Categ)
            {
                return 1;
            }
            if (param1.XPLevel < param2.XPLevel)
            {
                return -1;
            }
            if (param1.XPLevel > param2.XPLevel)
            {
                return 1;
            }
            if (param1.Price < param2.Price)
            {
                return -1;
            }
            if (param1.Price > param2.Price)
            {
                return 1;
            }
            if (param1.Code < param2.Code)
            {
                return -1;
            }
            if (param1.Code > param2.Code)
            {
                return 1;
            }
            return 0;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = false;
            var _loc_20:* = false;
            var _loc_24:* = null;
            var _loc_25:* = null;
            Global.vTopBar.vTransitionRunning = false;
            cleanMenu();
            var _loc_2:* = 260;
            _loc_3 = 50;
            var _loc_6:* = new Sprite();
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            var _loc_7:* = new Point(0, 0);
            var _loc_8:* = -1;
            var _loc_9:* = "";
            var _loc_14:* = new Point(0, 0);
            this.showActiveShirt();
            var _loc_21:* = Global.vServer.vUser.getMyShirts();
            var _loc_22:* = 0;
            _loc_4 = 0;
            while (_loc_4 < _loc_21.length)
            {
                
                if (_loc_21[_loc_4] != Global.vServer.vUser.vCurShirt)
                {
                    _loc_22++;
                }
                _loc_4++;
            }
            _loc_11 = new ListTitle();
            _loc_11.txtListTitle.htmlText = "<B>" + Global.getText("txtShirtsMyStock") + "</B>";
            Global.vLang.checkSans(_loc_11.txtListTitle);
            _loc_11.y = _loc_2 + _loc_11.height / 2;
            _loc_6.addChild(new ButtonGrafBitmap(_loc_11));
            _loc_2 = _loc_2 + _loc_11.height;
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            if (_loc_22 == 0)
            {
                _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                _loc_24 = new RecruitNoPlayerYet();
                _loc_24.txtNoPlayerYet.htmlText = "<b>" + Global.getText("txtNoShirtYet") + "</b>";
                Global.vLang.checkSans(_loc_24.txtNoPlayerYet);
                Toolz.textReduce(_loc_24.txtNoPlayerYet);
                _loc_24.txtNoPlayerYet.y = _loc_24.txtNoPlayerYet.y - _loc_24.txtNoPlayerYet.textHeight / 2;
                _loc_24.mcBG.gotoAndStop(4);
                _loc_2 = _loc_2 - 70;
                _loc_24.y = _loc_2;
                _loc_2 = _loc_2 - 40;
                _loc_6.addChild(new ButtonGrafBitmap(_loc_24));
                _loc_8 = -1;
                _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_21.length)
                {
                    
                    if (_loc_21[_loc_4] != Global.vServer.vUser.vCurShirt)
                    {
                        _loc_13 = this.newMyShirtSlot(_loc_21[_loc_4]);
                        _loc_7.x = _loc_8 * 200;
                        _loc_7.y = _loc_2 + this.vSlotHeight / 2;
                        _loc_8++;
                        if (_loc_8 == 2)
                        {
                            _loc_8 = -1;
                            _loc_2 = _loc_2 + this.vSlotHeight;
                            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                        }
                        addButton(_loc_6, _loc_13, _loc_7, this.selectShirt, 1, _loc_21[_loc_4], false);
                    }
                    _loc_4++;
                }
            }
            if (this.vShirts.length == 0)
            {
                _loc_4 = 0;
                while (_loc_4 < 20)
                {
                    
                    _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                    _loc_4++;
                }
            }
            _loc_4 = 0;
            while (_loc_4 < this.vShirts.length)
            {
                
                _loc_10 = this.vShirts[_loc_4];
                if (_loc_10.Categ == "A" || _loc_10.Categ == "B" || _loc_10.Categ == "C")
                {
                    if (!Global.vServer.vUser.hasShirt(_loc_10.Code))
                    {
                        if (_loc_10.Categ != _loc_9)
                        {
                            if (_loc_8 >= 0)
                            {
                                _loc_8 = -1;
                                _loc_2 = _loc_2 + this.vSlotHeight;
                                _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                            }
                            _loc_9 = _loc_10.Categ;
                            _loc_11 = new ListTitle();
                            _loc_11.txtListTitle.htmlText = "<B>" + Global.getText("txtShirtCateg" + _loc_9) + "</B>";
                            Global.vLang.checkSans(_loc_11.txtListTitle);
                            _loc_11.y = _loc_2 + _loc_11.height / 2;
                            _loc_6.addChild(new ButtonGrafBitmap(_loc_11));
                            if (_loc_10.Categ == "A" || _loc_10.Categ == "B" || _loc_10.Categ == "C")
                            {
                                _loc_18 = new Card("Card", "S" + _loc_10.Categ);
                                _loc_6.addChild(_loc_18);
                                addButton(_loc_6, _loc_18, new Point(_loc_11.x - 200, _loc_11.y), this.onClickCardTitle, 0.7, {type:"S" + _loc_10.Categ}, false);
                            }
                            _loc_2 = _loc_2 + _loc_11.height;
                            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                        }
                        _loc_12 = new ShirtSlot();
                        _loc_12.txtId.text = "";
                        _loc_14.x = _loc_8 * 200;
                        _loc_14.y = _loc_2 + _loc_12.height / 2;
                        _loc_8++;
                        if (_loc_8 == 2)
                        {
                            _loc_8 = -1;
                            _loc_2 = _loc_2 + _loc_12.height;
                            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                        }
                        _loc_16 = new Shirt(_loc_10.Code, false);
                        _loc_16.x = _loc_12.mcShirt.x;
                        _loc_16.y = _loc_12.mcShirt.y;
                        _loc_12.addChild(_loc_16);
                        _loc_19 = false;
                        if (_loc_10.XPLevel > Global.vServer.vUser.vLevel)
                        {
                            _loc_20 = false;
                            _loc_12.gotoAndStop("Locked");
                            _loc_17 = Global.getText("txtLevelRequired").replace(/#/, _loc_10.XPLevel);
                            _loc_12.txtInfo.htmlText = "<B>" + _loc_17 + "</B>";
                            Global.vLang.checkSans(_loc_12.txtInfo);
                            Toolz.textReduce(_loc_12.txtInfo);
                        }
                        else
                        {
                            _loc_20 = true;
                            if (_loc_10.Currency != null && _loc_10.Currency == "Currency1")
                            {
                                _loc_12.gotoAndStop("Gold");
                                _loc_12.txtGold.htmlText = "<B>" + _loc_10.Price + "</B>";
                                Global.vLang.checkSans(_loc_12.txtGold);
                                if (_loc_10.Price <= Global.vServer.vUser.vHardCurrency)
                                {
                                    _loc_19 = true;
                                }
                                else
                                {
                                    _loc_12.txtGold.textColor = 16711680;
                                }
                            }
                            else if (_loc_10.Card != null)
                            {
                                _loc_19 = true;
                                _loc_12.gotoAndStop("Card");
                                _loc_12.addChild(new CostBar(Global.vServer.vUser.getCards(_loc_10.Card), _loc_10.Price, _loc_12.mcCost.x, _loc_12.mcCost.y));
                            }
                        }
                        _loc_15 = new ButtonGrafBitmap(_loc_12);
                        _loc_25 = new MovieClip();
                        _loc_25.vCanBuy = _loc_19;
                        _loc_25.vShirt = _loc_10;
                        _loc_25.vIsAvailable = _loc_20;
                        if (Capabilities.isDebugger)
                        {
                            _loc_25.addEventListener(MouseEvent.CLICK, this.buyShirt);
                        }
                        else
                        {
                            _loc_25.addEventListener(TouchEvent.TOUCH_TAP, this.buyShirt);
                        }
                        _loc_25.addChild(_loc_15);
                        _loc_25.x = _loc_14.x;
                        _loc_25.y = _loc_14.y;
                        _loc_6.addChild(_loc_25);
                    }
                }
                _loc_4++;
            }
            if (_loc_8 >= 0)
            {
                _loc_2 = _loc_2 + this.vSlotHeight;
            }
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            var _loc_23:* = new Point(640, 520);
            _loc_23.y = _loc_23.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            this.vPanel = new SlidePanel(_loc_6, _loc_23);
            this.vPanel.x = 0;
            this.vPanel.y = 90;
            layerMenu.addChild(this.vPanel);
            _loc_2 = _loc_2 + _loc_3;
            this.vPanel.forceX(Global.vSize.x / 2);
            if (this.vShirtBought != "")
            {
                new MsgBox(this, Global.getText("txtNewShirt"), null, MsgBox.TYPE_NewShirt, {code:this.vShirtBought});
                this.vShirtBought = "";
            }
            return;
        }// end function

        private function onClickCardTitle(event:Event) : void
        {
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            var _loc_2:* = event.currentTarget.vArgs.type;
            CardManager.showCardHelp(_loc_2);
            return;
        }// end function

        private function showActiveShirt() : void
        {
            if (this.vCurShirt != null)
            {
                if (layerMenu.contains(this.vCurShirt))
                {
                    layerMenu.removeChild(this.vCurShirt);
                }
                this.vCurShirt = null;
            }
            var _loc_1:* = 1.8;
            Global.vResolution = Global.vResolution * _loc_1;
            this.vCurShirt = new Shirt(Global.vServer.vUser.vCurShirt, true);
            Global.vResolution = Global.vResolution / _loc_1;
            var _loc_2:* = _loc_1;
            this.vCurShirt.scaleY = _loc_1;
            this.vCurShirt.scaleX = _loc_2;
            this.vCurShirt.y = -175;
            layerMenu.addChild(this.vCurShirt);
            Global.adjustPos(this.vCurShirt, 0, -1);
            return;
        }// end function

        private function newMyShirtSlot(param1:String) : MovieClip
        {
            var _loc_2:* = new ShirtSlot();
            _loc_2.txtId.text = "";
            var _loc_3:* = new Shirt(param1, false);
            _loc_3.x = _loc_2.mcShirt.x;
            _loc_3.y = _loc_2.mcShirt.y;
            _loc_2.addChild(_loc_3);
            var _loc_4:* = new Menu_TextButtonMini();
            _loc_4.txtLabel.htmlText = Global.getText("txtShirtsActivate");
            Global.vLang.checkSans(_loc_4.txtLabel);
            Toolz.textReduce(_loc_4.txtLabel);
            _loc_4.x = _loc_2.mcButton.x;
            _loc_4.y = _loc_2.mcButton.y;
            var _loc_6:* = 0.7;
            _loc_4.scaleY = 0.7;
            _loc_4.scaleX = _loc_6;
            _loc_2.addChild(_loc_4);
            var _loc_5:* = new MovieClip();
            _loc_5.addChild(new ButtonGrafBitmap(_loc_2));
            return _loc_5;
        }// end function

        private function selectShirt(event:Event) : void
        {
            if (this.vShirtSelected != null)
            {
                return;
            }
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            Global.vSound.onButton();
            Global.vSound.onSlide();
            var _loc_2:* = event.currentTarget.vArgs;
            this.vShirtSelected = MovieClip(event.currentTarget);
            this.vShirtPreviousCode = Global.vServer.vUser.vCurShirt;
            Global.vServer.selectShirt(this.onSelectShirt, _loc_2);
            return;
        }// end function

        private function onSelectShirt() : void
        {
            Global.vTopBar.refreshTeamIcon();
            var _loc_1:* = this.newMyShirtSlot(this.vShirtPreviousCode);
            var _loc_2:* = new Point(this.vShirtSelected.x, this.vShirtSelected.y);
            addButton(this.vShirtSelected.parent, _loc_1, _loc_2, this.selectShirt, 1, this.vShirtPreviousCode, false);
            if (this.vShirtSelected.parent != null)
            {
                this.vShirtSelected.parent.removeChild(this.vShirtSelected);
            }
            this.showActiveShirt();
            Global.vSound.onGift();
            _loc_2.x = this.vCurShirt.x;
            _loc_2.y = this.vCurShirt.y - 70;
            Global.startParticles(layerMenu, _loc_2, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            this.vShirtSelected = null;
            return;
        }// end function

        private function buyShirt(event:Event) : void
        {
            var _loc_2:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            if (event.currentTarget.vIsAvailable == false)
            {
                return;
            }
            Global.vSound.onButton();
            var _loc_3:* = event.currentTarget.vShirt;
            if (event.currentTarget.vCanBuy == false)
            {
                _loc_5 = _loc_3.Price - Global.vServer.vUser.vHardCurrency;
                _loc_2 = Global.getText("txtNotEnoughGold").replace(/#/, _loc_5.toString());
                _loc_2 = _loc_2 + "<br><br>" + Global.getText("txtAskGoShop");
                _loc_6 = new LowBar_Icons();
                _loc_6.gotoAndStop(1);
                var _loc_8:* = 2;
                _loc_6.scaleY = 2;
                _loc_6.scaleX = _loc_8;
                new MsgBox(Global.vRoot.vMenu, _loc_2, this.goShop, MsgBox.TYPE_YesNoWithGraf, {graf:_loc_6});
                return;
            }
            var _loc_4:* = MsgBox.getPerso(Global.vServer.vUser.getCharAtPosition(1).vCharId, _loc_3.Code);
            if (_loc_3.Currency != null)
            {
                _loc_2 = Global.getText("txtBuyConfirmGold");
                _loc_2 = _loc_2.replace(/µ/, _loc_3.Price);
                _loc_2 = _loc_2.replace(/#/, Global.getText("txtThisShirt"));
                this.vPanel.vPause = true;
                new MsgBox(this, _loc_2, this.buyShirtConfirm, MsgBox.TYPE_AskBeforeBuy, {code:_loc_3.Code, graf:_loc_4, subtext:Global.getText("txtLowBarTab5")});
                return;
            }
            if (_loc_3.Card != null)
            {
                _loc_7 = Global.vServer.vUser.getCards(_loc_3.Card) - _loc_3.Price;
                if (_loc_7 < 0)
                {
                    this.vPanel.vPause = true;
                    showNotEnoughCards(-_loc_7, this.restartPanel);
                    return;
                }
                _loc_2 = Global.getText("txtBuyConfirmCard");
                _loc_2 = _loc_2.replace(/#/, _loc_3.Price);
                _loc_2 = _loc_2.replace(/µ/, Global.getText("txtCard" + _loc_3.Card));
                this.vPanel.vPause = true;
                new MsgBox(this, _loc_2, this.buyShirtConfirm, MsgBox.TYPE_AskBeforeBuy, {code:_loc_3.Code, graf:_loc_4, subtext:Global.getText("txtLowBarTab5")});
                return;
            }
            else
            {
                Global.addLogTrace("buyShirt error : " + JSON.stringify(_loc_3));
                return;
            }
        }// end function

        private function goShop(param1:Boolean, param2:Object = null) : void
        {
            if (param1)
            {
                Shop.vDirectGold = true;
                Global.vRoot.launchMenu(Shop);
            }
            return;
        }// end function

        private function restartPanel() : void
        {
            this.vPanel.vPause = false;
            return;
        }// end function

        public function buyShirtConfirm(param1:Boolean, param2:Object) : void
        {
            this.vPanel.vPause = false;
            if (param1)
            {
                cleanMenu();
                this.vShirtBought = param2.code;
                Global.vServer.buyShirt(this.onBuyShirt, param2.code);
            }
            return;
        }// end function

        private function onBuyShirt() : void
        {
            Global.vTopBar.refresh();
            this.showMenu();
            Global.vTopBar.refreshTeamIcon();
            return;
        }// end function

    }
}
