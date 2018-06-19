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

    public class CardManager extends MenuXXX
    {
        private var vCards:Array;
        private var vTypeOrder:Array;
        private var vPanel:SlidePanel;
        public static var vPanelPos:Object;

        public function CardManager()
        {
            this.vTypeOrder = ["B", "E", "A", "P", "S"];
            vTag = "CardManager";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            vImages["button_trade"] = new mcToBitmapAS3(new Button_Trade(), 0, Global.vResolution, true, null, 0, param1);
            return;
        }// end function

        override protected function init() : void
        {
            initMenu();
            this.initCards();
            Global.vStats.Stats_PageView("CardManager");
            return;
        }// end function

        private function initCards() : void
        {
            var _loc_3:* = undefined;
            this.vCards = new Array();
            var _loc_1:* = Global.vServer.vCardsAvailability.cards;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this.vCards.push({type:_loc_1[_loc_2].substr(0, 1), id:_loc_1[_loc_2], nb:0});
                _loc_2++;
            }
            this.vCards.sort(this.sortCards);
            for (_loc_3 in Global.vServer.vUser.vCards)
            {
                
                this.addCards(_loc_3, _loc_5[_loc_3]);
            }
            this.showMenu();
            return;
        }// end function

        private function addCards(param1:String, param2:int) : void
        {
            var _loc_3:* = 0;
            while (_loc_3 < this.vCards.length)
            {
                
                if (this.vCards[_loc_3].id == param1)
                {
                    this.vCards[_loc_3].nb = this.vCards[_loc_3].nb + param2;
                }
                _loc_3++;
            }
            return;
        }// end function

        private function getRank(param1:String) : int
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vTypeOrder.length)
            {
                
                if (this.vTypeOrder[_loc_2] == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        private function sortCards(param1:Object, param2:Object) : int
        {
            if (param1.type == param2.type)
            {
                if (param1.type == "E")
                {
                    if (parseInt(param1.id.substr(1)) < parseInt(param2.id.substr(1)))
                    {
                        return -1;
                    }
                    return 1;
                }
                if (param1.id < param2.id)
                {
                    return -1;
                }
                if (param1.id > param2.id)
                {
                    return 1;
                }
                return 1;
            }
            var _loc_3:* = this.getRank(param1.type);
            var _loc_4:* = this.getRank(param2.type);
            if (_loc_3 < _loc_4)
            {
                return -1;
            }
            if (_loc_3 > _loc_4)
            {
                return 1;
            }
            return 0;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = false;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_19:* = null;
            var _loc_20:* = 0;
            var _loc_21:* = null;
            Global.vTopBar.vTransitionRunning = false;
            cleanMenu();
            var _loc_2:* = 0;
            var _loc_3:* = 50;
            var _loc_6:* = new Sprite();
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            var _loc_7:* = -1;
            var _loc_8:* = "";
            _loc_4 = 0;
            while (_loc_4 < this.vCards.length)
            {
                
                _loc_5 = this.vCards[_loc_4];
                _loc_15 = _loc_5.type;
                if (_loc_15 == "E")
                {
                    _loc_15 = "B";
                }
                if (_loc_15 != _loc_8)
                {
                    if (_loc_7 >= 0)
                    {
                        _loc_7 = -1;
                        _loc_2 = _loc_2 + 150;
                        _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                    }
                    _loc_2 = _loc_2 + 100;
                    if (_loc_8 != "")
                    {
                        _loc_2 = _loc_2 + 30;
                    }
                    else
                    {
                        _loc_2 = _loc_2 - 130;
                    }
                    _loc_8 = _loc_15;
                    _loc_9 = new ListTitle();
                    _loc_21 = Global.getText("txtCardTitle").replace(/#/, Global.getText("txtCardType" + _loc_8));
                    _loc_9.txtListTitle.htmlText = "<B>" + _loc_21 + "</B>";
                    Global.vLang.checkSans(_loc_9.txtListTitle);
                    _loc_9.y = _loc_2 + _loc_9.height / 2;
                    _loc_6.addChild(new ButtonGrafBitmap(_loc_9));
                    if (Global.vServer.vUser.vLevel >= 7)
                    {
                        if (_loc_15 == "P" || _loc_15 == "S")
                        {
                            addButton(_loc_6, new bitmapClip(vImages["button_trade"]), new Point(_loc_9.x + 200, _loc_9.y), this.startTrade, 1, {type:_loc_15}, false);
                        }
                    }
                }
                _loc_14 = new CardManagerSlot();
                _loc_15 = _loc_5.id;
                _loc_17 = _loc_5.nb;
                _loc_11 = new Card("Card", _loc_15, 0, false);
                _loc_14.addChild(_loc_11);
                _loc_16 = getLevelMin(_loc_5.id);
                if (Global.vServer.vUser.vLevel < _loc_16)
                {
                    _loc_14.gotoAndStop("Locked");
                    _loc_14.txtLocked.htmlText = "<B>" + Global.getText("txtLevelRequired").replace(/#/, _loc_16) + "</B>";
                    Global.vLang.checkSans(_loc_14.txtLocked);
                    Toolz.textReduce(_loc_14.txtLocked);
                    _loc_11.setShadow();
                }
                else
                {
                    _loc_10 = Card.getTitle(_loc_15);
                    _loc_14.txtTitle.htmlText = "<b>" + _loc_10 + "</b>";
                    Global.vLang.checkSans(_loc_14.txtTitle);
                    _loc_14.txtNb.htmlText = "<B>" + "x" + _loc_17 + "</B>";
                    Global.vLang.checkSans(_loc_14.txtNb);
                    Toolz.textReduce(_loc_14.txtTitle);
                    if (_loc_17 == 0)
                    {
                        _loc_11.setShadow();
                    }
                }
                _loc_19 = new MovieClip();
                _loc_19.addChild(new ButtonGrafBitmap(_loc_14));
                _loc_19.x = _loc_7 * 200;
                _loc_20 = 170;
                _loc_19.y = _loc_2 + _loc_20;
                _loc_6.addChild(_loc_19);
                _loc_7++;
                if (_loc_7 == 2)
                {
                    _loc_7 = -1;
                    _loc_2 = _loc_2 + _loc_20;
                    _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
                }
                _loc_19.vType = _loc_15;
                if (Capabilities.isDebugger)
                {
                    _loc_19.addEventListener(MouseEvent.CLICK, this.onClickCard);
                }
                else
                {
                    _loc_19.addEventListener(TouchEvent.TOUCH_TAP, this.onClickCard);
                }
                _loc_4++;
            }
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            _loc_2 = _loc_2 + addMarge(_loc_6, 0, _loc_2);
            var _loc_18:* = new Point(640, 740);
            _loc_18.y = _loc_18.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            this.vPanel = new SlidePanel(_loc_6, _loc_18);
            this.vPanel.x = 0;
            this.vPanel.y = -20;
            layerMenu.addChild(this.vPanel);
            _loc_2 = _loc_2 + _loc_3;
            this.vPanel.forceX(Global.vSize.x / 2);
            if (vPanelPos != null)
            {
                this.vPanel.vContent.y = vPanelPos.y;
                vPanelPos = null;
            }
            return;
        }// end function

        private function onClickCard(event:Event) : void
        {
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            var _loc_2:* = event.currentTarget.vType;
            showCardHelp(_loc_2);
            return;
        }// end function

        private function startTrade(event:Event) : void
        {
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            Global.vSound.onButton();
            var _loc_2:* = event.currentTarget.vArgs.type;
            new MsgBox(this, "", this.afterTrade, MsgBox.TYPE_Trade, {type:_loc_2});
            return;
        }// end function

        private function afterTrade(param1:Object) : void
        {
            if (param1.refresh)
            {
                vPanelPos = {y:this.vPanel.vContent.y};
                Global.vRoot.launchMenu(CardManager);
            }
            return;
        }// end function

        public static function getLevelMin(param1:String) : int
        {
            var _loc_2:* = Global.vServer.vCardsAvailability.cards;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if (_loc_2[_loc_3] == param1)
                {
                    return Global.vServer.vCardsAvailability.levels[_loc_3];
                }
                _loc_3++;
            }
            return 1;
        }// end function

        public static function showCardHelp(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1.substr(0, 1) == "E")
            {
                _loc_2 = Global.getText("txtCardEXHelp");
                _loc_2 = _loc_2.replace(/#/, param1.substr(1));
                _loc_3 = Global.getText("txtCardEX");
                _loc_3 = _loc_3.replace(/#/, param1.substr(1));
            }
            else
            {
                _loc_2 = Global.getText("txtCard" + param1 + "Help");
                _loc_3 = Global.getText("txtCard" + param1);
            }
            new MsgBox(Global.vRoot, _loc_2, null, MsgBox.TYPE_CardHelp, {card:param1}, _loc_3);
            return;
        }// end function

    }
}
