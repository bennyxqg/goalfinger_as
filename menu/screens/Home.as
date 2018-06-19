package menu.screens
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import menu.popup.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class Home extends MenuXXX
    {
        private var vBGCallback:Function;
        private var vBGSprite:Sprite;
        private var vRegCardSprite:Sprite;
        private var vPromoPack:Sprite;
        private var vStartButton:ButtonPlayMeta;
        private var vGetRegCardDone:Boolean = false;
        private var vHistoryButton:MovieClip;
        private var vConsecutiveWinsButton:MovieClip;
        private var vGeneralMessageButton:MovieClip;
        private var vGeneralMessagePastille:ButtonGrafBitmap;
        private var vTips:Array;
        private var vCurTip:Sprite;
        private var vCurTipForced:Boolean = false;
        private var vNbTips:int = 31;
        public static var vAccountFirstTime:Boolean = false;
        public static var vTrophyPos:Point;
        public static var vTrophyRank:TextField;
        public static var vTrophyMax:TextField;
        public static var vShowPromoPack:Boolean = true;

        public function Home()
        {
            this.vTips = new Array();
            vTag = "Home";
            Global.vRoot.vKillOnDeactivate = true;
            Matchmaking.vPrivatePass = "";
            GBL_Resolution.vSpeedCoef = 1;
            return;
        }// end function

        private function showBG(param1:Function) : void
        {
            this.vBGCallback = param1;
            this.vBGSprite = new Sprite();
            this.vBGSprite.x = Global.vSize.x / 2;
            this.vBGSprite.y = Global.vSize.y / 2;
            addChild(this.vBGSprite);
            Global.vServer.loadBG(this.onBGReady);
            return;
        }// end function

        private function onBGReady(param1:BitmapData) : void
        {
            var _loc_2:* = null;
            if (param1 == null)
            {
                _loc_2 = new BG_Textured();
                _loc_2.x = Global.vSize.x / 2;
                _loc_2.y = Global.vSize.y / 2;
                addChild(_loc_2);
            }
            else
            {
                this.vBGSprite.graphics.beginBitmapFill(param1, null, true);
                this.vBGSprite.graphics.drawRect(-Global.vSize.x, -Global.vSize.y, 2 * Global.vSize.x, 2 * Global.vSize.y);
                this.vBGSprite.graphics.endFill();
            }
            this.vBGCallback.call();
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            if (stage == null)
            {
                return;
            }
            if (Global.vWeatherSave != null)
            {
                Global.vWeather = Global.vWeatherSave.globalType;
                GBL_Main.vWeatherCoef = Global.vWeatherSave.gblValue;
                Global.vWeatherSave = null;
            }
            this.showBG(this.initHome);
            return;
        }// end function

        private function initHome() : void
        {
            if (Global.vTopBar == null)
            {
                Global.vTopBar = new TopBar();
            }
            else
            {
                Global.vTopBar.appear();
            }
            Global.vTopBar.refresh();
            if (Global.vMatchRunning != "0")
            {
                Global.vMatchRunning = "0";
                Global.vTopBar.hide(true);
                Matchmaking.vHideAtStart = true;
                Global.vRoot.launchMenu(Matchmaking);
                return;
            }
            Global.vSound.stopAroundGame();
            Global.vSound.stopGameLoop();
            if (Global.vGame != null)
            {
                Global.vGame.destroy();
                Global.vGame = null;
            }
            PlayOnline.showMessageTrainingDone = false;
            initMenu();
            Global.vRoot.removeLoading();
            this.showMenu();
            Global.vSound.stopGameLoop();
            Global.vStats.Stats_PageView("Home");
            return;
        }// end function

        private function showMenu() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = null;
            var _loc_18:* = undefined;
            Global.vTopBar.vTransitionRunning = false;
            Global.vTopBar.refresh();
            Global.vTopBar.setTab(3);
            while (layerMenu.numChildren > 0)
            {
                
                layerMenu.removeChildAt(0);
            }
            this.vConsecutiveWinsButton = null;
            if (Global.vDev)
            {
                _loc_2 = new DevGraf();
                _loc_2.txtLabel.htmlText = "<b>Global.vDev</b>";
                Toolz.textReduce(_loc_2.txtLabel);
                _loc_2.x = -220;
                _loc_2.y = -300;
                layerMenu.addChild(new ButtonGrafBitmap(_loc_2));
            }
            if (Global.vServerPreview && Global.vServerPreviewFlag)
            {
                _loc_2 = new DevGraf();
                _loc_2.txtLabel.htmlText = "<b>Server preview</b>";
                Toolz.textReduce(_loc_2.txtLabel);
                _loc_2.x = -220;
                _loc_2.y = -220;
                layerMenu.addChild(new ButtonGrafBitmap(_loc_2));
            }
            _loc_7 = NativeApplication.nativeApplication.applicationDescriptor;
            _loc_8 = _loc_7.namespace();
            _loc_9 = _loc_8::id[0];
            if (_loc_9 == "com.globz.goalfingerdev")
            {
                _loc_2 = new DevGraf();
                _loc_2.txtLabel.htmlText = "<b>Bundle id DEV</b>";
                Toolz.textReduce(_loc_2.txtLabel);
                _loc_2.x = -220;
                _loc_2.y = -140;
                layerMenu.addChild(new ButtonGrafBitmap(_loc_2));
            }
            if (Global.vGlobzPing)
            {
                _loc_2 = new DevGraf();
                _loc_2.txtLabel.htmlText = "<b>Globz Ping</b>";
                Toolz.textReduce(_loc_2.txtLabel);
                _loc_2.x = 0;
                _loc_2.y = -100;
                layerMenu.addChild(new ButtonGrafBitmap(_loc_2));
            }
            var _loc_3:* = new ProfileGraf();
            _loc_3.txtName.text = Global.vServer.vDisplayName;
            _loc_3.txtRank.text = Global.vServer.vUser.vTrophy.toString();
            Home.vTrophyRank = _loc_3.txtRank;
            _loc_3.x = 0;
            _loc_3.y = -354;
            layerMenu.addChild(_loc_3);
            Global.adjustPos(_loc_3, 0, -1);
            if (Global.vServer.vUser.vTrophyMax < Global.vServer.vUser.vTrophy)
            {
                Global.vServer.vUser.vTrophyMax = Global.vServer.vUser.vTrophy;
            }
            _loc_3.txtRankMax.htmlText = Global.getText("txtTrophyMax").replace(/#/, Global.vServer.vUser.vTrophyMax);
            Global.vLang.checkSans(_loc_3.txtRankMax);
            Home.vTrophyMax = _loc_3.txtRankMax;
            vTrophyPos = new Point(_loc_3.x + _loc_3.bLeaderboard.x, _loc_3.y + _loc_3.bLeaderboard.y);
            vTrophyPos.x = vTrophyPos.x + Global.vSize.x / 2;
            vTrophyPos.y = vTrophyPos.y + Global.vSize.y / 2;
            if (Capabilities.isDebugger)
            {
                _loc_3.bSettings.addEventListener(MouseEvent.MOUSE_DOWN, this.goSettings);
            }
            else
            {
                _loc_3.bSettings.addEventListener(TouchEvent.TOUCH_BEGIN, this.goSettings);
            }
            if (Capabilities.isDebugger)
            {
                _loc_3.bProfile.addEventListener(MouseEvent.MOUSE_DOWN, this.goProfile);
            }
            else
            {
                _loc_3.bProfile.addEventListener(TouchEvent.TOUCH_BEGIN, this.goProfile);
            }
            if (Capabilities.isDebugger)
            {
                _loc_3.bLeaderboard.addEventListener(MouseEvent.MOUSE_DOWN, this.goTrophies);
            }
            else
            {
                _loc_3.bLeaderboard.addEventListener(TouchEvent.TOUCH_BEGIN, this.goTrophies);
            }
            if (Global.vDebug)
            {
                _loc_4 = new SimpleButton(layerMenu, "Menu Debug", 220, -200, this.goMenuDebug, null, true, 1, true);
                Global.adjustPos(_loc_4, 1, 0);
                _loc_4 = new SimpleButton(layerMenu, "Demo Solo", 220, -150, this.goDemoSolo, null, true, 1, true);
                Global.adjustPos(_loc_4, 1, 0);
            }
            this.refreshStartButton();
            if (Global.vServer.vUser.vNextRegCardTime >= 0)
            {
                this.vRegCardSprite = new Sprite();
                this.vRegCardSprite.x = -220;
                this.vRegCardSprite.y = 240;
                layerMenu.addChild(this.vRegCardSprite);
                _loc_10 = new HomeRegCard();
                _loc_10.txtTitle.htmlText = "<b>" + Global.getText("txtRegCard") + "</b>";
                Global.vLang.checkSans(_loc_10.txtTitle);
                Toolz.textReduce(_loc_10.txtTitle);
                _loc_10.txtTitle.y = _loc_10.txtTitle.y - _loc_10.txtTitle.textHeight;
                _loc_5 = new Card("Card", "?");
                this.vRegCardSprite.addChild(new ButtonGrafBitmap(_loc_10));
                addButton(this.vRegCardSprite, _loc_5, new Point(_loc_10.mcCard.x, _loc_10.mcCard.y), this.getRegCard, 0.7);
                if (Global.vDev)
                {
                }
                _loc_11 = Global.vServer.getTimeTo(Global.vServer.vUser.vNextRegCardTime);
                _loc_6 = new Countdown(null, _loc_11, true);
                _loc_6.x = _loc_10.mcCountdown.x;
                _loc_6.y = _loc_10.mcCountdown.y;
                _loc_6.vFinishButtonDeltaY = 0;
                this.vRegCardSprite.addChild(_loc_6);
                _loc_6.forceFinishCallback(this.getRegCard);
                Global.adjustPos(this.vRegCardSprite, -1, 1);
            }
            if (false && Global.vDebug)
            {
                _loc_12 = new ButtonTextBitmap(Menu_TextButtonMini, "Fake card");
                addButton(layerMenu, _loc_12, new Point(0, this.vStartButton.y + 270), this.onFakeCard);
                _loc_13 = new ButtonTextBitmap(Menu_TextButtonMini, "Toggle PromoPack");
                addButton(layerMenu, _loc_13, new Point(0, this.vStartButton.y + 330), this.onTogglePromoPack);
            }
            if (vShowPromoPack && Global.vServer.vUser.vPromoPack != null)
            {
                _loc_14 = new HomeRegCard();
                _loc_14.txtTitle.htmlText = "<b>" + Global.getText("txtPromoPackTitle" + Global.vServer.vUser.vPromoPack.id) + "</b>";
                Global.vLang.checkSans(_loc_14.txtTitle);
                Toolz.textReduce(_loc_14.txtTitle);
                _loc_14.txtTitle.y = _loc_14.txtTitle.y - _loc_14.txtTitle.textHeight;
                _loc_14.txtTitle.y = _loc_14.txtTitle.y - 30;
                this.vPromoPack = new ButtonGrafBitmap(_loc_14);
                this.vPromoPack.x = 220;
                this.vPromoPack.y = 240;
                layerMenu.addChild(this.vPromoPack);
                _loc_15 = new PromoPackButton();
                _loc_15.gotoAndStop(Global.vServer.vUser.vPromoPack.id);
                addButton(this.vPromoPack, new ButtonGrafBitmap(_loc_15), new Point(_loc_14.mcCard.x, _loc_14.mcCard.y), this.getPromoPack, 1);
                this.vPromoPack.addChild(new SparkleAnimation());
                this.vPromoPack.addChild(new LightAnimation());
                _loc_16 = Global.vServer.getTimeTo(Global.vServer.vUser.vPromoPack.endTime / 1000);
                if (_loc_16 <= 0)
                {
                    this.vPromoPack.visible = false;
                }
                _loc_6 = new Countdown(this.showMenu, _loc_16, true, null, null, null, true);
                _loc_6.x = _loc_14.mcCountdown.x;
                _loc_6.y = _loc_14.mcCountdown.y;
                _loc_6.y = _loc_6.y + 15;
                _loc_6.vFinishButtonDeltaY = 0;
                this.vPromoPack.addChild(_loc_6);
                Global.adjustPos(this.vPromoPack, 1, 1);
            }
            else if (!Global.vServer.isFacebookLinked())
            {
                _loc_17 = new HomeFacebookInvite();
                _loc_17.txtInvite.htmlText = "<b>" + Global.getText("txtLoggedAdGuest") + "</b>";
                Global.vLang.checkSans(_loc_17.txtInvite);
                Toolz.textReduce(_loc_17.txtInvite);
                _loc_17.txtInvite.y = _loc_17.txtInvite.y - _loc_17.txtInvite.textHeight;
                Global.adjustPos(_loc_17, 1, 1);
                addButton(layerMenu, new ButtonGrafBitmap(_loc_17), new Point(220, 240), this.goConnectFacebook);
            }
            this.initHistoryButton();
            this.initConsecutiveWinsButton();
            this.initGeneralMessage();
            if (vAccountFirstTime)
            {
                vAccountFirstTime = false;
                Global.vServer.vUser.vLevel = 1;
                Global.vTopBar.refresh();
                for (_loc_18 in Global.vServer.vUser.vCards)
                {
                    
                }
                if (_loc_18 != null)
                {
                    Global.vServer.vUser.setCards(_loc_18, 0);
                    Global.vTopBar.setNewXP(2, 0, null, [{card:_loc_18, nb:1}]);
                }
                else
                {
                    Global.vTopBar.setNewXP(2, 0, null, null);
                }
            }
            TweenMax.delayedCall(0.5, this.checkRewards);
            this.showTip();
            if (HistoryGames.vOngletSave > 0)
            {
                TweenMax.delayedCall(0.4, this.showHistoryInstant);
            }
            TweenMax.delayedCall(1, this.cleanTween);
            return;
        }// end function

        private function cleanTween() : void
        {
            if (!stage)
            {
                return;
            }
            var _loc_1:* = TweenMax.getAllTweens();
            Global.addLogTrace("TweenMax.getAllTweens=" + _loc_1.length, "Home");
            return;
        }// end function

        private function onFakeCard(event:Event) : void
        {
            new MsgBox(this, "", null, MsgBox.TYPE_NewCard, {cards:[{card:"SA", nb:1}], direct:false});
            return;
        }// end function

        private function onTogglePromoPack(event:Event) : void
        {
            var _loc_2:* = !vShowPromoPack;
            vShowPromoPack = !vShowPromoPack;
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function goPrivateGame(event:Event) : void
        {
            Global.vSound.onButton();
            if (Global.vDev)
            {
            }
            if (!Global.vServer.vUser.isTeamReady())
            {
                new MsgBox(this, Global.getText("txtTeamNotReady"), this.goTeamManager);
                return;
            }
            Global.vRoot.launchPopup(CreatePrivateGame);
            return;
        }// end function

        private function goConnectFacebook(event:Event) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = true;
            Settings.vFacebookDirect = true;
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(Settings);
            return;
        }// end function

        private function goSettings(event:Event) : void
        {
            if (Global.vDev)
            {
            }
            Global.vSound.onButton();
            var _loc_2:* = new Point(144, 114);
            Global.vRoot.launchPopup(Settings, _loc_2);
            return;
        }// end function

        private function goProfile(event:Event) : void
        {
            Global.vSound.onButton();
            var _loc_3:* = Global.vServer.vUser.vUserId;
            Profile.vId = Global.vServer.vUser.vUserId;
            var _loc_2:* = new Point(244, 114);
            Global.vRoot.launchPopup(Profile, _loc_2);
            return;
        }// end function

        private function goTrophies(event:Event) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = new Point(496, 114);
            Global.vRoot.launchPopup(Leaderboard, _loc_2);
            return;
        }// end function

        private function checkRewards() : void
        {
            if (Global.vTopBar != null)
            {
                Global.vTopBar.checkRewards();
                Global.vTopBar.checkPackWon();
            }
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        public function refreshStartButton() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            if (this.vStartButton != null)
            {
                if (this.vStartButton.parent != null)
                {
                    this.vStartButton.parent.removeChild(this.vStartButton);
                }
                var _loc_11:* = null;
                this.vStartButton = null;
            }
            var _loc_11:* = new ButtonPlayMeta();
            this.vStartButton = new ButtonPlayMeta();
            var _loc_11:* = -60;
            this.vStartButton.y = -60;
            layerMenu.addChild(this.vStartButton);
            if (Global.vServer.vUser.getTeamDesc() == "")
            {
                TweenMax.delayedCall(0.1, this.refreshStartButton);
                return;
            }
            var _loc_3:* = 3;
            while (_loc_3 >= 1)
            {
                
                var _loc_11:* = Global.vServer.vUser.getPersoGraf(_loc_3, true);
                _loc_2 = Global.vServer.vUser.getPersoGraf(_loc_3, true);
                var _loc_11:* = this.vStartButton["mcPerso" + _loc_3].x;
                _loc_2.x = this.vStartButton["mcPerso" + _loc_3].x;
                var _loc_11:* = this.vStartButton["mcPerso" + _loc_3].y;
                _loc_2.y = this.vStartButton["mcPerso" + _loc_3].y;
                var _loc_11:* = 2;
                _loc_2.scaleY = 2;
                _loc_2.scaleX = _loc_11;
                this.vStartButton.addChild(new ButtonGrafBitmap(_loc_2));
                var _loc_11:* = Global.vServer.vUser.getCharAtPosition(_loc_3);
                _loc_1 = Global.vServer.vUser.getCharAtPosition(_loc_3);
                if (_loc_1 != null)
                {
                    if (!_loc_1.isActive())
                    {
                        _loc_9 = new PersoFormGrafStatus();
                        if (_loc_1.vStatus == "training")
                        {
                            _loc_9.gotoAndStop(_loc_1.vJob.Attribute);
                        }
                        else
                        {
                            _loc_9.gotoAndStop(_loc_1.vStatus);
                        }
                        if (_loc_1.isJobFinished())
                        {
                            var _loc_11:* = false;
                            _loc_9.visible = false;
                            _loc_1.finishCurJob();
                        }
                        var _loc_11:* = this.vStartButton["mcPersoWarning" + _loc_1.vPosition].x;
                        _loc_9.x = this.vStartButton["mcPersoWarning" + _loc_1.vPosition].x;
                        var _loc_11:* = this.vStartButton["mcPersoWarning" + _loc_1.vPosition].y;
                        _loc_9.y = this.vStartButton["mcPersoWarning" + _loc_1.vPosition].y;
                        this.vStartButton.addChild(_loc_9);
                    }
                    else
                    {
                        _loc_10 = new EnergyBar(_loc_1, this.vStartButton, this.vStartButton["mcPersoWarning" + _loc_1.vPosition].x, this.vStartButton["mcPersoWarning" + _loc_1.vPosition].y);
                    }
                    _loc_8 = new HomeButtonInvisibleEnergy();
                    var _loc_11:* = this.vStartButton["mcPerso" + _loc_1.vPosition].x;
                    _loc_8.x = this.vStartButton["mcPerso" + _loc_1.vPosition].x;
                    var _loc_11:* = this.vStartButton["mcPerso" + _loc_1.vPosition].y;
                    _loc_8.y = this.vStartButton["mcPerso" + _loc_1.vPosition].y;
                    var _loc_11:* = 0;
                    _loc_8.alpha = 0;
                    var _loc_11:* = _loc_1.vCharId;
                    _loc_8.vCharId = _loc_1.vCharId;
                    this.vStartButton.addChild(_loc_8);
                    if (Capabilities.isDebugger)
                    {
                        _loc_8.addEventListener(MouseEvent.MOUSE_DOWN, this.goTeamManager);
                    }
                    else
                    {
                        _loc_8.addEventListener(TouchEvent.TOUCH_BEGIN, this.goTeamManager);
                    }
                }
                _loc_3 = _loc_3 - 1;
            }
            var _loc_4:* = new Foot2_FullView();
            _loc_4.mcField.mcGrass.gotoAndStop(Global.vWeather);
            var _loc_11:* = this.vStartButton.mcField.x;
            _loc_4.x = this.vStartButton.mcField.x;
            var _loc_11:* = this.vStartButton.mcField.y;
            _loc_4.y = this.vStartButton.mcField.y;
            var _loc_11:* = this.vStartButton.mcField.scaleX;
            _loc_4.scaleY = this.vStartButton.mcField.scaleX;
            _loc_4.scaleX = _loc_11;
            this.vStartButton.addChildAt(new ButtonGrafBitmap(_loc_4), 0);
            var _loc_5:* = new PlayFriendButton();
            var _loc_11:* = "<B>" + Global.getText("txtPrivateGameButton") + "</B>";
            _loc_5.mcTXT.txtPlay.htmlText = "<B>" + Global.getText("txtPrivateGameButton") + "</B>";
            Global.vLang.checkSans(_loc_5.mcTXT.txtPlay);
            Toolz.textReduce(_loc_5.mcTXT.txtPlay);
            addButton(this.vStartButton, new ButtonGrafBitmap(_loc_5), new Point(this.vStartButton.btPrivate.x, this.vStartButton.btPrivate.y), this.goPrivateGame);
            var _loc_6:* = new PlayButton();
            var _loc_11:* = "<B>" + Global.getText("txtMenuPlay") + "</B>";
            _loc_6.mcTXT.txtPlay.htmlText = "<B>" + Global.getText("txtMenuPlay") + "</B>";
            Global.vLang.checkSans(_loc_6.mcTXT.txtPlay);
            Toolz.textReduce(_loc_6.mcTXT.txtPlay);
            var _loc_7:* = new ButtonGrafBitmap(_loc_6);
            addButton(this.vStartButton, _loc_7, new Point(this.vStartButton.btPlay.x, this.vStartButton.btPlay.y), this.startGame, 1);
            Toolz.doPulse(_loc_7);
            this.onTipClick();
            return;
        }// end function

        private function getRegCard(event:Event = null) : void
        {
            var _loc_2:* = Global.vServer.getTimeTo(Global.vServer.vUser.vNextRegCardTime);
            if (_loc_2 > 0)
            {
                new MsgBox(this, Global.getText("txtRegCardInvite"));
                return;
            }
            if (this.vGetRegCardDone)
            {
                return;
            }
            var _loc_3:* = true;
            this.vGetRegCardDone = true;
            if (this.vRegCardSprite != null)
            {
                var _loc_3:* = false;
                this.vRegCardSprite.visible = false;
                if (this.vRegCardSprite.parent != null)
                {
                    this.vRegCardSprite.parent.removeChild(this.vRegCardSprite);
                }
                var _loc_3:* = null;
                this.vRegCardSprite = null;
            }
            Global.vSound.onButton();
            Global.vServer.getRegCard(this.onRegCard);
            return;
        }// end function

        private function onRegCard(param1:Array) : void
        {
            new MsgBox(this, Global.getText("txtNewCardGiven"), this.afterRegCard, MsgBox.TYPE_NewCard, {cards:param1, direct:false});
            return;
        }// end function

        private function afterRegCard(param1) : void
        {
            this.showMenu();
            return;
        }// end function

        override protected function onMDown(param1:MyTouch) : void
        {
            return;
        }// end function

        private function getPromoPack(event:Event = null) : void
        {
            if (this.vPromoPack != null)
            {
                var _loc_2:* = false;
                this.vPromoPack.visible = false;
            }
            Global.vSound.onButton();
            Global.vRoot.launchPopup(PromoPack, null, this.showMenu);
            return;
        }// end function

        private function goTeamManager(event:Event = null) : void
        {
            Global.vTopBar.setTab(4);
            Global.vRoot.launchMenu(TeamManager);
            return;
        }// end function

        private function goMenuDebug() : void
        {
            if (Global.vTopBar)
            {
                Global.vRoot.layerTop.removeChild(Global.vTopBar);
                var _loc_1:* = null;
                Global.vTopBar = null;
            }
            Global.vRoot.launchMenu(MenuDev);
            return;
        }// end function

        private function goDemoSolo() : void
        {
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(DemoSolo);
            return;
        }// end function

        private function initHistoryButton() : void
        {
            var _loc_1:* = addButton(layerMenu, new ButtonGrafBitmap(new MenuButton_History()), new Point(-220, this.vStartButton.y + this.vStartButton.btPlay.y), this.showHistory, 1, null, false);
            this.vHistoryButton = addButton(layerMenu, new ButtonGrafBitmap(new MenuButton_History()), new Point(-220, this.vStartButton.y + this.vStartButton.btPlay.y), this.showHistory, 1, null, false);
            Global.adjustPos(this.vHistoryButton, -1, 0);
            return;
        }// end function

        private function showHistory(event:Event = null) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = new Point(this.vHistoryButton.x + Global.vSize.x / 2, this.vHistoryButton.y + Global.vSize.y / 2);
            Global.vRoot.launchPopup(HistoryGames, _loc_2);
            return;
        }// end function

        private function showHistoryInstant(event:Event = null) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = new Point(this.vHistoryButton.x + Global.vSize.x / 2, this.vHistoryButton.y + Global.vSize.y / 2);
            Global.vRoot.launchPopup(HistoryGames, null, null);
            return;
        }// end function

        private function initConsecutiveWinsButton() : void
        {
            if (Global.vServer.vUser.vLevel < 4)
            {
                this.addEventListener(Event.ENTER_FRAME, this.checkLevelForConsecutive);
                return;
            }
            if (this.vConsecutiveWinsButton != null)
            {
                return;
            }
            var _loc_1:* = Global.vServer.vUser.vConsecutiveWins;
            var _loc_2:* = addButton(layerMenu, this.buildConsecutiveWinsButton(), new Point(220, this.vStartButton.y + this.vStartButton.btPlay.y), this.showConsecutiveWins, 1, null, false);
            this.vConsecutiveWinsButton = addButton(layerMenu, this.buildConsecutiveWinsButton(), new Point(220, this.vStartButton.y + this.vStartButton.btPlay.y), this.showConsecutiveWins, 1, null, false);
            Global.adjustPos(this.vConsecutiveWinsButton, 1, 0);
            return;
        }// end function

        private function checkLevelForConsecutive(event:Event) : void
        {
            if (!stage)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkLevelForConsecutive);
                return;
            }
            if (Global.vServer.vUser.vLevel == 4)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkLevelForConsecutive);
                this.initConsecutiveWinsButton();
            }
            return;
        }// end function

        private function buildConsecutiveWinsButton() : DisplayObject
        {
            var _loc_1:* = new ConsecutiveWinsHome();
            var _loc_3:* = "<B>" + Global.getText("txtHomeNextWin") + "</B>";
            _loc_1.txtTitle.htmlText = "<B>" + Global.getText("txtHomeNextWin") + "</B>";
            Global.vLang.checkSans(_loc_1.txtTitle);
            Toolz.textReduce(_loc_1.txtTitle);
            var _loc_2:* = new ConsecutiveWinStep(Global.vServer.vUser.vConsecutiveWins, true, true);
            var _loc_3:* = _loc_1.mcStep.x;
            _loc_2.x = _loc_1.mcStep.x;
            var _loc_3:* = _loc_1.mcStep.y;
            _loc_2.y = _loc_1.mcStep.y;
            _loc_1.addChild(_loc_2);
            var _loc_3:* = _loc_1.mcStep.y - _loc_2.getHeight() / 2 - _loc_1.txtTitle.textHeight - 10;
            _loc_1.txtTitle.y = _loc_1.mcStep.y - _loc_2.getHeight() / 2 - _loc_1.txtTitle.textHeight - 10;
            return new ButtonGrafBitmap(_loc_1);
        }// end function

        private function showConsecutiveWins(event:Event) : void
        {
            Global.vSound.onButton();
            new MsgBox(this, "", null, MsgBox.TYPE_ConsecutiveWins);
            return;
        }// end function

        private function initGeneralMessage() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            if (!stage)
            {
                return;
            }
            var _loc_1:* = false;
            if (Global.vGeneralMessageLastLoad == 0)
            {
                var _loc_4:* = true;
                _loc_1 = true;
            }
            else
            {
                _loc_2 = new Date();
                _loc_3 = (_loc_2.time - Global.vGeneralMessageLastLoad) / 1000;
                if (_loc_3 > 3600 * 6)
                {
                    var _loc_4:* = true;
                    _loc_1 = true;
                }
            }
            if (!_loc_1)
            {
                this.addGeneralMessageButton();
                return;
            }
            Global.vServer.loadGeneralMessage(this.onGeneralMessage);
            return;
        }// end function

        private function onGeneralMessage(param1:Array, param2:String) : void
        {
            var _loc_3:* = new Date();
            var _loc_4:* = _loc_3.time;
            Global.vGeneralMessageLastLoad = _loc_3.time;
            var _loc_4:* = param1.sort(this.sortGeneralMessage);
            param1 = param1.sort(this.sortGeneralMessage);
            var _loc_4:* = param1;
            Global.vGeneralMessageTab = param1;
            var _loc_4:* = param2;
            Global.vGeneralMessagePerso = param2;
            this.addGeneralMessageButton();
            return;
        }// end function

        private function sortGeneralMessage(param1:Object, param2:Object) : int
        {
            if (param1.key > param2.key)
            {
                return -1;
            }
            if (param1.key < param2.key)
            {
                return 1;
            }
            return 0;
        }// end function

        private function addGeneralMessageButton() : void
        {
            if (!stage)
            {
                return;
            }
            if (Global.vGeneralMessageTab.length == 0)
            {
                return;
            }
            var _loc_4:* = addButton(layerMenu, new ButtonGrafBitmap(new MenuButton_GeneralMessage()), new Point(this.vHistoryButton.x, this.vHistoryButton.y - 100), this.showGeneralMessage, 1, null, false);
            this.vGeneralMessageButton = addButton(layerMenu, new ButtonGrafBitmap(new MenuButton_GeneralMessage()), new Point(this.vHistoryButton.x, this.vHistoryButton.y - 100), this.showGeneralMessage, 1, null, false);
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            var _loc_2:* = 0;
            if (_loc_1.data.lastKeyGeneralMessage != undefined)
            {
                var _loc_4:* = _loc_1.data.lastKeyGeneralMessage;
                _loc_2 = _loc_1.data.lastKeyGeneralMessage;
            }
            var _loc_3:* = false;
            if (Global.vGeneralMessageTab[0].key > _loc_2)
            {
                var _loc_4:* = true;
                _loc_3 = true;
            }
            if (Global.vGeneralMessagePerso != null)
            {
                if (_loc_1.data.lastGeneralMessagePerso != Global.vGeneralMessagePerso)
                {
                    var _loc_4:* = true;
                    _loc_3 = true;
                }
            }
            if (_loc_3)
            {
                this.showGeneralMessagePastille();
            }
            else
            {
                this.hideGeneralMessagePastille();
            }
            return;
        }// end function

        private function showGeneralMessagePastille() : void
        {
            this.hideGeneralMessagePastille();
            var _loc_1:* = new ButtonGrafBitmap(new WarningGraf());
            this.vGeneralMessagePastille = new ButtonGrafBitmap(new WarningGraf());
            var _loc_1:* = this.vGeneralMessageButton.x + 30;
            this.vGeneralMessagePastille.x = this.vGeneralMessageButton.x + 30;
            var _loc_1:* = this.vGeneralMessageButton.y - 30;
            this.vGeneralMessagePastille.y = this.vGeneralMessageButton.y - 30;
            layerMenu.addChild(this.vGeneralMessagePastille);
            return;
        }// end function

        private function hideGeneralMessagePastille() : void
        {
            if (this.vGeneralMessagePastille != null)
            {
                if (this.vGeneralMessagePastille.parent != null)
                {
                    this.vGeneralMessagePastille.parent.removeChild(this.vGeneralMessagePastille);
                }
                var _loc_1:* = null;
                this.vGeneralMessagePastille = null;
            }
            return;
        }// end function

        private function showGeneralMessage(event:Event) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = new Point(this.vGeneralMessageButton.x + Global.vSize.x / 2, this.vGeneralMessageButton.y + Global.vSize.y / 2);
            Global.vRoot.launchPopup(GeneralMessage, _loc_2);
            var _loc_3:* = SharedObject.getLocal(Global.SO_ID);
            if (Global.vGeneralMessageTab.length > 0)
            {
                var _loc_4:* = Global.vGeneralMessageTab[0].key;
                _loc_3.data.lastKeyGeneralMessage = Global.vGeneralMessageTab[0].key;
            }
            if (Global.vGeneralMessagePerso == null)
            {
                delete _loc_3.data.lastGeneralMessagePerso;
            }
            else
            {
                var _loc_4:* = Global.vGeneralMessagePerso;
                _loc_3.data.lastGeneralMessagePerso = Global.vGeneralMessagePerso;
            }
            _loc_3.flush();
            this.hideGeneralMessagePastille();
            return;
        }// end function

        private function startGame(event:Event) : void
        {
            Global.vSound.onButton();
            if (!Global.vServer.vUser.isTeamReady())
            {
                new MsgBox(this, Global.getText("txtTeamNotReady"), this.goTeamManager);
                return;
            }
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(Matchmaking);
            return;
        }// end function

        private function onCardEnergy(param1:Object = null) : void
        {
            if (param1 != null)
            {
                if (param1.card != null)
                {
                    Global.vServer.charRecover(this.afterRecover, param1.charId, param1.card);
                }
            }
            return;
        }// end function

        private function afterRecover(param1:String) : void
        {
            this.refreshStartButton();
            var _loc_2:* = Global.vServer.vUser.getChar(param1);
            var _loc_3:* = _loc_2.vPosition;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = new Point(this.vStartButton["mcPersoWarning" + _loc_3].x, this.vStartButton["mcPersoWarning" + _loc_3].y - 15);
            Global.startParticles(this.vStartButton, _loc_4, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            return;
        }// end function

        override public function onNotify(param1:Sparks_Char, param2:String) : void
        {
            if (param1.vPosition > 0)
            {
                this.refreshStartButton();
            }
            return;
        }// end function

        private function showTip() : void
        {
            if (this.vCurTip != null)
            {
                return;
            }
            var _loc_1:* = 3;
            if (Global.vServer.vTipsConfig != null)
            {
                var _loc_2:* = Global.vServer.vTipsConfig.delayHide;
                _loc_1 = Global.vServer.vTipsConfig.delayHide;
            }
            if (this.vCurTipForced)
            {
                var _loc_2:* = false;
                this.vCurTipForced = false;
                var _loc_2:* = 0;
                _loc_1 = 0;
            }
            TweenMax.delayedCall(_loc_1, this.showTipDo);
            return;
        }// end function

        private function showTipDo() : void
        {
            var _loc_6:* = 0;
            if (!stage)
            {
                return;
            }
            if (this.vTips.length == 0)
            {
                _loc_6 = 1;
                while (_loc_6 <= this.vNbTips)
                {
                    
                    this.vTips.push(_loc_6);
                    _loc_6++;
                }
            }
            var _loc_7:* = Toolz.shuffleTab(this.vTips);
            this.vTips = Toolz.shuffleTab(this.vTips);
            var _loc_1:* = new TipMessageBubble();
            var _loc_2:* = this.vTips.pop();
            var _loc_3:* = Global.getText("txtTip" + _loc_2.toString());
            var _loc_7:* = "<b>" + _loc_3 + "</b>";
            _loc_1.txt.htmlText = "<b>" + _loc_3 + "</b>";
            Global.vLang.checkSans(_loc_1.txt);
            Toolz.textReduce(_loc_1.txt);
            var _loc_7:* = false;
            _loc_1.txt.mouseEnabled = false;
            var _loc_7:* = _loc_1.txt.y - _loc_1.txt.textHeight / 2;
            _loc_1.txt.y = _loc_1.txt.y - _loc_1.txt.textHeight / 2;
            var _loc_4:* = new ButtonGrafBitmap(_loc_1);
            layerMenu.addChild(_loc_4);
            var _loc_7:* = 70;
            _loc_4.x = 70;
            var _loc_7:* = this.vStartButton.y - 180;
            _loc_4.y = this.vStartButton.y - 180;
            var _loc_5:* = 9;
            if (Global.vServer.vTipsConfig != null)
            {
                var _loc_7:* = Global.vServer.vTipsConfig.delayShow;
                _loc_5 = Global.vServer.vTipsConfig.delayShow;
            }
            TweenMax.from(_loc_4, 0.2, {scaleX:0, scaleY:0, ease:Bounce.easeOut});
            TweenMax.to(_loc_4, 0.3, {delay:_loc_5 - 0.5, alpha:0, onComplete:this.onTipClose});
            if (Global.vRoot.layerPopup.numChildren == 0)
            {
                Global.vSound.onImpact(0.8);
            }
            if (Capabilities.isDebugger)
            {
                _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.onTipClick);
            }
            else
            {
                _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTipClick);
            }
            var _loc_7:* = _loc_4;
            this.vCurTip = _loc_4;
            return;
        }// end function

        private function onTipClick(event:Event = null) : void
        {
            if (this.vCurTip == null)
            {
                return;
            }
            var _loc_2:* = true;
            this.vCurTipForced = true;
            TweenMax.killDelayedCallsTo(this.vCurTip);
            TweenMax.to(this.vCurTip, 0.3, {alpha:0, onComplete:this.onTipClose});
            return;
        }// end function

        private function onTipClose() : void
        {
            if (this.vCurTip != null)
            {
                if (this.vCurTip.parent != null)
                {
                    this.vCurTip.parent.removeChild(this.vCurTip);
                }
                var _loc_1:* = null;
                this.vCurTip = null;
            }
            this.showTip();
            return;
        }// end function

    }
}
