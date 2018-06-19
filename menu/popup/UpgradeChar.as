package menu.popup
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class UpgradeChar extends MenuXXX
    {
        public var vCanUpgrade:Boolean;
        public var vUpgradePrice:int;
        public var vUpgradeTime:int;
        private var vScreen:UpgradeCharScreen;
        private var vWaitingGraf:Waiting;
        private var vTrainingAttribute:String;
        private var vCallRunning:Boolean = false;
        public static var vChar:Sparks_Char;
        public static var vTeamManager:TeamManager;

        public function UpgradeChar()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            initMenu();
            this.showMenu();
            Global.vSound.onSlide();
            Global.vStats.Stats_PageView("UpgradeChar");
            return;
        }// end function

        private function goTeamManager(event:Event = null) : void
        {
            Global.vRoot.launchMenu(TeamManager);
            return;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_18:* = false;
            var _loc_19:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = NaN;
            var _loc_23:* = 0;
            var _loc_24:* = false;
            var _loc_25:* = null;
            this.cleanWaiting();
            cleanMenu();
            if (vTeamManager != null)
            {
                vTeamManager.refreshAll();
            }
            var _loc_2:* = vChar.vNbUpgrades;
            this.vCanUpgrade = false;
            if (_loc_2 < 10)
            {
                this.vCanUpgrade = true;
                if (vChar.vCategory == "B")
                {
                    _loc_2 = _loc_2 + 2;
                }
                else if (vChar.vCategory == "C")
                {
                    _loc_2 = _loc_2 + 4;
                }
                this.vUpgradeTime = 60 * Global.vServer.vUpgradeTimes[_loc_2];
                _loc_21 = vChar.getForce() + vChar.getSpeed() + vChar.getVitality();
                _loc_2 = 0;
                this.vUpgradePrice = Global.vServer.vUpgradePrices[_loc_2 + _loc_21];
            }
            this.vScreen = new UpgradeCharScreen();
            layerMenu.addChild(this.vScreen);
            var _loc_3:* = Global.getText("txtStageTitle");
            _loc_3 = _loc_3.replace(/#/, vChar.vNbUpgrades.toString() + "/10");
            this.vScreen.txtUgrade.htmlText = "<B>" + _loc_3 + "</B>";
            Global.vLang.checkSans(this.vScreen.txtUgrade);
            Toolz.textReduce(this.vScreen.txtUgrade);
            var _loc_4:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(this.vScreen, _loc_4, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            var _loc_5:* = new ButtonGrafBitmap(new MenuButton_Sell());
            addButton(this.vScreen, _loc_5, new Point(this.vScreen.mcSell.x, this.vScreen.mcSell.y), this.goSell, 1);
            var _loc_6:* = new ButtonGrafBitmap(new MenuButton_Help());
            addButton(this.vScreen, _loc_6, new Point(this.vScreen.mcHelp.x, this.vScreen.mcHelp.y), this.goHelp, 1);
            if (vChar.vStatus == "" || vChar.vStatus == "active")
            {
                this.vScreen.gotoAndStop(1);
            }
            else
            {
                this.vScreen.gotoAndStop(2);
            }
            if (vChar.vStatus == "training")
            {
                this.vScreen.mcStatus.gotoAndStop(vChar.vJob.Attribute);
            }
            else
            {
                this.vScreen.mcStatus.gotoAndStop(vChar.vStatus);
            }
            this.vScreen.mcBG.gotoAndStop(vChar.vCategory);
            var _loc_7:* = new PersoGrafMain();
            _loc_7.init();
            _loc_7.setHead(vChar.vCharId, Global.vSWFImages, Global.vSWFLoader);
            var _loc_26:* = 4.5;
            _loc_7.scaleY = 4.5;
            _loc_7.scaleX = _loc_26;
            _loc_7.x = this.vScreen.mcPuppet.x;
            _loc_7.y = this.vScreen.mcPuppet.y;
            this.vScreen.addChild(_loc_7);
            this.vScreen.txtName.htmlText = "<B>" + vChar.vName + "</B>";
            if (vChar.isActive())
            {
                this.vScreen.txtCurrentStatus.text = "";
                if (vChar.vNbUpgrades == 10)
                {
                    this.vScreen.txtNoMoreUpgrade.htmlText = "<B>" + Global.getText("txtUpgradeNoMore") + "</B>";
                    Global.vLang.checkSans(this.vScreen.txtNoMoreUpgrade);
                    this.vScreen.txtNextTimer.text = "";
                }
                else
                {
                    this.vScreen.txtNoMoreUpgrade.text = "";
                    this.vScreen.txtNextTimer.htmlText = "<B>" + Global.getText("txtUpgradeDuration") + "</B>";
                    Global.vLang.checkSans(this.vScreen.txtNextTimer);
                    _loc_22 = this.vScreen.txtNextTimer.textWidth;
                    this.vScreen.mcDuration.x = this.vScreen.txtNextTimer.x + _loc_22 + 64;
                    _loc_13 = new Countdown(null, this.vUpgradeTime, false);
                    _loc_13.x = this.vScreen.mcDuration.x;
                    _loc_13.y = this.vScreen.mcDuration.y;
                    this.vScreen.addChild(_loc_13);
                }
            }
            else
            {
                this.vScreen.txtNoMoreUpgrade.text = "";
                this.vScreen.txtNextTimer.text = "";
                if (vChar.vStatus == "injury")
                {
                    this.vScreen.txtCurrentStatus.htmlText = "<b>" + Global.getText("txtStatusInjured") + "</b>";
                }
                else if (vChar.vStatus == "recruit")
                {
                    this.vScreen.txtCurrentStatus.htmlText = "<b>" + Global.getText("txtStatusRecruit") + "</b>";
                }
                else if (vChar.vStatus == "training")
                {
                    this.vScreen.txtCurrentStatus.htmlText = "<b>" + Global.getText("txtStatusTraining").replace(/#/, Global.getText("txtAttribute" + vChar.vJob.Attribute)) + "</b>";
                }
                Global.vLang.checkSans(this.vScreen.txtCurrentStatus);
                _loc_17 = Global.vServer.getTimeLeft(vChar.vJob.Started, vChar.vJob.Duration);
                _loc_13 = new Countdown(this.onCountDownDone, _loc_17, true, vChar, null, this.showWaiting);
                _loc_13.setCallbackOnFinished(this.onCountDownDone);
                _loc_13.x = this.vScreen.mcCountdown.x;
                _loc_13.y = this.vScreen.mcCountdown.y;
                this.vScreen.addChild(_loc_13);
            }
            var _loc_20:* = 1;
            while (_loc_20 <= 3)
            {
                
                _loc_14 = this.vScreen["mcAttribute" + _loc_20];
                _loc_14.txtTitleCard.htmlText = "";
                _loc_14.txtMaximum.htmlText = "";
                if (_loc_20 == 1)
                {
                    _loc_8 = Global.getText("txtAttributeForce");
                }
                else if (_loc_20 == 2)
                {
                    _loc_8 = Global.getText("txtAttributeSpeed");
                }
                else if (_loc_20 == 3)
                {
                    _loc_8 = Global.getText("txtAttributeVitality");
                }
                if (_loc_20 == 1)
                {
                    _loc_23 = vChar.getForce();
                }
                else if (_loc_20 == 2)
                {
                    _loc_23 = vChar.getSpeed();
                }
                else if (_loc_20 == 3)
                {
                    _loc_23 = vChar.getVitality();
                }
                _loc_14.mcBar.gotoAndStop((_loc_23 + 1));
                _loc_14.txtAdd.htmlText = "<B>+" + _loc_23 + "</B>";
                if (_loc_20 == 1)
                {
                    _loc_9 = "AF";
                }
                else if (_loc_20 == 2)
                {
                    _loc_9 = "AS";
                }
                else if (_loc_20 == 3)
                {
                    _loc_9 = "AV";
                }
                if (vChar.isActive())
                {
                    _loc_18 = true;
                    if (_loc_20 == 1)
                    {
                        _loc_14.txtTitleCard.htmlText = "<b>" + Global.getText("txtAttributeForce") + "</b>";
                    }
                    if (_loc_20 == 2)
                    {
                        _loc_14.txtTitleCard.htmlText = "<b>" + Global.getText("txtAttributeSpeed") + "</b>";
                    }
                    if (_loc_20 == 3)
                    {
                        _loc_14.txtTitleCard.htmlText = "<b>" + Global.getText("txtAttributeVitality") + "</b>";
                    }
                    Global.vLang.checkSans(_loc_14.txtTitleCard);
                    Toolz.textReduce(_loc_14.txtTitleCard);
                    _loc_19 = Global.vServer.vUser.getCards(_loc_9);
                    if (vChar.vNbUpgrades == 10)
                    {
                        _loc_14.txtTitleCard.htmlText = "";
                        _loc_18 = false;
                    }
                    else if (this.vUpgradePrice <= _loc_19)
                    {
                        _loc_24 = false;
                        if (_loc_20 == 1 && vChar.getForce() == 10)
                        {
                            _loc_24 = true;
                        }
                        if (_loc_20 == 2 && vChar.getSpeed() == 10)
                        {
                            _loc_24 = true;
                        }
                        if (_loc_20 == 3 && vChar.getVitality() == 10)
                        {
                            _loc_24 = true;
                        }
                        if (_loc_24)
                        {
                            _loc_14.txtMaximum.htmlText = Global.getText("txtMaximumReached");
                            Global.vLang.checkSans(_loc_14.txtMaximum);
                            Toolz.textReduce(_loc_14.txtMaximum);
                            _loc_18 = false;
                        }
                        else
                        {
                            _loc_14.vCanBuy = true;
                        }
                    }
                    else
                    {
                        _loc_14.vCanBuy = false;
                    }
                    if (_loc_18)
                    {
                        _loc_10 = new Card("Card", _loc_9);
                        _loc_10.x = _loc_14.mcCard.x;
                        _loc_10.y = _loc_14.mcCard.y;
                        _loc_14.addChild(_loc_10);
                        _loc_14.addChild(new CostBar(_loc_19, this.vUpgradePrice, _loc_14.mcCost.x, _loc_14.mcCost.y));
                        if (_loc_14.vCanBuy)
                        {
                            _loc_25 = new Button_Go();
                            _loc_25.mcGo.txLabel.htmlText = "<B>" + Global.getText("txtButtonGo") + "</B>";
                            Global.vLang.checkSans(_loc_25.mcGo.txLabel);
                            _loc_12 = new ButtonGrafBitmap(_loc_25);
                            _loc_11 = addButton(_loc_14, _loc_12, new Point(_loc_14.mcButton.x, _loc_14.mcButton.y), this.startTraining);
                            _loc_11.vAttribute = _loc_20;
                            _loc_11.vCanBuy = _loc_14.vCanBuy;
                            _loc_11.vCardType = _loc_9;
                        }
                    }
                    _loc_14.mcButton.visible = false;
                }
                _loc_20++;
            }
            return;
        }// end function

        private function cleanWaiting() : void
        {
            if (this.vWaitingGraf != null)
            {
                if (this.vWaitingGraf.parent != null)
                {
                    this.vWaitingGraf.parent.removeChild(this.vWaitingGraf);
                }
                this.vWaitingGraf = null;
            }
            return;
        }// end function

        private function showWaiting() : void
        {
            this.cleanWaiting();
            this.vWaitingGraf = new Waiting();
            layerMenu.addChild(this.vWaitingGraf);
            return;
        }// end function

        private function onCountDownDone() : void
        {
            vChar.finishCurJob();
            this.showMenu();
            if (vTeamManager != null)
            {
                vTeamManager.refreshAll();
            }
            var _loc_1:* = new Point(Global.vSize.x / 2, Global.vSize.y * 0.65);
            Global.startParticles(this, _loc_1, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            return;
        }// end function

        private function startTraining(event:Event) : void
        {
            var _loc_7:* = null;
            var _loc_8:* = 0;
            if (this.vCallRunning)
            {
                return;
            }
            Global.vSound.onButton();
            if (Global.vServer.vUser.vLevel < 3)
            {
                _loc_7 = new LevelXPGraf();
                _loc_7.gotoAndStop("StarOnly");
                _loc_7.txtLevel.htmlText = "<B>" + Global.vServer.vUser.vLevel.toString() + "</B>";
                var _loc_9:* = 2;
                _loc_7.scaleY = 2;
                _loc_7.scaleX = _loc_9;
                new MsgBox(this, Global.getText("txtUpgradeNeedLevel3"), null, MsgBox.TYPE_TextWithGraf, {graf:_loc_7});
                return;
            }
            if (event.currentTarget.vCanBuy != true)
            {
                _loc_8 = this.vUpgradePrice - Global.vServer.vUser.getCards(event.currentTarget.vCardType);
                showNotEnoughCards(_loc_8);
                return;
            }
            if (event.currentTarget.vAttribute == 1)
            {
                this.vTrainingAttribute = "Force";
            }
            else if (event.currentTarget.vAttribute == 2)
            {
                this.vTrainingAttribute = "Speed";
            }
            else if (event.currentTarget.vAttribute == 3)
            {
                this.vTrainingAttribute = "Vitality";
            }
            else
            {
                return;
            }
            var _loc_2:* = Global.getText("txtUpgradeConfirm");
            _loc_2 = _loc_2.replace(/#1/, this.vUpgradePrice);
            var _loc_3:* = event.currentTarget.vCardType;
            _loc_2 = _loc_2.replace(/#2/, Global.getText("txtCard" + _loc_3));
            _loc_2 = _loc_2.replace(/#3/, vChar.vName);
            _loc_2 = _loc_2.replace(/#4/, Global.getText("txtAttribute" + this.vTrainingAttribute));
            var _loc_4:* = 0;
            var _loc_5:* = 1;
            if (event.currentTarget.vAttribute == 1)
            {
                _loc_4 = vChar.getForce();
                _loc_5 = 1;
            }
            else if (event.currentTarget.vAttribute == 2)
            {
                _loc_4 = vChar.getSpeed();
                _loc_5 = 2;
            }
            else if (event.currentTarget.vAttribute == 3)
            {
                _loc_4 = vChar.getVitality();
                _loc_5 = 3;
            }
            var _loc_6:* = new PersoFormGrafStatus();
            _loc_6.gotoAndStop(this.vTrainingAttribute);
            var _loc_9:* = 2.5;
            _loc_6.scaleY = 2.5;
            _loc_6.scaleX = _loc_9;
            new MsgBox(this, _loc_2, this.starTrainingConfirm, MsgBox.TYPE_AskTraining, {charId:vChar.vCharId, graf:_loc_6, valueFrom:_loc_4, frameTextUpgrade:_loc_5});
            return;
        }// end function

        private function starTrainingConfirm(param1:Boolean, param2:Object = null) : void
        {
            if (param1)
            {
                this.showWaiting();
                this.vCallRunning = true;
                Global.vServer.startUpgrade(this.onTrainingStarted, vChar.vCharId, this.vTrainingAttribute);
            }
            return;
        }// end function

        private function onTrainingStarted() : void
        {
            this.cleanWaiting();
            vChar = Global.vServer.vUser.getChar(vChar.vCharId);
            if (vTeamManager != null)
            {
                vTeamManager.refreshAll();
            }
            Global.vRoot.quitPopup();
            this.vCallRunning = false;
            return;
        }// end function

        private function goQuit(event:Event = null) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

        private function goHelp(event:Event) : void
        {
            Global.vSound.onButton();
            Global.vRoot.launchPopup(HelpChar);
            return;
        }// end function

        private function goSell(event:Event) : void
        {
            Global.vSound.onButton();
            if (vChar.vPosition > 0)
            {
                new MsgBox(this, Global.getText("txtSellOnlySubstitute"));
                return;
            }
            Global.vServer.getCharSellPrice(this.onCharSellPrice, vChar.vCharId);
            return;
        }// end function

        private function onCharSellPrice(param1:int) : void
        {
            new MsgBox(this, "", this.onSellConfirm, MsgBox.TYPE_Sell, {charId:vChar.vCharId, price:param1});
            return;
        }// end function

        private function onSellConfirm(param1:Boolean, param2:Object) : void
        {
            if (param1)
            {
                Global.vServer.doCharSell(this.onCharSellResult, vChar.vCharId);
            }
            return;
        }// end function

        private function onCharSellResult(param1:int) : void
        {
            Global.vTopBar.onGoldAdded(param1 - Global.vServer.vUser.vHardCurrency);
            Global.vServer.vUser.removeChar(vChar.vCharId);
            if (vTeamManager != null)
            {
                vTeamManager.refreshAll();
            }
            this.goQuit();
            return;
        }// end function

    }
}
