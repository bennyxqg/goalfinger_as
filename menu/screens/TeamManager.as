package menu.screens
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.popup.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class TeamManager extends MenuXXX
    {
        private var vChars:Vector.<Sparks_Good>;
        private var vCategs:Array;
        private var vPanel:SlidePanel;
        private var vTeamBG:TeamPreviewGraf;
        private var vButtonHelp:ButtonGrafBitmap;
        private var vCurCode:String;
        private var vCurPseudo:String;
        private var vFormInPosition:Array;
        private var vBlinkRunning:Boolean = false;
        private var vButtonsUnder:Vector.<MovieClip>;
        private var vCurForm:PersoForm;
        private var vFormOver:PersoFormOverGraf;
        private var vFormPosSave:Point;
        private var vWaiting:int = 0;
        private var vWaitingGraf:Waiting;
        private var vRecuperationForm:PersoForm;
        public static var vLastRecruitCode:String = "";
        public static var vLastRecruitPseudo:String = "";

        public function TeamManager()
        {
            this.vFormInPosition = new Array();
            vTag = "TeamManager";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            initMenu();
            this.vChars = new Vector.<Sparks_Good>;
            this.showMenu();
            this.loadChars();
            Global.vStats.Stats_PageView("TeamManager");
            return;
        }// end function

        private function loadChars() : void
        {
            this.vCategs = [""];
            this.vChars = new Vector.<Sparks_Good>;
            this.refreshList();
            this.loadNextCateg();
            return;
        }// end function

        private function loadNextCateg() : void
        {
            var _loc_1:* = null;
            if (this.vCategs.length == 0)
            {
                if (vLastRecruitCode != "")
                {
                    TweenMax.delayedCall(0.5, this.showNewRecruit);
                }
            }
            else
            {
                _loc_1 = this.vCategs.shift();
                Global.vServer.getCharsAvailable(this.onChars, _loc_1);
            }
            return;
        }// end function

        private function onChars(param1:String, param2:Vector.<Sparks_Good>) : void
        {
            if (param2 == null)
            {
                Global.addLogTrace("onChars NULL");
                return;
            }
            var _loc_3:* = 0;
            while (_loc_3 < param2.length)
            {
                
                this.vChars.push(param2[_loc_3]);
                _loc_3++;
            }
            this.refreshList();
            this.loadNextCateg();
            return;
        }// end function

        private function showMenu() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            Global.vTopBar.vTransitionRunning = false;
            cleanMenu();
            var _loc_3:* = new Button_Invisible();
            var _loc_7:* = 20;
            _loc_3.scaleY = 20;
            _loc_3.scaleX = _loc_7;
            layerMenu.addChild(_loc_3);
            if (Capabilities.isDebugger)
            {
                _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.cancelForm);
            }
            else
            {
                _loc_3.addEventListener(TouchEvent.TOUCH_BEGIN, this.cancelForm);
            }
            this.vTeamBG = new TeamPreviewGraf();
            this.vTeamBG.y = -248;
            layerMenu.addChild(this.vTeamBG);
            var _loc_4:* = new Foot2_FullView();
            _loc_4.gotoAndStop(2);
            _loc_4.mcGrass.gotoAndStop(Global.vWeather);
            while (this.vTeamBG.mcField.numChildren > 0)
            {
                
                this.vTeamBG.mcField.removeChildAt(0);
            }
            this.vTeamBG.mcField.addChild(_loc_4);
            if (Capabilities.isDebugger)
            {
                _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.cancelForm);
            }
            else
            {
                _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.cancelForm);
            }
            Global.adjustPos(this.vTeamBG, 0, -1);
            this.vButtonHelp = new ButtonGrafBitmap(new MenuButton_Help());
            var _loc_5:* = new Point(this.vTeamBG.x + 250, this.vTeamBG.y - 100);
            addButton(layerMenu, this.vButtonHelp, _loc_5, this.goHelp, 1);
            this.refreshTeamPreview();
            this.refreshList();
            var _loc_6:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_6.data.HelpCharDone == null)
            {
                Toolz.doPulseHeartBeat(this.vButtonHelp);
            }
            return;
        }// end function

        private function goHelp(event:Event = null) : void
        {
            Toolz.stopPulse(this.vButtonHelp);
            Global.vSound.onButton();
            Global.vRoot.launchPopup(HelpChar);
            return;
        }// end function

        private function refreshTeamPreview() : void
        {
            var _loc_1:* = null;
            while (this.vFormInPosition.length > 0)
            {
                
                layerMenu.removeChild(this.vFormInPosition[0]);
                this.vFormInPosition.splice(0, 1);
            }
            var _loc_2:* = 3;
            while (_loc_2 >= 1)
            {
                
                _loc_1 = new PersoForm(Global.vServer.vUser.getCharAtPosition(_loc_2), this.onClickForm, true);
                layerMenu.addChild(_loc_1);
                this.putAtPosition(_loc_1, _loc_2, 0);
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

        public function refreshAll() : void
        {
            this.refreshTeamPreview();
            this.refreshList();
            return;
        }// end function

        private function refreshList() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = false;
            var _loc_15:* = null;
            var _loc_19:* = null;
            var _loc_20:* = null;
            var _loc_5:* = "";
            var _loc_8:* = new Point(0, 0);
            if (this.vPanel != null)
            {
                layerMenu.removeChild(this.vPanel);
                this.vPanel = null;
            }
            var _loc_14:* = new Point(640, 450);
            _loc_14.y = _loc_14.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            this.vPanel = new SlidePanel();
            _loc_15 = new Sprite();
            var _loc_16:* = new Array();
            _loc_1 = 0;
            while (_loc_1 < Global.vServer.vUser.vChars.length)
            {
                
                if (Global.vServer.vUser.vChars[_loc_1].vPosition == 0)
                {
                    _loc_16.push(Global.vServer.vUser.vChars[_loc_1]);
                }
                _loc_1++;
            }
            _loc_16 = _loc_16.sort(this.sortChars);
            var _loc_17:* = -2;
            var _loc_18:* = 0;
            _loc_18 = 0 + addMarge(_loc_15, 0, _loc_18);
            _loc_3 = new ListTitle();
            _loc_3.txtListTitle.htmlText = "<B>" + Global.getText("txtMyPlayers") + "</B>";
            Global.vLang.checkSans(_loc_3.txtListTitle);
            _loc_3.y = _loc_18 + _loc_3.height / 2;
            _loc_15.addChild(new ButtonGrafBitmap(_loc_3));
            if (Capabilities.isDebugger)
            {
                _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.cancelForm);
            }
            else
            {
                _loc_3.addEventListener(TouchEvent.TOUCH_BEGIN, this.cancelForm);
            }
            _loc_18 = _loc_18 + _loc_3.height;
            _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
            _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
            _loc_1 = 0;
            while (_loc_1 < _loc_16.length)
            {
                
                _loc_17++;
                _loc_2 = new PersoForm(_loc_16[_loc_1], this.onClickForm, true);
                _loc_2.setPanel(this.vPanel);
                _loc_2.x = _loc_17 * 200;
                _loc_2.y = _loc_18;
                _loc_15.addChild(_loc_2);
                if (_loc_17 == 1)
                {
                    _loc_17 = -2;
                    _loc_18 = _loc_18 + 150;
                }
                _loc_1++;
            }
            if (_loc_16.length == 0)
            {
                _loc_19 = new RecruitNoPlayerYet();
                _loc_19.mouseChildren = false;
                _loc_19.mouseEnabled = false;
                _loc_19.txtNoPlayerYet.htmlText = Global.getText("txtNoPlayerYet");
                Global.vLang.checkSans(_loc_19.txtNoPlayerYet);
                Toolz.textReduce(_loc_19.txtNoPlayerYet);
                _loc_19.txtNoPlayerYet.y = _loc_19.txtNoPlayerYet.y - _loc_19.txtNoPlayerYet.textHeight / 2;
                _loc_19.mcBG.gotoAndStop(4);
                _loc_18 = _loc_18 - 70;
                _loc_19.y = _loc_18;
                _loc_18 = _loc_18 - 40;
                _loc_15.addChild(new ButtonGrafBitmap(_loc_19));
                _loc_17 = -1;
            }
            _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
            _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
            if (this.vChars.length == 0)
            {
                _loc_1 = 0;
                while (_loc_1 < 20)
                {
                    
                    _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
                    _loc_1++;
                }
            }
            if (_loc_17 == -2)
            {
                _loc_18 = _loc_18 - 150;
            }
            _loc_17 = -1;
            _loc_1 = 0;
            while (_loc_1 < this.vChars.length)
            {
                
                _loc_4 = this.vChars[_loc_1].vProperties;
                if (_loc_4.Categ == "A" || _loc_4.Categ == "B" || _loc_4.Categ == "C")
                {
                    _loc_6 = new Sparks_Char(Global.vServer.vUser, this.vChars[_loc_1].vShortCode, _loc_4.Name);
                    _loc_6.setForce(_loc_4.Attributes.Force);
                    _loc_6.setSpeed(_loc_4.Attributes.Speed);
                    _loc_6.setVitality(_loc_4.Attributes.Vitality);
                    _loc_6.vCategory = _loc_4.Categ;
                    _loc_6.vCardPrice = _loc_4.Card;
                    _loc_6.vCardNb = _loc_4.Price;
                    if (_loc_6.vCategory != _loc_5)
                    {
                        if (_loc_17 >= 0)
                        {
                            _loc_17 = -1;
                            _loc_18 = _loc_18 + 275;
                        }
                        _loc_5 = _loc_6.vCategory;
                        _loc_3 = new ListTitle();
                        _loc_3.txtListTitle.htmlText = "<B>" + Global.getText("txtPlayerCateg" + _loc_6.vCategory) + "</B>";
                        Global.vLang.checkSans(_loc_3.txtListTitle);
                        _loc_3.y = _loc_18 + _loc_3.height / 2;
                        _loc_15.addChild(new ButtonGrafBitmap(_loc_3));
                        if (Capabilities.isDebugger)
                        {
                            _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.cancelForm);
                        }
                        else
                        {
                            _loc_3.addEventListener(TouchEvent.TOUCH_BEGIN, this.cancelForm);
                        }
                        _loc_11 = new Card("Card", "P" + _loc_6.vCategory);
                        _loc_11.mouseChildren = false;
                        _loc_11.mouseEnabled = false;
                        _loc_15.addChild(_loc_11);
                        addButton(_loc_15, _loc_11, new Point(_loc_3.x - 200, _loc_3.y), this.onClickCardTitle, 0.7, {type:"P" + _loc_6.vCategory}, false);
                        _loc_18 = _loc_18 + _loc_3.height;
                        _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
                    }
                    _loc_7 = new RecruitSlot();
                    _loc_8.x = _loc_17 * 200;
                    _loc_8.y = _loc_18 + _loc_7.height / 2;
                    _loc_17++;
                    if (_loc_17 == 2)
                    {
                        _loc_17 = -1;
                        _loc_18 = _loc_18 + _loc_7.height;
                        _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
                    }
                    _loc_2 = new PersoForm(_loc_6, null, false, 0, true, "", true);
                    _loc_2.x = _loc_7.mcForm.x;
                    _loc_2.y = _loc_7.mcForm.y;
                    _loc_7.addChild(_loc_2);
                    if (_loc_4.XPLevel > Global.vServer.vUser.vLevel)
                    {
                        _loc_13 = false;
                        _loc_7.gotoAndStop("Locked");
                        _loc_10 = Global.getText("txtLevelRequired").replace(/#/, _loc_4.XPLevel);
                        _loc_7.txtInfo.htmlText = "<B>" + _loc_10 + "</B>";
                        Global.vLang.checkSans(_loc_7.txtInfo);
                        Toolz.textReduce(_loc_7.txtInfo);
                    }
                    else
                    {
                        _loc_13 = true;
                        _loc_7.addChild(new CostBar(Global.vServer.vUser.getCards(_loc_6.vCardPrice), _loc_6.vCardNb, _loc_7.mcCost.x, _loc_7.mcCost.y));
                        _loc_12 = new Countdown(null, 60 * _loc_4.Time, false);
                        _loc_12.x = _loc_7.mcTime.x;
                        _loc_12.y = _loc_7.mcTime.y;
                        _loc_7.addChild(_loc_12);
                    }
                    _loc_9 = new ButtonGrafBitmap(_loc_7);
                    _loc_20 = new MovieClip();
                    _loc_20.vChar = _loc_6;
                    _loc_20.vIsAvailable = _loc_13;
                    if (Capabilities.isDebugger)
                    {
                        _loc_20.addEventListener(MouseEvent.CLICK, this.buyChar);
                    }
                    else
                    {
                        _loc_20.addEventListener(TouchEvent.TOUCH_TAP, this.buyChar);
                    }
                    _loc_20.addChild(_loc_9);
                    _loc_20.x = _loc_8.x;
                    _loc_20.y = _loc_8.y;
                    _loc_15.addChild(_loc_20);
                }
                _loc_1++;
            }
            if (_loc_17 >= 0)
            {
                _loc_18 = _loc_18 + _loc_7.height / 2;
            }
            _loc_18 = _loc_18 + addMarge(_loc_15, 0, _loc_18);
            this.vPanel.init(_loc_15, _loc_14);
            this.vPanel.x = 0;
            this.vPanel.y = 125;
            layerMenu.addChild(this.vPanel);
            this.vPanel.forceX(Global.vSize.x / 2);
            return;
        }// end function

        private function sortChars(param1:Sparks_Char, param2:Sparks_Char) : int
        {
            if (param1.getForce() + param1.getSpeed() + param1.getVitality() > param2.getForce() + param2.getSpeed() + param2.getVitality())
            {
                return -1;
            }
            if (param1.getForce() + param1.getSpeed() + param1.getVitality() < param2.getForce() + param2.getSpeed() + param2.getVitality())
            {
                return 1;
            }
            if (param1.vName < param2.vName)
            {
                return -1;
            }
            if (param1.vName > param2.vName)
            {
                return 1;
            }
            return 0;
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

        private function buyChar(event:Event) : void
        {
            var _loc_2:* = null;
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            if (!event.currentTarget.vIsAvailable)
            {
                return;
            }
            if (this.vCurForm != null)
            {
                this.cancelForm();
                return;
            }
            var _loc_3:* = event.currentTarget.vChar;
            this.vCurCode = _loc_3.vCharId;
            this.vCurPseudo = _loc_3.vName;
            Global.vSound.onButton();
            var _loc_4:* = Global.vServer.vUser.getCards(_loc_3.vCardPrice) - _loc_3.vCardNb;
            if (Global.vServer.vUser.getCards(_loc_3.vCardPrice) - _loc_3.vCardNb < 0)
            {
                this.vPanel.vPause = true;
                showNotEnoughCards(-_loc_4, this.restartPanel);
                return;
            }
            _loc_2 = Global.getText("txtBuyConfirmCard");
            _loc_2 = _loc_2.replace(/#/, _loc_3.vCardNb);
            _loc_2 = _loc_2.replace(/µ/, Global.getText("txtCard" + _loc_3.vCardPrice));
            this.vPanel.vPause = true;
            var _loc_5:* = MsgBox.getPerso(_loc_3.vCharId, Global.vServer.vUser.vCurShirt);
            new MsgBox(this, _loc_2, this.buyConfirm, MsgBox.TYPE_AskBeforeBuy, {charId:_loc_3.vCharId, graf:_loc_5, subtext:_loc_3.vName});
            return;
        }// end function

        private function restartPanel() : void
        {
            this.vPanel.vPause = false;
            return;
        }// end function

        public function buyConfirm(param1:Boolean, param2:Object) : void
        {
            this.vPanel.vPause = false;
            if (param1)
            {
                Global.vServer.recruitChar(this.afterRecruit, param2.charId);
            }
            return;
        }// end function

        private function afterRecruit() : void
        {
            TeamManager.vLastRecruitCode = this.vCurCode;
            TeamManager.vLastRecruitPseudo = this.vCurPseudo;
            Global.vRoot.launchMenu(TeamManager);
            return;
        }// end function

        private function showNewRecruit() : void
        {
            var _loc_1:* = Global.getText("txtNewChar").replace(/#/, vLastRecruitPseudo);
            new MsgBox(this, _loc_1, null, MsgBox.TYPE_NewChar, {charId:vLastRecruitCode});
            vLastRecruitCode = "";
            return;
        }// end function

        private function putAtPosition(param1:PersoForm, param2:int, param3:Number = 0.3) : void
        {
            var _loc_4:* = new Point(this.vTeamBG.x, this.vTeamBG.y);
            if (param2 == 1)
            {
                _loc_4.y = _loc_4.y - 130;
            }
            else if (param2 == 2)
            {
                _loc_4.x = _loc_4.x - 158;
            }
            else if (param2 == 3)
            {
                _loc_4.x = _loc_4.x + 158;
            }
            _loc_4.y = _loc_4.y + 60;
            TweenMax.to(param1, param3, {x:_loc_4.x, y:_loc_4.y});
            this.vFormInPosition.push(param1);
            Global.vTopBar.refreshTeamIcon();
            return;
        }// end function

        private function sortCards(param1:Object, param2:Object) : int
        {
            if (param1.type < param2.type)
            {
                return -1;
            }
            if (param1.type > param2.type)
            {
                return 1;
            }
            return 0;
        }// end function

        private function goBack() : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function blinkPositions(param1:int) : void
        {
            this.vBlinkRunning = true;
            this.blinkPositionOff();
            return;
        }// end function

        private function blinkPositionOff() : void
        {
            if (!stage)
            {
                return;
            }
            if (!this.vBlinkRunning)
            {
                return;
            }
            var _loc_1:* = 0.3;
            var _loc_2:* = 0;
            while (_loc_2 < this.vFormInPosition.length)
            {
                
                TweenMax.to(this.vFormInPosition[_loc_2], _loc_1, {alpha:0.3, ease:Quad.easeIn});
                _loc_2++;
            }
            TweenMax.delayedCall(_loc_1, this.blinkPositionOn);
            return;
        }// end function

        private function blinkPositionOn(param1:Boolean = true) : void
        {
            if (!stage)
            {
                return;
            }
            if (!this.vBlinkRunning)
            {
                return;
            }
            var _loc_2:* = 0.3;
            var _loc_3:* = 0;
            while (_loc_3 < this.vFormInPosition.length)
            {
                
                TweenMax.to(this.vFormInPosition[_loc_3], _loc_2, {alpha:1, ease:Quad.easeIn});
                _loc_3++;
            }
            if (!param1)
            {
                this.vBlinkRunning = false;
                return;
            }
            if (this.vCurForm != null)
            {
                TweenMax.delayedCall(_loc_2, this.blinkPositionOff);
            }
            return;
        }// end function

        private function cancelForm(event:Event = null) : void
        {
            this.vPanel.vPause = false;
            if (this.vCurForm != null)
            {
                if (this.vCurForm.vCountdown != null)
                {
                    this.vCurForm.vCountdown.visible = true;
                }
                this.vCurForm = null;
            }
            this.blinkPositionOn(false);
            if (this.vFormOver != null)
            {
                layerMenu.removeChild(this.vFormOver);
                this.vFormOver = null;
            }
            return;
        }// end function

        private function onClickForm(param1:PersoForm) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_10:* = 0;
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            Global.vSound.onButton();
            if (this.vCurForm != null)
            {
                if (param1.vChar.vPosition > 0)
                {
                    if (param1.vChar.vPosition != this.vCurForm.vChar.vPosition)
                    {
                        this.modifyPosition(param1.vChar.vPosition);
                    }
                }
                this.cancelForm();
                return;
            }
            if (param1.vChar.vStatus == "recruit" || param1.vChar.vStatus == "training" || param1.vChar.vStatus == "injury")
            {
                if (param1.vCountdown != null)
                {
                    param1.vCountdown.askSpeedUp();
                    return;
                }
            }
            this.vPanel.vPause = true;
            this.vCurForm = param1;
            var _loc_2:* = new Point(param1.x, param1.y);
            if (param1.vChar.vPosition == 0)
            {
                if (this.vPanel.vContent.y + param1.y < 64)
                {
                    this.vPanel.vContent.y = 64 - param1.y;
                }
                _loc_10 = 340 - 90;
                if (this.vPanel.vContent.y + param1.y > _loc_10 + 2 * Global.vScreenDelta.y / Global.vResolution)
                {
                    this.vPanel.vContent.y = _loc_10 + 2 * Global.vScreenDelta.y / Global.vResolution - param1.y;
                }
            }
            _loc_2 = param1.parent.localToGlobal(_loc_2);
            _loc_2 = layerMenu.globalToLocal(_loc_2);
            this.vFormOver = new PersoFormOverGraf();
            this.vFormOver.x = _loc_2.x;
            this.vFormOver.y = _loc_2.y;
            layerMenu.addChild(this.vFormOver);
            if (Capabilities.isDebugger)
            {
                this.vFormOver.addEventListener(MouseEvent.MOUSE_DOWN, this.cancelForm);
            }
            else
            {
                this.vFormOver.addEventListener(TouchEvent.TOUCH_BEGIN, this.cancelForm);
            }
            this.blinkPositions(this.vCurForm.vChar.vPosition);
            var _loc_5:* = false;
            if (this.vCurForm.vChar.isActive())
            {
                if (this.vCurForm.vChar.canUpgrade())
                {
                    _loc_5 = true;
                }
            }
            if (Global.vServer.vUser.vLevel < 3)
            {
                _loc_5 = false;
            }
            _loc_3 = Global.getText("txtCharUpgrade");
            if (_loc_5)
            {
                _loc_4 = new ButtonTextBitmap(Menu_TextButtonBigGreen, _loc_3);
            }
            else
            {
                _loc_4 = new ButtonTextBitmap(Menu_TextButtonBigGrey, _loc_3);
            }
            _loc_2.x = this.vFormOver.mcButtonUpgrade.x;
            _loc_2.y = this.vFormOver.mcButtonUpgrade.y;
            addButton(this.vFormOver, _loc_4, _loc_2, this.goDetails);
            _loc_3 = Global.getText("txtCharRecuperation");
            if (this.vCurForm.vChar.getEnergy() < 100 && Global.vServer.vUser.getEnergyCards().length > 0)
            {
                _loc_4 = new ButtonTextBitmap(Menu_TextButtonBigRed, _loc_3);
            }
            else
            {
                _loc_4 = new ButtonTextBitmap(Menu_TextButtonBigGrey, _loc_3);
            }
            _loc_2.x = this.vFormOver.mcButtonRecuperation.x;
            _loc_2.y = this.vFormOver.mcButtonRecuperation.y;
            addButton(this.vFormOver, _loc_4, _loc_2, this.goRecuperation);
            var _loc_9:* = new PersoForm(this.vCurForm.vChar);
            _loc_9.setMore(false);
            _loc_9.setMoreRecuperation(false);
            this.vFormOver.addChild(_loc_9);
            if (_loc_9.vCountdown != null)
            {
                _loc_9.vCountdown.visible = false;
            }
            if (this.vCurForm.vCountdown != null)
            {
                this.vCurForm.vCountdown.visible = false;
            }
            return;
        }// end function

        private function doSwap1(event:Event) : void
        {
            this.doSwap(2, 3);
            return;
        }// end function

        private function doSwap2(event:Event) : void
        {
            this.doSwap(1, 2);
            return;
        }// end function

        private function doSwap3(event:Event) : void
        {
            this.doSwap(1, 3);
            return;
        }// end function

        private function doSwap(param1:int, param2:int) : void
        {
            if (this.vCurForm != null)
            {
                this.cancelForm();
                return;
            }
            this.vWaitingGraf = new Waiting();
            layerMenu.addChild(this.vWaitingGraf);
            var _loc_3:* = Global.vServer.vUser.getCharAtPosition(param1);
            var _loc_4:* = Global.vServer.vUser.getCharAtPosition(param2);
            var _loc_5:* = this;
            var _loc_6:* = this.vWaiting + 1;
            _loc_5.vWaiting = _loc_6;
            Global.vServer.swapPosition(this.onPositionSet, _loc_3, _loc_4);
            return;
        }// end function

        private function modifyPosition(param1:int) : void
        {
            if (this.vCurForm == null)
            {
                return;
            }
            if (this.vCurForm.vChar.vPosition == param1)
            {
                return;
            }
            this.vWaitingGraf = new Waiting();
            layerMenu.addChild(this.vWaitingGraf);
            var _loc_2:* = Global.vServer.vUser.getCharAtPosition(param1);
            var _loc_3:* = this;
            var _loc_4:* = this.vWaiting + 1;
            _loc_3.vWaiting = _loc_4;
            Global.vServer.swapPosition(this.onPositionSet, this.vCurForm.vChar, _loc_2);
            Global.vSound.onSlide();
            return;
        }// end function

        private function onPositionSet() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = this;
            var _loc_4:* = this.vWaiting - 1;
            _loc_3.vWaiting = _loc_4;
            if (this.vWaiting > 0)
            {
                return;
            }
            this.vWaiting = 0;
            while (this.vFormInPosition.length > 0)
            {
                
                layerMenu.removeChild(this.vFormInPosition[0]);
                this.vFormInPosition.splice(0, 1);
            }
            var _loc_2:* = 1;
            while (_loc_2 <= 3)
            {
                
                _loc_1 = new PersoForm(Global.vServer.vUser.getCharAtPosition(_loc_2), this.onClickForm);
                layerMenu.addChild(_loc_1);
                this.putAtPosition(_loc_1, _loc_2, 0);
                _loc_2++;
            }
            this.refreshList();
            if (this.vWaitingGraf != null)
            {
                layerMenu.removeChild(this.vWaitingGraf);
                this.vWaitingGraf = null;
            }
            return;
        }// end function

        private function goDetails(event:Event = null) : void
        {
            var _loc_3:* = null;
            if (this.vCurForm == null)
            {
                return;
            }
            Global.vSound.onButton();
            if (Global.vServer.vUser.vLevel < 3)
            {
                _loc_3 = new LevelXPGraf();
                _loc_3.gotoAndStop("StarOnly");
                _loc_3.txtLevel.htmlText = "<B>" + Global.vServer.vUser.vLevel.toString() + "</B>";
                var _loc_4:* = 2;
                _loc_3.scaleY = 2;
                _loc_3.scaleX = _loc_4;
                new MsgBox(this, Global.getText("txtUpgradeNeedLevel3"), null, MsgBox.TYPE_TextWithGraf, {graf:_loc_3});
                this.cancelForm();
                return;
            }
            var _loc_2:* = new Point(0, 0);
            _loc_2 = this.vCurForm.localToGlobal(_loc_2);
            _loc_2.x = _loc_2.x - Global.vScreenDelta.x;
            _loc_2.y = _loc_2.y - Global.vScreenDelta.y;
            _loc_2.x = _loc_2.x / Global.vResolution;
            _loc_2.y = _loc_2.y / Global.vResolution;
            UpgradeChar.vChar = this.vCurForm.vChar;
            UpgradeChar.vTeamManager = this;
            Global.vRoot.launchPopup(UpgradeChar, _loc_2, this.onPopupClosed);
            this.cancelForm();
            this.vPanel.vPause = true;
            return;
        }// end function

        private function goRecuperation(event:Event = null) : void
        {
            if (this.vCurForm == null)
            {
                return;
            }
            Global.vSound.onButton();
            if (this.vCurForm.vChar.getEnergy() == 100)
            {
                new MsgBox(this, Global.getText("txtCharEnergyMax"));
                return;
            }
            var _loc_2:* = new Point(0, 0);
            _loc_2 = this.vCurForm.localToGlobal(_loc_2);
            _loc_2.x = _loc_2.x - Global.vScreenDelta.x;
            _loc_2.y = _loc_2.y - Global.vScreenDelta.y;
            _loc_2.x = _loc_2.x / Global.vResolution;
            _loc_2.y = _loc_2.y / Global.vResolution;
            this.vRecuperationForm = this.vCurForm;
            new MsgBox(this, "", this.onCardEnergy, MsgBox.TYPE_Recuperation, {vChar:this.vCurForm.vChar});
            this.cancelForm();
            this.vPanel.vPause = true;
            return;
        }// end function

        private function onCardEnergy(param1:Object = null) : void
        {
            if (param1 != null)
            {
                if (param1.card != null)
                {
                    Global.vServer.charRecover(this.afterRecover, param1.charId, param1.card);
                    this.onPopupClosed();
                }
            }
            this.onPopupClosed();
            return;
        }// end function

        private function afterRecover(param1:String) : void
        {
            Global.vSound.onGift();
            var _loc_2:* = new Point(this.vRecuperationForm.x, this.vRecuperationForm.y);
            Global.startParticles(this.vRecuperationForm.parent, _loc_2, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            this.vRecuperationForm.refresh();
            this.refreshTeamPreview();
            return;
        }// end function

        private function onPopupClosed(param1:Object = null) : void
        {
            if (this.vPanel != null)
            {
                this.vPanel.vPause = false;
            }
            return;
        }// end function

    }
}
