package menu.game
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import menu.popup.*;
    import menu.screens.*;
    import tools.*;

    public class Replay extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vButtonScale:Number = 1;
        private var vButtonBuy:Sprite;
        private var vData:Object;
        private var vCanQuit:Boolean = true;
        private var vButtonPause:Sprite;
        private var vPause:Boolean = true;
        private var vRestarting:Boolean = false;
        private var vButtonSpeed:Sprite;
        private var vButtonSave:Sprite;
        private var vSpeed:Number = 0.5;
        private var vRound:int = -1;
        private var vRoundLastGoal:int = -1;
        private var vSuddenDeathStarted:Boolean = false;
        private var vNeedRestart:Boolean = false;
        public static var vGameId:String = "";
        public static var vAutoStart:Boolean = false;

        public function Replay()
        {
            vTag = "Replay";
            Global.vSound.stopMusic();
            Global.vSound.aroundGame();
            Global.vHitPoints = true;
            Global.vStats.Stats_PageView("Replay");
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            vImages["button_speed_pause"] = new mcToBitmapAS3(new MenuButton_Speed_Pause(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_play"] = new mcToBitmapAS3(new MenuButton_Speed_Play(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_1"] = new mcToBitmapAS3(new MenuButton_Speed_1(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_2"] = new mcToBitmapAS3(new MenuButton_Speed_2(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_4"] = new mcToBitmapAS3(new MenuButton_Speed_4(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_half"] = new mcToBitmapAS3(new MenuButton_Speed_Half(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_speed_restart"] = new mcToBitmapAS3(new MenuButton_Speed_Restart(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            vImages["button_save"] = new mcToBitmapAS3(new MenuButton_Save(), 0, Global.vResolution * this.vButtonScale, true, null, 0, param1);
            return;
        }// end function

        private function showTrace(event:Event) : void
        {
            if (Global.vClientTrace == null)
            {
                Global.vClientTrace = new MyLogTrace();
            }
            else
            {
                Global.vClientTrace.toggle();
            }
            return;
        }// end function

        override protected function init() : void
        {
            if (Global.vDev)
            {
            }
            if (vGameId == "")
            {
                this.onError("No GameId");
                return;
            }
            Global.vServer.loadReplay(this.onReplay, vGameId);
            return;
        }// end function

        private function onReplay(param1:Object) : void
        {
            this.vData = param1;
            GBL_Main.replayWeather(this.vData.weather);
            if (this.vData.replaySaved1 == true && Global.vServer.vUser.vUserId == this.vData.player1)
            {
                this.vData.replaySaved = true;
            }
            if (this.vData.replaySaved2 == true && Global.vServer.vUser.vUserId == this.vData.player2)
            {
                this.vData.replaySaved = true;
            }
            GBL_Main.parseDataSuddenDeath(this.vData.suddendeath);
            GBL_Main.parseDataHitPoints(this.vData.hitpoints);
            this.initGame();
            return;
        }// end function

        private function initGame() : void
        {
            var _loc_2:* = null;
            GBL_Resolution.vSpeedCoef = 1;
            var _loc_1:* = new MsgboxBG();
            _loc_1.x = Global.vSize.x / 2;
            _loc_1.y = Global.vSize.y / 2;
            _loc_1.width = Global.vSize.x + 2 * Global.vScreenDelta.x / Global.vResolution;
            _loc_1.height = Global.vSize.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            addChild(_loc_1);
            TweenMax.from(_loc_1, 0.6, {alpha:0});
            this.vGame = new GBL_Main();
            this.vGame.vReplay = true;
            addChild(this.vGame);
            if (this.vData.player2 == Global.vServer.vUser.vUserId)
            {
                this.vGame.setCurTeam(2);
                _loc_2 = this.vData.reward1;
                this.vData.reward1 = this.vData.reward2;
                this.vData.reward2 = _loc_2;
                if (this.vData.winner == this.vData.player1)
                {
                    this.vData.winner = this.vData.player2;
                }
                else if (this.vData.winner == this.vData.player2)
                {
                    this.vData.winner = this.vData.player1;
                }
            }
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onError(param1:String) : void
        {
            Global.addLogTrace("Replay.onError:" + param1);
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            this.initInterface();
            var _loc_2:* = JSON.stringify(this.vData.team1);
            if (_loc_2 == "" || _loc_2 == null)
            {
                this.onError("lTeamDesc1=" + _loc_2);
                return;
            }
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(1, _loc_2);
            this.vGame.addTeam(1, _loc_1);
            var _loc_3:* = JSON.stringify(this.vData.team2);
            if (_loc_3 == "" || _loc_3 == null)
            {
                this.onError("lTeamDesc2=" + _loc_3);
                return;
            }
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(2, _loc_3);
            this.vGame.addTeam(2, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.vGame.showGameBG();
            this.vGame.vInterface.addQuit(this.onButtonQuitGame);
            this.startReplay();
            return;
        }// end function

        private function onButtonQuitGame(event:Event = null) : void
        {
            if (!this.vCanQuit)
            {
                return;
            }
            this.vGame.stopRunning();
            this.vGame.vEndDone = true;
            this.vCanQuit = false;
            Global.vSound.onButton();
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function initInterface() : void
        {
            this.vButtonPause = addButton(this.vGame.layerInterface, new Sprite(), new Point(Global.vSize.x / 2 - 30, -50), this.togglePause, this.vButtonScale);
            Global.adjustPos(this.vButtonPause, 1, 0);
            this.togglePause();
            this.vButtonSpeed = addButton(this.vGame.layerInterface, new Sprite(), new Point(Global.vSize.x / 2 - 30, 50), this.toggleSpeed, this.vButtonScale);
            Global.adjustPos(this.vButtonSpeed, 1, 0);
            this.toggleSpeed();
            if (this.vData.replaySaved != true)
            {
                this.vButtonSave = addButton(this.vGame.layerInterface, new bitmapClip(vImages["button_save"]), new Point(Global.vSize.x / 2 - 30, Global.vSize.y / 2 - 30), this.askBuyReplay, this.vButtonScale);
                Global.adjustPos(this.vButtonSave, 1, 1);
            }
            return;
        }// end function

        private function togglePause(event:Event = null, param2:Boolean = true) : void
        {
            if (param2)
            {
                Global.vSound.onButton();
            }
            if (this.vRestarting)
            {
                Global.vRoot.launchMenu(Replay);
                return;
            }
            this.vPause = !this.vPause;
            while (this.vButtonPause.numChildren > 0)
            {
                
                this.vButtonPause.removeChildAt(0);
            }
            if (this.vPause)
            {
                this.vButtonPause.addChild(new bitmapClip(vImages["button_speed_play"]));
            }
            else
            {
                this.vButtonPause.addChild(new bitmapClip(vImages["button_speed_pause"]));
            }
            this.vGame.togglePause();
            return;
        }// end function

        private function toggleSpeed(event:Event = null) : void
        {
            Global.vSound.onButton();
            while (this.vButtonSpeed.numChildren > 0)
            {
                
                this.vButtonSpeed.removeChildAt(0);
            }
            if (this.vSpeed == 0.5)
            {
                this.vSpeed = 1;
                this.vButtonSpeed.addChild(new bitmapClip(vImages["button_speed_1"]));
            }
            else if (this.vSpeed == 1)
            {
                this.vSpeed = 2;
                this.vButtonSpeed.addChild(new bitmapClip(vImages["button_speed_2"]));
            }
            else if (this.vSpeed == 2)
            {
                this.vSpeed = 4;
                this.vButtonSpeed.addChild(new bitmapClip(vImages["button_speed_4"]));
            }
            else if (this.vSpeed == 4)
            {
                this.vSpeed = 0.5;
                this.vButtonSpeed.addChild(new bitmapClip(vImages["button_speed_half"]));
            }
            if (this.vPause)
            {
                this.togglePause(event, false);
            }
            this.vGame.changeSpeedResolution(this.vSpeed);
            return;
        }// end function

        private function toggleRestart() : void
        {
            if (vImages == null)
            {
                return;
            }
            while (this.vButtonPause.numChildren > 0)
            {
                
                this.vButtonPause.removeChildAt(0);
            }
            this.vRestarting = true;
            this.vButtonPause.addChild(new bitmapClip(vImages["button_speed_restart"]));
            return;
        }// end function

        private function startReplay() : void
        {
            this.vGame.vTerrain.initDimensions();
            this.vGame.vTerrain.initGlobsGraf();
            this.vGame.vInterface.initInfos();
            this.vGame.initPseudos(this.vData.name1, this.vData.name2, this.vData.team1.startTrophies, this.vData.team2.startTrophies);
            this.vGame.vInterface.hideTimer();
            this.vGame.vInterface.hideCharInfoButton();
            this.restartRound();
            return;
        }// end function

        private function restartRound(param1:Boolean = true) : void
        {
            if (!this.vGame.vRunning)
            {
                return;
            }
            if (param1)
            {
                this.vGame.restartRound(this.nextRound);
            }
            else
            {
                this.vGame.restartRound(this.nextRound);
            }
            return;
        }// end function

        private function afterGoal() : void
        {
            if (!this.vGame.vRunning)
            {
                return;
            }
            this.vNeedRestart = true;
            this.nextRound();
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        private function nextRound() : void
        {
            if (!this.vGame.vRunning)
            {
                return;
            }
            this.vGame.nextRound(this.nextRoundDo);
            return;
        }// end function

        private function nextRoundDo() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            if (!this.vGame.vRunning)
            {
                return;
            }
            var _loc_7:* = this;
            var _loc_8:* = this.vRound + 1;
            _loc_7.vRound = _loc_8;
            var _loc_1:* = false;
            var _loc_2:* = "";
            Global.addLogTrace("vRound=" + this.vRound);
            if (this.vData.orders == null || this.vRound >= this.vData.orders.length)
            {
                _loc_1 = true;
            }
            else if (this.vData.orders[this.vRound].seat1 == null)
            {
                _loc_1 = true;
            }
            else if (this.vData.orders[this.vRound].seat2 == null)
            {
                _loc_1 = true;
            }
            else
            {
                _loc_2 = this.vData.orders[this.vRound].seat1 + "_" + this.vData.orders[this.vRound].seat2;
            }
            if (_loc_1)
            {
                this.endReplay();
                return;
            }
            Global.addLogTrace("lOrders=" + _loc_2);
            _loc_3 = _loc_2.split("_");
            if (_loc_3.length > 0)
            {
                _loc_3 = _loc_3[0].split(":");
                if (_loc_3.length > 0)
                {
                    if (_loc_3[0] == "goal")
                    {
                        this.vRoundLastGoal = this.vRound;
                        this.nextRound();
                        return;
                    }
                    if (_loc_3[0] == "gameover")
                    {
                        this.endReplay();
                        return;
                    }
                }
            }
            if (this.vNeedRestart)
            {
                this.vNeedRestart = false;
                var _loc_7:* = this;
                var _loc_8:* = this.vRound - 1;
                _loc_7.vRound = _loc_8;
                this.restartRound();
                return;
            }
            if (this.vSuddenDeathStarted)
            {
                this.vGame.vTerrain.updateSuddenDeath();
            }
            else
            {
                _loc_3 = _loc_2.split("_");
                _loc_4 = new Object();
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_6 = _loc_3[_loc_5].split(",");
                    if (_loc_6.length > 2)
                    {
                        if (_loc_6[0] == "timer")
                        {
                            if (_loc_6[2] == 0)
                            {
                                _loc_4["timer" + _loc_6[1]] = true;
                            }
                        }
                    }
                    _loc_5++;
                }
                if (_loc_4.timer1 == true && _loc_4.timer2 == true)
                {
                    this.vSuddenDeathStarted = true;
                }
            }
            this.vGame.startResolution(_loc_2, this.afterResolution);
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            var _loc_2:* = null;
            if (!this.vGame.vRunning)
            {
                return;
            }
            if (param1 == 0)
            {
                this.nextRound();
            }
            else
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_confetti"], 8, 0, 240, 90 / GBL_Resolution.vSpeedCoef, 0.5, true, 1, 0.1, 0.25, 4, -4, 5, -2, 0.98, "normal", true, true);
                if (this.vGame.vInterface.vScore1 == 2 || this.vGame.vInterface.vScore2 == 2)
                {
                    this.vRoundLastGoal = this.vRound;
                    this.endReplay();
                }
                else
                {
                    TweenMax.delayedCall(2.5 / GBL_Resolution.vSpeedCoef, this.afterGoal);
                }
            }
            return;
        }// end function

        private function endReplay() : void
        {
            if (!this.vGame.vRunning)
            {
                return;
            }
            Global.vSound.stopGameLoop();
            var _loc_1:* = 0;
            if (this.vData.winner == this.vData.player1)
            {
                _loc_1 = 1;
            }
            else if (this.vData.winner == this.vData.player2)
            {
                _loc_1 = 1;
            }
            this.vGame.onGameEnd(_loc_1);
            if (this.vRound != this.vRoundLastGoal)
            {
                TweenMax.delayedCall(1, this.endReplayReward);
            }
            else
            {
                this.endReplayReward();
            }
            return;
        }// end function

        private function endReplayReward() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_6:* = null;
            if (!this.vGame.vRunning)
            {
                return;
            }
            this.toggleRestart();
            var _loc_5:* = 1;
            while (_loc_5 <= 2)
            {
                
                if (GBL_Main.isReverse)
                {
                    _loc_4 = 3 - _loc_5;
                }
                else
                {
                    _loc_4 = _loc_5;
                }
                _loc_1 = this.vData["reward" + _loc_5];
                _loc_2 = "";
                if (_loc_1.statusGame == "victory")
                {
                    _loc_2 = Global.getText("txtEndGameVictory");
                }
                else if (_loc_1.statusGame == "defeat")
                {
                    if (_loc_1["statusScore" + _loc_4] == "forfeit")
                    {
                        _loc_2 = Global.getText("txtEndGameForfeit");
                    }
                }
                else if (_loc_1.statusGame == "cancelled")
                {
                    if (_loc_1["statusScore" + _loc_4] == "leaver")
                    {
                        _loc_2 = Global.getText("txtEndGameConnectionIssueShort");
                    }
                    else if (_loc_1["statusScore" + _loc_4] == "forfeit")
                    {
                        _loc_2 = Global.getText("txtEndGameForfeit");
                    }
                }
                if (_loc_2 != "")
                {
                    _loc_3 = new GrafReplayStatus();
                    _loc_3.gotoAndStop(_loc_5);
                    _loc_3.txtStatus.htmlText = "<B>" + _loc_2 + "</B>";
                    Global.vLang.checkSans(_loc_3.txtStatus);
                    Toolz.textReduce(_loc_3.txtStatus);
                    this.vGame.layerInterface.addChild(_loc_3);
                }
                _loc_5++;
            }
            if (this.vData.replaySaved != true)
            {
                _loc_6 = new ReplayBuyInvite();
                _loc_6.txtTitle.htmlText = "<B>" + Global.getText("txtBuyReplayInvite") + "</B>";
                Global.vLang.checkSans(_loc_6.txtTitle);
                Toolz.textReduce(_loc_6.txtTitle);
                _loc_6.txtGold.htmlText = "<B>" + Global.vReplayPrice.toString() + "</B>";
                this.vButtonBuy = addButton(this.vGame.layerInterface, _loc_6, new Point(0, 0), this.askBuyReplay);
                TweenMax.from(this.vButtonBuy, 0.3, {delay:1, alpha:0});
            }
            return;
        }// end function

        private function askBuyReplay(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            Global.vSound.onButton();
            var _loc_2:* = Global.vReplayPrice - Global.vServer.vUser.vHardCurrency;
            if (_loc_2 > 0)
            {
                _loc_3 = Global.getText("txtNotEnoughGold").replace(/#/, _loc_2.toString());
                _loc_3 = _loc_3 + "<br><br>" + Global.getText("txtAskGoShop");
                _loc_4 = new LowBar_Icons();
                _loc_4.gotoAndStop(1);
                var _loc_5:* = 2;
                _loc_4.scaleY = 2;
                _loc_4.scaleX = _loc_5;
                new MsgBox(Global.vRoot.vMenu, _loc_3, this.goShop, MsgBox.TYPE_YesNoWithGraf, {graf:_loc_4});
                return;
            }
            new MsgBox(this, Global.getText("txtBuyReplayConfirm").replace(/#/, Global.vReplayPrice.toString()), this.confirmBuyReplay, MsgBox.TYPE_YesNo);
            return;
        }// end function

        private function goShop(param1:Boolean, param2:Object = null) : void
        {
            if (param1)
            {
                Global.vTopBar.appear();
                Shop.vDirectGold = true;
                Global.vRoot.launchMenu(Shop);
            }
            return;
        }// end function

        private function confirmBuyReplay(param1:Boolean) : void
        {
            if (!param1)
            {
                return;
            }
            if (this.vButtonBuy != null)
            {
                if (this.vButtonBuy.alpha < 1)
                {
                    return;
                }
                TweenMax.to(this.vButtonBuy, 0.3, {alpha:0});
            }
            Global.vServer.saveReplay(this.afterBuy, vGameId);
            return;
        }// end function

        private function afterBuy(param1:int) : void
        {
            Global.vServer.vUser.vHardCurrency = param1;
            if (Global.vTopBar != null)
            {
                Global.vTopBar.refresh();
            }
            HistoryGames.vOngletSave = 2;
            HistoryGames.vContentPos = 0;
            HistoryGames.vContentData = null;
            new MsgBox(this, Global.getText("txtBuyReplayDone"), this.onButtonQuitGame);
            return;
        }// end function

    }
}
