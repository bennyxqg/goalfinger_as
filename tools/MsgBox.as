package tools
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.screens.*;
    import menu.tools.*;
    import sparks.*;

    public class MsgBox extends MovieClip
    {
        private var vImages:Object;
        private var vCallback:Function;
        private var vType:int;
        private var vGraf:Sprite;
        private var vDone:Boolean = true;
        private var vArgs:Object;
        private var vArgsLocal:Object;
        private var vAnswer:Boolean;
        private var vFrame:int;
        private var vTitle:String;
        private var vBG:MsgboxBG;
        private var vNewCards:Array;
        private var vNewCardsPack:Boolean = false;
        private var vLastNewCard:Object;
        private var vButtonsYesNo:Boolean = false;
        private var vCheckBox:MovieClip;
        private var vPanel:SlidePanel;
        private var vZone:MsgBoxGrafZone;
        private var vTradeRunning:Boolean = false;
        private var vTradeStock1:Sprite;
        private var vTradeStock2:Sprite;
        private var vTradeLastNum:int;
        private var vTradeButtons:Sprite;
        private var vRevealAnim:CardAnimation;
        private var vRevealTitle:MsgboxCardName;
        private var vCardNeedReveal:Object;
        private var vForceNb:int = 0;
        private var vRevealAnimRunning:Boolean = false;
        public static var TYPE_SimpleText:int = 1;
        public static var TYPE_TextWithGraf:int = 2;
        public static var TYPE_YesNo:int = 3;
        public static var TYPE_YesNoWithGraf:int = 4;
        public static var Type_TwoButtons:int = 5;
        public static var TYPE_NewCard:int = 6;
        public static var TYPE_CardHelp:int = 7;
        public static var TYPE_BuyWithCards:int = 11;
        public static var TYPE_BuyWithGold:int = 12;
        public static var TYPE_BuyWithCurrency:int = 13;
        public static var TYPE_NewChar:int = 14;
        public static var TYPE_NewShirt:int = 15;
        public static var TYPE_AskTraining:int = 21;
        public static var TYPE_AskBeforeBuy:int = 22;
        public static var TYPE_Recuperation:int = 31;
        public static var TYPE_Trade:int = 32;
        public static var TYPE_Sell:int = 33;
        public static var TYPE_ConsecutiveWins:int = 41;

        public function MsgBox(param1:DisplayObjectContainer, param2:String, param3:Function = null, param4:int = 1, param5:Object = null, param6:String = "", param7:int = 1, param8:Number = 0)
        {
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_23:* = null;
            var _loc_24:* = 0;
            var _loc_25:* = 0;
            var _loc_26:* = null;
            var _loc_27:* = null;
            var _loc_28:* = null;
            var _loc_29:* = null;
            var _loc_30:* = null;
            var _loc_31:* = null;
            this.vArgsLocal = new Object();
            this.vType = param4;
            this.vArgs = param5;
            this.vFrame = param7;
            this.vTitle = param6;
            Toolz.traceObject(param5);
            if (param3 != null)
            {
                this.vCallback = param3;
            }
            var _loc_11:* = Global.vResolution;
            if (Global.vResolutionForced)
            {
                _loc_11 = _loc_11 / 10;
            }
            if (param8 > 0)
            {
                TweenMax.delayedCall(param8, this.onClick);
            }
            this.vBG = new MsgboxBG();
            this.vBG.width = Global.vSize.x + 2 * Global.vScreenDelta.x / Global.vResolution;
            this.vBG.height = Global.vSize.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            addChild(this.vBG);
            TweenMax.from(this.vBG, 0.3, {alpha:0});
            if (Capabilities.isDebugger)
            {
                this.vBG.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown, true);
            }
            else
            {
                this.vBG.addEventListener(TouchEvent.TOUCH_BEGIN, this.onDown, true);
            }
            x = Global.vSize.x / 2;
            y = Global.vSize.y / 2;
            if (param1 == null)
            {
                return;
            }
            if (Global.vRoot == null)
            {
                return;
            }
            if (Global.vRoot.layerPopup == null)
            {
                return;
            }
            Global.vRoot.layerPopup.addChild(this);
            var _loc_12:* = new MsgBoxGraf();
            var _loc_13:* = "";
            var _loc_18:* = true;
            var _loc_19:* = true;
            var _loc_20:* = "";
            if (param5 != null)
            {
                if (param5.subtitle != null && param5.subtitle != "")
                {
                    _loc_20 = " (" + param5.subtitle + ")";
                }
            }
            if (this.vType == TYPE_SimpleText)
            {
                _loc_12.gotoAndStop("SimpleText");
                _loc_13 = param2;
            }
            else if (this.vType == TYPE_TextWithGraf)
            {
                _loc_12.gotoAndStop("TextWithGraf");
                param5.graf.x = _loc_12.mcGraf.x;
                param5.graf.y = _loc_12.mcGraf.y;
                _loc_12.addChild(param5.graf);
                _loc_13 = param2;
            }
            else if (this.vType == TYPE_YesNo)
            {
                _loc_12.gotoAndStop("YesNo");
                this.vButtonsYesNo = true;
                _loc_13 = param2;
            }
            else if (this.vType == TYPE_YesNoWithGraf)
            {
                _loc_12.gotoAndStop("YesNoWithGraf");
                param5.graf.x = _loc_12.mcGraf.x;
                param5.graf.y = _loc_12.mcGraf.y;
                _loc_12.addChild(param5.graf);
                this.vButtonsYesNo = true;
                _loc_13 = param2;
            }
            else if (this.vType == Type_TwoButtons)
            {
                _loc_12.gotoAndStop("TwoButtons");
                this.vButtonsYesNo = true;
                _loc_13 = param2;
            }
            else if (this.vType == TYPE_BuyWithGold || this.vType == TYPE_BuyWithCurrency || this.vType == TYPE_BuyWithCards)
            {
                _loc_12.gotoAndStop("AskBuy");
                _loc_13 = param2;
                this.vButtonsYesNo = true;
                this.vArgs.graf.x = _loc_12.mcGraf.x;
                this.vArgs.graf.y = _loc_12.mcGraf.y;
                _loc_12.addChild(this.vArgs.graf);
                _loc_12.txtCost.htmlText = "";
                _loc_12.txtNum.htmlText = "";
                if (this.vType == TYPE_BuyWithGold)
                {
                    _loc_23 = new GoldMsgBox();
                    _loc_23.txtGold.htmlText = "<B>" + this.vArgs.goldPrice.toString() + "</B>";
                    Toolz.textReduce(_loc_23.txtGold);
                    _loc_23.x = _loc_12.mcCost.x;
                    _loc_23.y = _loc_12.mcCost.y;
                    _loc_12.addChild(_loc_23);
                }
                else if (this.vType == TYPE_BuyWithCurrency)
                {
                    _loc_12.txtCost.htmlText = "<B>" + this.vArgs.currencyPrice.toString() + "</B>";
                    Global.vLang.checkSans(_loc_12.txtCost);
                }
                else if (this.vType == TYPE_BuyWithCards)
                {
                    _loc_12.txtNum.htmlText = "<B>x" + param5.cardNb + "</B>";
                    Global.vLang.checkSans(_loc_12.txtNum);
                    Toolz.textReduce(_loc_12.txtNum);
                    _loc_12.txtNum.mouseEnabled = false;
                    _loc_15 = new Card("Card", param5.cardType);
                    _loc_15.x = _loc_12.mcCost.x;
                    _loc_15.y = _loc_12.mcCost.y;
                    _loc_12.addChild(_loc_15);
                }
            }
            else if (this.vType == TYPE_NewCard)
            {
                _loc_18 = false;
                _loc_19 = false;
                _loc_12.gotoAndStop("NewCard");
                _loc_24 = 0;
                _loc_9 = 0;
                while (_loc_9 < param5.cards.length)
                {
                    
                    if (param5.cards[_loc_9].nb == null)
                    {
                        Global.addLogTrace("ERROR FORMAT CARD : " + JSON.stringify(param5.cards));
                        this.boxClosed();
                        return;
                    }
                    _loc_24 = _loc_24 + param5.cards[_loc_9].nb;
                    _loc_9++;
                }
                if (_loc_24 > 1)
                {
                    param2 = Global.getText("txtNewCardsGiven");
                }
                else if (_loc_24 == 1)
                {
                    param2 = Global.getText("txtNewCardGiven");
                }
                else
                {
                    this.boxClosed();
                    return;
                }
                if (param5.cards != null)
                {
                    if (param5.direct)
                    {
                        _loc_14 = param5.cards[0].card;
                        _loc_15 = new Card("Card", _loc_14, 0, false);
                        _loc_15.y = _loc_12.mcCard.y;
                        _loc_12.addChild(_loc_15);
                        this.vLastNewCard = {x:_loc_15.x, y:_loc_15.y, type:_loc_14, nb:1};
                        _loc_12.txtTitle.htmlText = "<B>" + Card.getTitle(_loc_14) + "</B>";
                        Global.vLang.checkSans(_loc_12.txtTitle);
                        _loc_12.txtTitle.mouseEnabled = false;
                        Global.vServer.vUser.addCards(_loc_14, 1);
                        Global.vSound.onGift();
                    }
                    else
                    {
                        _loc_12.txtTitle.htmlText = "";
                        this.vNewCardsPack = true;
                        this.vNewCards = param5.cards;
                    }
                }
            }
            else if (this.vType == TYPE_CardHelp)
            {
                _loc_12.gotoAndStop("CardHelp");
                _loc_12.txtRarity.htmlText = "";
                _loc_12.txtTitle.htmlText = "<B>" + param6 + "</B>";
                Global.vLang.checkSans(_loc_12.txtTitle);
                Toolz.textReduce(_loc_12.txtTitle);
                _loc_12.txtTitle.mouseEnabled = false;
                if (param5.card != null)
                {
                    _loc_15 = new Card("Card", param5.card);
                    _loc_15.x = _loc_12.mcCard.x;
                    _loc_15.y = _loc_12.mcCard.y;
                    _loc_12.addChild(_loc_15);
                    _loc_25 = 1;
                    if (param5.card == "PB" || param5.card == "BV" || param5.card == "SB")
                    {
                        _loc_25 = 2;
                    }
                    else if (param5.card == "PC" || param5.card == "SC")
                    {
                        _loc_25 = 3;
                    }
                    _loc_12.txtRarity.htmlText = "<b>" + Global.getText("txtCardRarity" + _loc_25) + "</b>";
                    Global.vLang.checkSans(_loc_12.txtRarity);
                }
            }
            else if (this.vType == TYPE_NewChar || this.vType == TYPE_NewShirt)
            {
                _loc_12.gotoAndStop("NewItem");
                _loc_19 = false;
                _loc_16 = new PersoGrafMain();
                _loc_16.init();
                if (this.vType == TYPE_NewChar)
                {
                    _loc_16.setGraf(param5.charId, Global.vServer.vUser.vCurShirt, false, Global.vSWFImages, Global.vSWFLoader);
                }
                else if (this.vType == TYPE_NewShirt)
                {
                    _loc_16.setGraf(Global.vServer.vUser.getCharAtPosition(1).vCharId, param5.code, false, Global.vSWFImages, Global.vSWFLoader);
                }
                var _loc_32:* = 3;
                _loc_16.scaleY = 3;
                _loc_16.scaleX = _loc_32;
                _loc_16.setOrientation(0);
                _loc_16.x = _loc_12.mcChar.x;
                _loc_16.y = _loc_12.mcChar.y;
                _loc_12.addChild(_loc_16);
            }
            else if (this.vType == TYPE_AskTraining)
            {
                _loc_12.gotoAndStop("AskTraining");
                this.vButtonsYesNo = true;
                param5.graf.x = _loc_12.mcGraf.x;
                param5.graf.y = _loc_12.mcGraf.y;
                _loc_12.addChild(param5.graf);
                _loc_12.mcUpgrade.gotoAndStop(param5.frameTextUpgrade);
                _loc_12.mcUpgrade.txtValueBefore.text = "+" + param5.valueFrom.toString();
                _loc_12.mcUpgrade.txtValueAfter.text = "+" + ((param5.valueFrom + 1)).toString();
            }
            else if (this.vType == TYPE_AskBeforeBuy)
            {
                _loc_12.gotoAndStop("AskBeforeBuy");
                this.vButtonsYesNo = true;
                if (param5.subtext != null && param5.subtext != "")
                {
                    param5.graf.x = _loc_12.mcGraf.x;
                    param5.graf.y = _loc_12.mcGraf.y;
                    _loc_12.txtSubtitle.htmlText = "<B>" + param5.subtext + "</B>";
                }
                else
                {
                    _loc_12.txtSubtitle.htmlText = "";
                    param5.graf.x = _loc_12.mcGrafNoSubtext.x;
                    param5.graf.y = _loc_12.mcGrafNoSubtext.y;
                }
                this.vArgsLocal.grafPos = new Point(param5.graf.x, param5.graf.y);
                _loc_12.addChild(param5.graf);
                Global.vLang.checkSans(_loc_12.txtSubtitle);
                Toolz.textReduce(_loc_12.txtSubtitle);
                _loc_12.txtSubtitle.y = _loc_12.txtSubtitle.y - _loc_12.txtSubtitle.textHeight / 2;
            }
            else if (this.vType == TYPE_Recuperation)
            {
                _loc_12.gotoAndStop("Recuperation");
                _loc_26 = this.vArgs.vChar;
                _loc_27 = getPerso(_loc_26.vCharId, Global.vServer.vUser.vCurShirt);
                _loc_27.x = _loc_12.mcGraf.x;
                _loc_27.y = _loc_12.mcGraf.y;
                _loc_12.addChild(_loc_27);
                new EnergyBar(_loc_26, _loc_12, _loc_12.mcEnergy.x, _loc_12.mcEnergy.y);
                param2 = Global.getText("txtRecuperationInvite").replace(/#/, _loc_26.vName);
                _loc_13 = param2;
                this.vArgsLocal.posCard = new Point(_loc_12.mcCard.x, _loc_12.mcCard.y);
                this.vArgsLocal.posButtonQuit = new Point(_loc_12.mcQuit.x, _loc_12.mcQuit.y);
            }
            else if (this.vType == TYPE_Trade)
            {
                _loc_12.gotoAndStop("Trade");
                _loc_28 = this.vArgs.type;
                param2 = Global.getText("txtTradeTitle");
                _loc_29 = ["A", "B", "C"];
                _loc_9 = 1;
                while (_loc_9 <= 2)
                {
                    
                    _loc_30 = _loc_12["mcLine" + _loc_9];
                    _loc_30.txtRate.text = Global.vExchangeRate.toString() + " x";
                    _loc_14 = _loc_28 + _loc_29[(_loc_9 - 1)];
                    _loc_15 = new Card("Card", _loc_14, 1, false);
                    _loc_15.x = _loc_30.mcCard1.x;
                    _loc_15.y = _loc_30.mcCard1.y;
                    _loc_30.addChild(_loc_15);
                    _loc_14 = _loc_28 + _loc_29[_loc_9];
                    _loc_15 = new Card("Card", _loc_14, 1, false);
                    _loc_15.x = _loc_30.mcCard2.x;
                    _loc_15.y = _loc_30.mcCard2.y;
                    _loc_30.addChild(_loc_15);
                    this.vArgsLocal["posParticle" + _loc_9] = new Point(_loc_30.x + _loc_30.mcCard2.x, _loc_30.y + _loc_30.mcCard2.y);
                    this.vArgsLocal["posStock" + _loc_9] = new Point(_loc_30.x + _loc_30.mcStock.x, _loc_30.y + _loc_30.mcStock.y);
                    this.vArgsLocal["posGo" + _loc_9] = new Point(_loc_30.x + _loc_30.mcGo.x, _loc_30.y + _loc_30.mcGo.y);
                    _loc_9++;
                }
                this.vArgsLocal.posButtonQuit = new Point(_loc_12.mcQuit.x, _loc_12.mcQuit.y);
            }
            else if (this.vType == TYPE_Sell)
            {
                _loc_12.gotoAndStop("Sell");
                _loc_13 = "";
                _loc_12.txtTitle.htmlText = "<B>" + Global.getText("txtSellConfirmTitle") + "</B>";
                Global.vLang.checkSans(_loc_12.txtTitle);
                Toolz.textReduce(_loc_12.txtTitle);
                _loc_12.txtConfirm.htmlText = "<B>" + Global.getText("txtSellConfirmInvite") + "</B>";
                Global.vLang.checkSans(_loc_12.txtConfirm);
                Toolz.textReduce(_loc_12.txtConfirm);
                _loc_12.txtGold.htmlText = "<B>" + this.vArgs.price.toString() + "</B>";
                this.vArgsLocal.posCheckBox = new Point(_loc_12.mcCheckBox.x, _loc_12.mcCheckBox.y);
                this.vButtonsYesNo = true;
            }
            else if (this.vType == TYPE_ConsecutiveWins)
            {
                _loc_12.gotoAndStop("ConsecutiveWins");
                param2 = Global.getText("txtConsecutiveWinsInvite");
                this.vArgsLocal.posZone = new Point(_loc_12.mcZone.x, _loc_12.mcZone.y);
                this.vArgsLocal.posButtonQuit = new Point(_loc_12.mcQuit.x, _loc_12.mcQuit.y);
            }
            else
            {
                return;
            }
            if (this.vButtonsYesNo)
            {
                this.vArgsLocal.posButtonNo = new Point(_loc_12.mcNo.x, _loc_12.mcNo.y);
                this.vArgsLocal.posButtonYes = new Point(_loc_12.mcYes.x, _loc_12.mcYes.y);
            }
            _loc_12.txtMsg.htmlText = "<B>" + param2 + _loc_20 + "</B>";
            Global.vLang.checkSans(_loc_12.txtMsg);
            Toolz.textReduce(_loc_12.txtMsg);
            _loc_12.txtMsg.mouseEnabled = false;
            if (_loc_19)
            {
                _loc_12.txtMsg.y = _loc_12.txtMsg.y - _loc_12.txtMsg.textHeight / 2;
            }
            this.vImages = new Object();
            var _loc_21:* = new mcToBitmapQueue();
            var _loc_22:* = new MovieClip();
            _loc_22.addChild(_loc_12);
            this.vImages["box"] = new mcToBitmapAS3(_loc_22, 0, _loc_11, true, null, 0, _loc_21);
            if (this.vButtonsYesNo)
            {
                if (this.vType == Type_TwoButtons)
                {
                    _loc_31 = new Menu_TextButtonMsgbox();
                    _loc_31.txtLabel.htmlText = "<B>" + this.vArgs.labelNo + "</B>";
                    Global.vLang.checkSans(_loc_31.txtLabel);
                    Toolz.textReduce(_loc_31.txtLabel);
                    this.vImages["bno"] = new mcToBitmapAS3(_loc_31, 0, _loc_11, true, null, 0, _loc_21);
                    _loc_31 = new Menu_TextButtonMsgboxGreen();
                    _loc_31.txtLabel.htmlText = "<B>" + this.vArgs.labelYes + "</B>";
                    Global.vLang.checkSans(_loc_31.txtLabel);
                    Toolz.textReduce(_loc_31.txtLabel);
                    this.vImages["byes"] = new mcToBitmapAS3(_loc_31, 0, _loc_11, true, null, 0, _loc_21);
                }
                else
                {
                    this.vImages["byes"] = new mcToBitmapAS3(new MenuButton_Ok_Large(), 0, _loc_11, true, null, 0, _loc_21);
                    this.vImages["bno"] = new mcToBitmapAS3(new MenuButton_Quit(), 0, _loc_11, true, null, 0, _loc_21);
                }
            }
            _loc_21.startConversion(this.initGameGrafDone);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            return;
        }// end function

        private function onStageRemoved(event:Event) : void
        {
            var _loc_2:* = undefined;
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            for (_loc_2 in this.vImages)
            {
                
                _loc_4[_loc_2].destroyAll();
                delete _loc_4[_loc_2];
            }
            return;
        }// end function

        private function onDown(event:Event) : void
        {
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function onClickBG(event:Event) : void
        {
            return;
        }// end function

        private function initGameGrafDone() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = NaN;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = null;
            this.vGraf = new Sprite();
            addChild(this.vGraf);
            var _loc_2:* = new bitmapClip(this.vImages["box"]);
            this.vGraf.addChild(_loc_2);
            if (this.vButtonsYesNo)
            {
                _loc_4 = new Sprite();
                _loc_4.addChild(new bitmapClip(this.vImages["bno"]));
                _loc_4.x = this.vArgsLocal.posButtonNo.x;
                _loc_4.y = this.vArgsLocal.posButtonNo.y;
                if (Capabilities.isDebugger)
                {
                    _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.onClickNo);
                }
                else
                {
                    _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.onClickNo);
                }
                this.vGraf.addChild(_loc_4);
                _loc_4 = new Sprite();
                _loc_4.addChild(new bitmapClip(this.vImages["byes"]));
                _loc_4.x = this.vArgsLocal.posButtonYes.x;
                _loc_4.y = this.vArgsLocal.posButtonYes.y;
                if (Capabilities.isDebugger)
                {
                    _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.onClickYes);
                }
                else
                {
                    _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.onClickYes);
                }
                this.vGraf.addChild(_loc_4);
            }
            if (this.vType == TYPE_Recuperation)
            {
                _loc_5 = Global.vServer.vUser.getEnergyCards();
                _loc_6 = 120;
                if (_loc_5.length == 0)
                {
                    _loc_10 = Global.getText("txtNoCardRecuperation");
                    _loc_10 = _loc_10 + "<br>" + Global.getText("txtAskGoShop");
                    new MsgBox(this, _loc_10, this.onRecuperationBuyCard, MsgBox.TYPE_YesNo);
                    return;
                }
                _loc_9 = 0;
                while (_loc_9 < _loc_5.length)
                {
                    
                    _loc_7 = new ButtonGrafBitmap(new Card("Card", _loc_5[_loc_9].card, _loc_5[_loc_9].nb, false));
                    _loc_1 = new MovieClip();
                    _loc_1.addChild(_loc_7);
                    _loc_1.x = this.vArgsLocal.posCard.x + _loc_6 * _loc_9;
                    if (_loc_5.length == 2)
                    {
                        _loc_1.x = _loc_1.x - _loc_6 / 2;
                    }
                    else if (_loc_5.length == 3)
                    {
                        _loc_1.x = _loc_1.x - _loc_6;
                    }
                    _loc_1.y = this.vArgsLocal.posCard.y;
                    _loc_1.vCard = _loc_5[_loc_9].card;
                    _loc_1.vCharId = this.vArgs.vChar.vCharId;
                    this.vGraf.addChild(_loc_1);
                    if (Capabilities.isDebugger)
                    {
                        _loc_1.addEventListener(MouseEvent.MOUSE_DOWN, this.onCardEnergy);
                    }
                    else
                    {
                        _loc_1.addEventListener(TouchEvent.TOUCH_BEGIN, this.onCardEnergy);
                    }
                    _loc_8 = new MsgboxCardName();
                    _loc_8.txtTitle.text = "x" + _loc_5[_loc_9].nb.toString();
                    _loc_8.x = _loc_1.x;
                    _loc_8.y = _loc_1.y + 90;
                    this.vGraf.addChild(_loc_8);
                    _loc_9++;
                }
                _loc_3 = new ButtonGrafBitmap(new MenuButton_Quit());
                _loc_3.x = this.vArgsLocal.posButtonQuit.x;
                _loc_3.y = this.vArgsLocal.posButtonQuit.y;
                this.vGraf.addChild(_loc_3);
            }
            else if (this.vType == TYPE_Trade)
            {
                this.refreshTradeStock();
                _loc_3 = new ButtonGrafBitmap(new MenuButton_Quit());
                _loc_3.x = this.vArgsLocal.posButtonQuit.x;
                _loc_3.y = this.vArgsLocal.posButtonQuit.y;
                this.vGraf.addChild(_loc_3);
            }
            else if (this.vType == TYPE_Sell)
            {
                _loc_1 = new MsgBoxGraf_CheckBox();
                _loc_1.gotoAndStop(3);
                _loc_1.x = this.vArgsLocal.posCheckBox.x;
                _loc_1.y = this.vArgsLocal.posCheckBox.y;
                this.vGraf.addChild(_loc_1);
                this.vCheckBox = _loc_1;
                if (Capabilities.isDebugger)
                {
                    this.vCheckBox.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleCheckBox);
                }
                else
                {
                    this.vCheckBox.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleCheckBox);
                }
            }
            else if (this.vType == TYPE_ConsecutiveWins)
            {
                this.vZone = new MsgBoxGrafZone();
                this.vZone.x = this.vArgsLocal.posZone.x;
                this.vZone.y = this.vArgsLocal.posZone.y;
                this.vGraf.addChild(this.vZone);
                if (Capabilities.isDebugger)
                {
                    this.addEventListener(MouseEvent.MOUSE_DOWN, this.onZoneDown);
                }
                else
                {
                    this.addEventListener(TouchEvent.TOUCH_BEGIN, this.onZoneDown);
                }
                _loc_11 = Global.vConsecutiveWins.length;
                _loc_13 = 80;
                _loc_14 = 1.5;
                _loc_15 = new Sprite();
                _loc_16 = 0;
                _loc_9 = 0;
                while (_loc_9 < _loc_11)
                {
                    
                    _loc_12 = new ConsecutiveWinStep(_loc_9, _loc_9 == Global.vServer.vUser.vConsecutiveWins, false, false, true, _loc_14);
                    _loc_12.x = _loc_9 * _loc_13 * _loc_14;
                    _loc_15.addChild(_loc_12);
                    if (_loc_9 == Global.vServer.vUser.vConsecutiveWins)
                    {
                        _loc_16 = _loc_12.x;
                    }
                    _loc_9++;
                }
                this.vPanel = new SlidePanel(_loc_15, new Point(460, 220));
                this.vPanel.x = this.vArgsLocal.posZone.x;
                this.vPanel.y = this.vArgsLocal.posZone.y;
                this.vGraf.addChild(this.vPanel);
                this.vPanel.vContent.x = -_loc_16 + 230;
                _loc_3 = new ButtonGrafBitmap(new MenuButton_Quit());
                _loc_3.x = this.vArgsLocal.posButtonQuit.x;
                _loc_3.y = this.vArgsLocal.posButtonQuit.y;
                this.vGraf.addChild(_loc_3);
            }
            else if (this.vType == TYPE_AskBeforeBuy)
            {
                if (this.vArgs.sparkle == true)
                {
                    _loc_17 = new SparkleAnimation();
                    _loc_17.x = this.vArgsLocal.grafPos.x;
                    _loc_17.y = this.vArgsLocal.grafPos.y;
                    this.vGraf.addChild(_loc_17);
                }
            }
            if (Capabilities.isDebugger)
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            }
            else
            {
                this.addEventListener(TouchEvent.TOUCH_BEGIN, this.onClick);
            }
            TweenMax.from(this.vGraf, 0.3, {scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:this.onMsgBoxReady});
            Global.vSound.onSlide();
            if (this.vType == TYPE_NewCard)
            {
                this.revealNewCards();
            }
            return;
        }// end function

        private function toggleCheckBox(event:Event) : void
        {
            Global.vSound.onButton();
            if (this.vCheckBox.currentFrame == 3)
            {
                this.vCheckBox.gotoAndStop(2);
            }
            else
            {
                this.vCheckBox.gotoAndStop(3);
            }
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function onZoneDown(event:Event) : void
        {
            var _loc_2:* = true;
            if (Math.abs(this.vZone.mouseX) > 255)
            {
                _loc_2 = false;
            }
            if (Math.abs(this.vZone.mouseY) > 90)
            {
                _loc_2 = false;
            }
            this.vZone.vRunning = _loc_2;
            return;
        }// end function

        private function onRecuperationBuyCard(param1:Boolean) : void
        {
            if (param1)
            {
                Global.vRoot.launchMenu(Shop);
            }
            this.closeBox();
            return;
        }// end function

        private function onCardEnergy(event:Event) : void
        {
            this.vArgs = {charId:event.currentTarget.vCharId, card:event.currentTarget.vCard};
            return;
        }// end function

        private function refreshTradeStock() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this.vTradeButtons == null)
            {
                this.vTradeButtons = new Sprite();
                this.vGraf.addChild(this.vTradeButtons);
            }
            else
            {
                while (this.vTradeButtons.numChildren > 0)
                {
                    
                    this.vTradeButtons.removeChildAt(0);
                }
            }
            var _loc_2:* = 1;
            while (_loc_2 <= 2)
            {
                
                if (this.canTrade(this.vArgs.type, _loc_2) > 0)
                {
                    _loc_5 = new Button_Go();
                }
                else
                {
                    _loc_5 = new Button_Go_White();
                }
                _loc_5.mcGo.txLabel.htmlText = "<B>" + Global.getText("txtButtonGo") + "</B>";
                Global.vLang.checkSans(_loc_5.mcGo.txLabel);
                _loc_1 = new MovieClip();
                _loc_1.addChild(new ButtonGrafBitmap(_loc_5));
                _loc_1.x = this.vArgsLocal["posGo" + _loc_2].x;
                _loc_1.y = this.vArgsLocal["posGo" + _loc_2].y;
                this.vTradeButtons.addChild(_loc_1);
                _loc_1.type = this.vArgs.type;
                _loc_1.num = _loc_2;
                if (Capabilities.isDebugger)
                {
                    _loc_1.addEventListener(MouseEvent.MOUSE_DOWN, this.startTrade);
                }
                else
                {
                    _loc_1.addEventListener(TouchEvent.TOUCH_BEGIN, this.startTrade);
                }
                _loc_2++;
            }
            if (this.vTradeStock1 != null)
            {
                if (this.vTradeStock1.parent != null)
                {
                    this.vTradeStock1.parent.removeChild(this.vTradeStock1);
                    this.vTradeStock1 = null;
                }
            }
            if (this.vTradeStock2 != null)
            {
                if (this.vTradeStock2.parent != null)
                {
                    this.vTradeStock2.parent.removeChild(this.vTradeStock2);
                    this.vTradeStock2 = null;
                }
            }
            _loc_2 = 1;
            while (_loc_2 <= 2)
            {
                
                _loc_4 = new MsgBoxTradeLineStock();
                if (_loc_2 == 1)
                {
                    _loc_4.txtNb1.text = "(x" + Global.vServer.vUser.getCards(this.vArgs.type + "A") + ")";
                    _loc_4.txtNb2.text = "(x" + Global.vServer.vUser.getCards(this.vArgs.type + "B") + ")";
                }
                else
                {
                    _loc_4.txtNb1.text = "(x" + Global.vServer.vUser.getCards(this.vArgs.type + "B") + ")";
                    _loc_4.txtNb2.text = "(x" + Global.vServer.vUser.getCards(this.vArgs.type + "C") + ")";
                }
                _loc_6 = new ButtonGrafBitmap(_loc_4);
                _loc_6.x = this.vArgsLocal["posStock" + _loc_2].x;
                _loc_6.y = this.vArgsLocal["posStock" + _loc_2].y;
                this.vGraf.addChild(_loc_6);
                if (_loc_2 == 1)
                {
                    this.vTradeStock1 = _loc_6;
                }
                else if (_loc_2 == 2)
                {
                    this.vTradeStock2 = _loc_6;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function canTrade(param1:String, param2:int) : int
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param2 == 1)
            {
                _loc_3 = param1 + "A";
            }
            else if (param2 == 2)
            {
                _loc_3 = param1 + "B";
            }
            else
            {
                return 0;
            }
            if (param2 == 1)
            {
                _loc_4 = param1 + "B";
            }
            else if (param2 == 2)
            {
                _loc_4 = param1 + "C";
            }
            else
            {
                return 0;
            }
            if (Global.vServer.vUser.vLevel < CardManager.getLevelMin(_loc_4))
            {
                return -100 - CardManager.getLevelMin(_loc_4);
            }
            if (Global.vServer.vUser.getCards(_loc_3) < Global.vExchangeRate)
            {
                return Global.vServer.vUser.getCards(_loc_3) - Global.vExchangeRate;
            }
            return 1;
        }// end function

        private function startTrade(event:Event) : void
        {
            var _loc_5:* = null;
            event.stopPropagation();
            event.stopImmediatePropagation();
            var _loc_2:* = event.currentTarget.type;
            var _loc_3:* = event.currentTarget.num;
            Global.vSound.onButton();
            var _loc_4:* = this.canTrade(_loc_2, _loc_3);
            if (this.canTrade(_loc_2, _loc_3) <= 0)
            {
                if (_loc_4 < -100)
                {
                    new MsgBox(Global.vRoot, Global.getText("txtLevelRequired").replace(/#/, -100 - _loc_4));
                }
                else
                {
                    if (_loc_4 == -1)
                    {
                        _loc_5 = Global.getText("txtNotEnoughCard1");
                    }
                    else
                    {
                        _loc_5 = Global.getText("txtNotEnoughCardN").replace(/#/, -_loc_4);
                    }
                    new MsgBox(Global.vRoot, _loc_5);
                }
                return;
            }
            if (this.vTradeRunning)
            {
                return;
            }
            this.vTradeRunning = true;
            this.vTradeLastNum = _loc_3;
            if (_loc_3 == 1)
            {
                _loc_2 = _loc_2 + "A";
            }
            else if (_loc_3 == 2)
            {
                _loc_2 = _loc_2 + "B";
            }
            Global.vServer.startTrade(this.onTradeResult, _loc_2);
            return;
        }// end function

        private function onTradeResult(param1:Boolean) : void
        {
            this.vTradeRunning = false;
            if (param1)
            {
                this.vArgs.refresh = true;
                this.refreshTradeStock();
                Global.vSound.onGift();
                Global.startParticles(this.vGraf, this.vArgsLocal["posParticle" + this.vTradeLastNum], Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            }
            return;
        }// end function

        private function onMsgBoxReady() : void
        {
            var _loc_1:* = null;
            this.vDone = false;
            if (this.vType == TYPE_NewShirt || this.vType == TYPE_NewChar)
            {
                Global.vSound.onGift();
                _loc_1 = new Point(0, 0);
                Global.startParticles(this, _loc_1, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            }
            return;
        }// end function

        private function onClick(event:Event = null) : void
        {
            if (this.vType == TYPE_ConsecutiveWins)
            {
                if (this.vZone.vRunning)
                {
                    return;
                }
            }
            Global.vSound.onButton();
            if (this.revealNewCards())
            {
                return;
            }
            if (event != null)
            {
                event.stopImmediatePropagation();
            }
            if (this.vDone)
            {
                return;
            }
            if (this.vButtonsYesNo)
            {
                this.onClickNo(event);
                return;
            }
            this.vDone = true;
            this.closeBox();
            return;
        }// end function

        private function onClickNo(event:Event) : void
        {
            Global.vSound.onButton();
            event.stopImmediatePropagation();
            if (this.vDone)
            {
                return;
            }
            this.vDone = true;
            this.vAnswer = false;
            this.closeBox();
            return;
        }// end function

        private function onClickYes(event:Event) : void
        {
            Global.vSound.onButton();
            event.stopImmediatePropagation();
            if (this.vDone)
            {
                return;
            }
            this.vDone = true;
            if (this.vType == TYPE_Sell)
            {
                if (this.vCheckBox.currentFrame == 3)
                {
                    new MsgBox(this, Global.getText("txtSellConfirmNeed"));
                    this.vDone = false;
                    return;
                }
            }
            this.vAnswer = true;
            this.closeBox();
            return;
        }// end function

        private function closeBox() : void
        {
            TweenMax.to(this.vBG, 0.3, {alpha:0});
            TweenMax.to(this.vGraf, 0.3, {scaleX:0, scaleY:0, onComplete:this.boxClosed});
            if (this.vType == TYPE_NewCard)
            {
                this.checkNewCardIcon();
            }
            return;
        }// end function

        private function onCardIconReceived() : void
        {
            return;
        }// end function

        private function boxClosed() : void
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            if (this.parent)
            {
                if (this.parent.contains(this))
                {
                    this.parent.removeChild(this);
                }
            }
            if (this.vCallback != null)
            {
                if (this.vButtonsYesNo)
                {
                    if (this.vArgs == null)
                    {
                        this.vCallback.call(0, this.vAnswer);
                    }
                    else
                    {
                        this.vCallback.call(0, this.vAnswer, this.vArgs);
                    }
                }
                else if (this.vArgs == null)
                {
                    this.vCallback.call();
                }
                else
                {
                    this.vCallback.call(0, this.vArgs);
                }
            }
            return;
        }// end function

        private function revealNewCards() : Boolean
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_7:* = null;
            if (this.vRevealAnimRunning)
            {
                return true;
            }
            if (this.vCardNeedReveal != null)
            {
                this.doRevealCard();
                return true;
            }
            if (this.vNewCards == null)
            {
                return false;
            }
            if (this.vNewCards.length == 0)
            {
                return false;
            }
            if (this.vRevealAnim != null)
            {
                this.vGraf.removeChild(this.vRevealAnim);
                this.vRevealAnim = null;
            }
            if (this.vRevealTitle != null)
            {
                this.vGraf.removeChild(this.vRevealTitle);
                this.vRevealTitle = null;
            }
            var _loc_1:* = this.checkNewCardIcon();
            if (_loc_1 > 0)
            {
                TweenMax.delayedCall(_loc_1, this.revealNewCards);
                return true;
            }
            if (this.vNewCardsPack)
            {
                _loc_7 = this.vNewCards.shift();
                _loc_2 = _loc_7.card;
                _loc_3 = _loc_7.nb;
            }
            if (_loc_3 == 0)
            {
                this.onClick();
                return false;
            }
            if (_loc_2 == null)
            {
                return false;
            }
            Global.vServer.vUser.addCards(_loc_2, _loc_3);
            var _loc_4:* = new CardAnimation();
            _loc_4.y = -10;
            this.vRevealAnim = _loc_4;
            while (_loc_4.mcCard.numChildren > 0)
            {
                
                _loc_4.mcCard.removeChildAt(0);
            }
            var _loc_5:* = new Card("Card", _loc_2);
            _loc_4.mcCard.addChild(_loc_5);
            this.vGraf.addChild(_loc_4);
            this.vLastNewCard = {x:_loc_4.x + _loc_4.mcCard.x - 7, y:_loc_4.y + _loc_4.mcCard.y + 21, type:_loc_2, nb:_loc_3};
            var _loc_6:* = new MsgboxCardName();
            _loc_6.txtTitle.htmlText = "<B>" + Card.getTitle(_loc_2) + "</B>";
            Global.vLang.checkSans(_loc_6.txtTitle);
            _loc_6.txtTitle.mouseEnabled = false;
            _loc_6.y = 50;
            _loc_6.alpha = 0;
            this.vGraf.addChild(_loc_6);
            this.vRevealTitle = _loc_6;
            this.vCardNeedReveal = {CardName:_loc_6, Animation:_loc_4, Nb:_loc_3};
            var _loc_8:* = this;
            var _loc_9:* = this.vForceNb + 1;
            _loc_8.vForceNb = _loc_9;
            TweenMax.delayedCall(0.5, this.forceClick, [this.vForceNb]);
            return true;
        }// end function

        private function forceClick(param1:int) : void
        {
            if (this.vForceNb == param1)
            {
                this.onClick();
            }
            return;
        }// end function

        private function doRevealCard() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this.vCardNeedReveal == null)
            {
                return;
            }
            Global.startParticles(this, new Point(0, 0), Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            TweenMax.to(this.vCardNeedReveal.CardName, 0.3, {y:100, alpha:10});
            Global.vSound.onGift();
            this.vCardNeedReveal.Animation.gotoAndPlay("show");
            if (this.vCardNeedReveal.Nb > 1)
            {
                _loc_1 = new CardMultiplier();
                _loc_1.txtTitle.htmlText = "<B>x" + this.vCardNeedReveal.Nb.toString() + "</B>";
                var _loc_3:* = 1.5;
                _loc_1.scaleY = 1.5;
                _loc_1.scaleX = _loc_3;
                _loc_2 = new ButtonGrafBitmap(_loc_1);
                _loc_2.x = _loc_2.x + 95;
                TweenMax.from(_loc_2, 0.3, {alpha:0});
                this.vCardNeedReveal.Animation.addChild(_loc_2);
            }
            this.vCardNeedReveal = null;
            this.vRevealAnimRunning = true;
            TweenMax.delayedCall(0.3, this.endAnimRunning);
            return;
        }// end function

        private function endAnimRunning() : void
        {
            this.vRevealAnimRunning = false;
            return;
        }// end function

        private function checkNewCardIcon() : Number
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            var _loc_7:* = null;
            if (this.vLastNewCard != null)
            {
                if (this.vLastNewCard.type == "G5")
                {
                    return 0;
                }
                if (this.vLastNewCard.type == "G10")
                {
                    return 0;
                }
                if (Global.vRoot.layerTop != null)
                {
                    _loc_1 = new Point(Global.vSize.x / 2 + this.vLastNewCard.x, Global.vSize.y / 2 + this.vLastNewCard.y);
                    _loc_2 = new Sprite();
                    _loc_2.x = Global.vSize.x * 0.38;
                    _loc_2.y = Global.vSize.y * 0.91;
                    if (Global.vTopBar != null)
                    {
                        _loc_7 = Global.vTopBar.getPosTab(2);
                        _loc_2.x = _loc_7.x;
                        _loc_2.y = _loc_7.y;
                    }
                    Global.adjustPos(_loc_2, -0.5, 1);
                    _loc_3 = new Point(_loc_2.x, _loc_2.y);
                    _loc_4 = this.vLastNewCard.nb;
                    if (_loc_4 == 2)
                    {
                        _loc_4 = 3;
                    }
                    _loc_5 = 1;
                    while (_loc_5 <= _loc_4)
                    {
                        
                        new AddIcon(Global.vRoot.layerParticle, "card_" + this.vLastNewCard.type, _loc_1, _loc_3, this.onCardIconReceived, 1, 0, 1, 3, true, 0.1);
                        _loc_5++;
                    }
                    _loc_6 = this.vLastNewCard.nb * 0.1;
                    this.vLastNewCard = null;
                    return _loc_6;
                }
            }
            return 0;
        }// end function

        public static function getPerso(param1:String, param2:String, param3:Boolean = false) : Sprite
        {
            var _loc_4:* = new PersoGrafMain();
            _loc_4.init();
            if (param3)
            {
                _loc_4.setHead(param1, Global.vSWFImages, Global.vSWFLoader);
                var _loc_6:* = 2.8;
                _loc_4.scaleY = 2.8;
                _loc_4.scaleX = _loc_6;
            }
            else
            {
                _loc_4.setGraf(param1, param2, false, Global.vSWFImages, Global.vSWFLoader);
                var _loc_6:* = 2.1;
                _loc_4.scaleY = 2.1;
                _loc_4.scaleX = _loc_6;
                _loc_4.y = 55;
                _loc_4.setOrientation(0);
            }
            var _loc_5:* = new Sprite();
            _loc_5.addChild(_loc_4);
            return _loc_5;
        }// end function

    }
}
