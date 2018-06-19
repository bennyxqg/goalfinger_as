package menu.game
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import tools.*;

    public class Matchmaking extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vStatus:String = "";
        private var vAlternativeTimersStarted:Boolean = false;
        private var vStatsTimer:int = 0;
        private var vCanQuit:Boolean = true;
        private var vMap:Sprite;
        private var vCharCode:Array;
        private var vCharIndex:int = 0;
        private var vShirtCode:Array;
        private var vShirtIndex:int = 0;
        private var vPersoPos:Array;
        private var vPersoIndex:int = 0;
        private var vPersoMC:Vector.<PersoGrafMain>;
        private var vBotStarted:Boolean = false;
        private var vBot:GBL_Bot;
        private var vBotRetry:int = 0;
        private var vPlayerOrders:String;
        public static var vPrivatePass:String = "";
        public static var vLastMatchmakeStarted:int = 0;
        public static var vNbRecentMatchmakeStarted:int = 0;
        public static var vHideAtStart:Boolean = false;
        public static var vSynchroOnly:Boolean = false;

        public function Matchmaking()
        {
            vTag = "Matchmaking";
            Global.vSound.stopMusic();
            Global.vSound.aroundGame();
            if (vHideAtStart)
            {
                visible = false;
                vHideAtStart = false;
            }
            Global.vStats.Stats_PageView("Matchmaking");
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.vStatus = "Init";
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            this.vGame.activateDemoSolo();
            this.vGame.setCurTeam(1);
            Global.addLogTrace("init");
            if (getTimer() - vLastMatchmakeStarted < 30 * 1000)
            {
                var _loc_2:* = vNbRecentMatchmakeStarted + 1;
                vNbRecentMatchmakeStarted = _loc_2;
                if (vNbRecentMatchmakeStarted > 5)
                {
                    vNbRecentMatchmakeStarted = 0;
                    Global.vServer.logout();
                    Global.vRoot.entryPoint();
                    return;
                }
            }
            else
            {
                vNbRecentMatchmakeStarted = 0;
            }
            vLastMatchmakeStarted = getTimer();
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        override public function onDeactivate(event:Event) : void
        {
            if (this.vStatus == "Matchmake")
            {
                Global.vServer.stopMatchmake();
                this.backToMenu();
            }
            return;
        }// end function

        override public function onReactivate(event:Event) : void
        {
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            Global.addLogTrace("onGameReady");
            var _loc_2:* = Global.vServer.vUser.getTeamDesc();
            if (_loc_2 == "")
            {
                this.backToMenu();
                return;
            }
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(1, _loc_2);
            this.vGame.addTeam(1, _loc_1);
            var _loc_3:* = "{\"shirt\":\"SA_004\",\"player1\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Paulo\",\"code\":\"PA_005\",\"vitality\":0},\"player3\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Alberto\",\"code\":\"PA_006\",\"vitality\":0},\"player2\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Antonio\",\"code\":\"PA_003\",\"vitality\":0}}";
            _loc_3 = _loc_2;
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(2, _loc_3);
            if (_loc_1.vShirtCode == "SA_001")
            {
                _loc_1.setShirtCode("SA_003");
            }
            else
            {
                _loc_1.setShirtCode("SA_001");
            }
            this.vGame.addTeam(2, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.initMatchmake();
            return;
        }// end function

        private function initMatchmake() : void
        {
            this.vStatus = "Playing";
            this.startMap();
            Global.vServer.initMatch(this.onServerInfo);
            this.vGame.vInterface.addQuit(this.onButtonQuitGame);
            this.vStatsTimer = getTimer();
            this.doStats("Start");
            this.vStatus = "Matchmake";
            Global.vServer.startMatchmake(this.onMatchmakeInfo);
            return;
        }// end function

        private function startAlternativeTimers() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            if (this.vAlternativeTimersStarted)
            {
                return;
            }
            this.vAlternativeTimersStarted = true;
            Global.addLogTrace("startAlternativeTimers", "Matchmaking");
            var _loc_1:* = "";
            var _loc_2:* = 1;
            if (vPrivatePass == "")
            {
                _loc_1 = Global.getText("txtMatchmakeRunning");
            }
            else
            {
                _loc_1 = Global.getText("txtPrivateGameWaiting");
                _loc_1 = _loc_1.replace(/#/, vPrivatePass);
                _loc_2 = 2;
            }
            this.vGame.showInfoBox(_loc_1, _loc_2);
            if (vPrivatePass == "")
            {
                _loc_3 = 10;
                if (Global.vDev)
                {
                    _loc_3 = 1;
                }
                TweenMax.delayedCall(_loc_3, this.startBot);
                _loc_4 = Math.random();
                _loc_5 = Global.vFakeStartMin;
                _loc_6 = Global.vFakeStartMax;
                _loc_7 = 0;
                while (_loc_7 <= 100)
                {
                    
                    _loc_8 = Math.random();
                    _loc_8 = Math.random() * _loc_8;
                    _loc_9 = _loc_5 + _loc_8 * (_loc_6 - _loc_5);
                    _loc_7++;
                }
                TweenMax.delayedCall(_loc_9, this.startFake);
            }
            else if (Global.vDebug)
            {
                _loc_3 = 10;
                if (Global.vDev)
                {
                    _loc_3 = 1;
                }
                TweenMax.delayedCall(_loc_3, this.startBot);
            }
            return;
        }// end function

        private function startMatchmake() : void
        {
            Global.vServer.startMatchmakeDo();
            return;
        }// end function

        private function doStats(param1:String) : void
        {
            var _loc_2:* = Math.round((getTimer() - this.vStatsTimer) / 1000);
            this.vStatsTimer = getTimer();
            Global.vStats.Stats_Event("Matchmaking", param1, "Timer", _loc_2);
            return;
        }// end function

        private function onMatchmakeInfo(param1:String) : void
        {
            Global.addLogTrace("onMatchmakeInfo:" + param1);
            var _loc_2:* = param1.split(":");
            if (_loc_2.length > 0)
            {
                Global.addLogTrace("lTab[0]=" + _loc_2[0]);
                if (_loc_2[0] == "onGameCreatedError")
                {
                    Global.vRoot.launchMenu(Home);
                }
                else if (param1 == "MatchmakingStarted")
                {
                    this.startAlternativeTimers();
                }
                else if (_loc_2[0] == "onCheckRunningGame")
                {
                    Global.vRoot.launchMenu(Home);
                }
                else if (_loc_2[0] == "Error")
                {
                    if (_loc_2.length > 1)
                    {
                        Global.addLogTrace("lTab[1]=" + _loc_2[1]);
                        if (_loc_2[1] == "TimeoutOtherToCreate")
                        {
                            if (stage)
                            {
                                Global.vRoot.launchMenu(Home);
                            }
                        }
                    }
                }
                else if (_loc_2[0] == "onGameAlreadyRunning")
                {
                    this.vStatus = "Quit";
                    this.vCanQuit = false;
                    PlayOnline.vSeat = 0;
                    PlayOnline.vMatchToJoin = _loc_2[1];
                    Global.addLogTrace("Matchmaking > Join Game");
                    Global.vRoot.launchMenu(PlayOnline);
                }
            }
            return;
        }// end function

        private function onServerInfo(param1:String, param2:Object = null) : void
        {
            Global.addLogTrace("Matchmaking.onServerInfo:" + param1, "Matchmaking");
            if (param1 == "onGameCancelled")
            {
                Global.vServer.killGame("onGameCancelled");
                this.backToMenu();
                return;
            }
            if (!stage)
            {
                return;
            }
            if (param1 != "Trace")
            {
                Global.addLogTrace("onServerInfo:" + param1);
            }
            if (this.vGame == null)
            {
                return;
            }
            if (param1 == "Trace")
            {
                Global.addLogTrace("Trace:" + param2.trace);
            }
            else if (param1 == "MatchFound")
            {
                this.vStatus = "MatchFound";
                TweenMax.delayedCall(10, this.onTimeoutAfterMatchFound);
            }
            else if (param1 == "MatchNotFound")
            {
                if (this.canContinue())
                {
                    TweenMax.delayedCall(0.3, this.startMatchmake);
                }
            }
            else if (param1 == "onSeatChange")
            {
                this.vStatus = "GameStarted";
                this.doStats("Success");
                PlayOnline.vSeat = parseInt(param2.seat);
                if (this.vBotStarted)
                {
                    PlayOnline.showMessageTrainingDone = true;
                }
                Global.addLogTrace("Matchmaking > PlayOnline");
                Global.vRoot.launchMenu(PlayOnline);
            }
            else if (param1 == "onOpponentLeft")
            {
                this.onGameReady();
            }
            else
            {
                Global.onError("onServerInfo unknown info : " + param1);
            }
            return;
        }// end function

        private function onFatalError(param1:String) : void
        {
            Global.addLogTrace("onFatalError pMessage=" + param1);
            if (this.vGame != null)
            {
                this.vGame.stopRunning(false);
            }
            new MsgBox(Global.vRoot.vMenu, param1);
            return;
        }// end function

        private function onTimeoutAfterMatchFound() : void
        {
            Global.addLogTrace("onTimeoutAfterMatchFound vStatus=" + this.vStatus, "Matchmaking");
            if (this.vStatus != "GameStarted")
            {
                Global.addLogTrace("Matchmaking : Match not started");
                Global.vServer.stopMatchmake();
                Global.vSound.stopAroundGame();
                this.backToMenu();
            }
            return;
        }// end function

        private function onButtonQuitGame(event:Event = null) : void
        {
            Global.vSound.onButton();
            if (this.vStatus == "Matchmake")
            {
                if (!this.vCanQuit)
                {
                    return;
                }
                this.vStatus = "Quit";
                this.vCanQuit = false;
                Global.vServer.stopMatchmake();
                this.backToMenu();
                this.doStats("Cancel");
            }
            else if (this.vStatus == "Matchfound")
            {
                return;
            }
            return;
        }// end function

        private function backToMenu() : void
        {
            Global.addLogTrace("backToMenu");
            if (Global.vGame != null)
            {
                Global.vGame.destroy();
                Global.vGame = null;
            }
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function startMap() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_4:* = null;
            this.vMap = new Sprite();
            this.vMap.addChild(new bitmapClip(Global.vImages["mapmonde"]));
            this.vMap.x = Global.vSize.x / 2;
            this.vMap.y = Global.vSize.y / 2;
            addChildAt(this.vMap, 0);
            TweenMax.from(this.vMap, 0.3, {alpha:0.1});
            this.vCharCode = new Array();
            _loc_1 = 1;
            while (_loc_1 <= 15)
            {
                
                if (_loc_1 < 10)
                {
                    _loc_2 = "00" + _loc_1.toString();
                }
                else
                {
                    _loc_2 = "0" + _loc_1.toString();
                }
                this.vCharCode.push("PA_" + _loc_2);
                this.vCharCode.push("PB_" + _loc_2);
                this.vCharCode.push("PC_" + _loc_2);
                _loc_1++;
            }
            this.vCharCode = Toolz.shuffleTab(this.vCharCode);
            this.vShirtCode = new Array();
            _loc_1 = 1;
            while (_loc_1 <= 15)
            {
                
                if (_loc_1 < 10)
                {
                    _loc_2 = "00" + _loc_1.toString();
                }
                else
                {
                    _loc_2 = "0" + _loc_1.toString();
                }
                if (_loc_1 <= 6)
                {
                    this.vShirtCode.push("SA_" + _loc_2);
                }
                if (_loc_1 <= 24)
                {
                    this.vShirtCode.push("SB_" + _loc_2);
                }
                if (_loc_1 <= 15)
                {
                    this.vShirtCode.push("SC_" + _loc_2);
                }
                _loc_1++;
            }
            this.vShirtCode = Toolz.shuffleTab(this.vShirtCode);
            this.vPersoPos = new Array();
            var _loc_3:* = new MapRep();
            _loc_3.gotoAndStop(Init.getMapZone());
            _loc_1 = 1;
            while (_loc_1 <= 38)
            {
                
                _loc_4 = new Point(0, 0);
                _loc_4.x = _loc_3["mcPerso" + _loc_1].x;
                _loc_4.y = _loc_3["mcPerso" + _loc_1].y;
                this.vPersoPos.push(_loc_4);
                _loc_1++;
            }
            this.vPersoPos = Toolz.shuffleTab(this.vPersoPos);
            this.vPersoMC = new Vector.<PersoGrafMain>;
            this.showNextPerso();
            return;
        }// end function

        private function showNextPerso() : void
        {
            var _loc_3:* = null;
            if (this.vMap.alpha == 0)
            {
                return;
            }
            var _loc_1:* = false;
            if (this.vPersoMC.length > 10)
            {
                if (Math.random() < 0.3 + this.vPersoMC.length / 10)
                {
                    _loc_1 = true;
                }
            }
            if (Global.vDev)
            {
            }
            if (_loc_1)
            {
                _loc_3 = this.vPersoMC.shift();
                if (this.vMap.contains(_loc_3))
                {
                    TweenMax.to(_loc_3, 0.3, {alpha:0, onComplete:this.removePuppet, onCompleteParams:[_loc_3]});
                }
            }
            else
            {
                var _loc_4:* = this;
                var _loc_5:* = this.vCharIndex + 1;
                _loc_4.vCharIndex = _loc_5;
                if (this.vCharIndex >= this.vCharCode.length)
                {
                    this.vCharIndex = 0;
                }
                var _loc_4:* = this;
                var _loc_5:* = this.vShirtIndex + 1;
                _loc_4.vShirtIndex = _loc_5;
                if (this.vShirtIndex >= this.vShirtCode.length)
                {
                    this.vShirtIndex = 0;
                }
                var _loc_4:* = this;
                var _loc_5:* = this.vPersoIndex + 1;
                _loc_4.vPersoIndex = _loc_5;
                if (this.vPersoIndex >= this.vPersoPos.length)
                {
                    this.vPersoIndex = 0;
                }
                this.addPersoOnMap(this.vCharCode[this.vCharIndex], this.vShirtCode[this.vShirtIndex], this.vPersoPos[this.vPersoIndex]);
            }
            var _loc_2:* = 0.01 + 0.3 * Math.random();
            if (Global.vDev)
            {
            }
            TweenMax.delayedCall(_loc_2, this.showNextPerso);
            return;
        }// end function

        private function removePuppet(param1:PersoGrafMain) : void
        {
            if (this.vMap.contains(param1))
            {
                this.vMap.removeChild(param1);
            }
            return;
        }// end function

        private function addPersoOnMap(param1:String, param2:String, param3:Point) : void
        {
            var _loc_4:* = new PersoGrafMain();
            _loc_4.init();
            _loc_4.setGraf(param1, param2, false, Global.vSWFImages, Global.vSWFLoader);
            _loc_4.setOrientation(0);
            _loc_4.x = param3.x;
            _loc_4.y = param3.y;
            this.vMap.addChild(_loc_4);
            TweenMax.from(_loc_4, 0.3, {scaleX:0, scaleY:0, alpha:0, ease:Bounce.easeOut});
            this.vPersoMC.push(_loc_4);
            return;
        }// end function

        private function startBot() : void
        {
            if (this.canContinue())
            {
                if (Global.vDev)
                {
                }
                new MsgBox(this, Global.getText("txtMatchmakeInviteTraining"), this.swapToGame, 1, null, "", 1, 3);
            }
            return;
        }// end function

        private function swapToGame() : void
        {
            if (!this.canContinue())
            {
                return;
            }
            TweenMax.to(this.vMap, 0.3, {alpha:0});
            this.vGame.showGameBG();
            this.vGame.vAIRunning = true;
            TweenMax.from(this.vGame, 0.3, {alpha:0});
            this.vGame.removeInfoBox();
            TweenMax.delayedCall(0.6, this.launchBot);
            return;
        }// end function

        private function launchBot() : void
        {
            if (!this.canContinue())
            {
                return;
            }
            Global.vHitPoints = false;
            this.vGame.vTerrain.initDimensions();
            this.vGame.vTerrain.initGlobsGraf();
            this.prepareBot();
            this.restartRound();
            this.vBotStarted = true;
            return;
        }// end function

        private function canContinue() : Boolean
        {
            if (this.vStatus != "Matchmake")
            {
                return false;
            }
            if (stage == null)
            {
                return false;
            }
            return true;
        }// end function

        private function prepareBot() : void
        {
            var _loc_1:* = GBL_Bot.TYPE_TRAINER;
            if (Global.vServer.vUser.vTrophy > GBL_Bot.vTrophyLimit)
            {
                _loc_1 = GBL_Bot.TYPE_BOT;
            }
            this.vBot = new GBL_Bot(_loc_1);
            this.vBot.vFirstShootCoef = 0.9;
            this.vGame.activateDemoSolo(false);
            this.vGame.vInterface.initInfos();
            this.vGame.vInterface.hideCharInfoButton();
            this.vGame.activateGlobs();
            this.vGame.initPseudos("", "");
            this.vGame.vInterface.hideTimer();
            return;
        }// end function

        private function restartRound(param1:Boolean = true) : void
        {
            if (!this.canContinue())
            {
                return;
            }
            if (param1)
            {
                this.vGame.restartRound(this.nextRound);
            }
            else
            {
                this.vGame.restartRound(this.noFun);
            }
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        private function nextRound() : void
        {
            if (!this.canContinue())
            {
                return;
            }
            this.vGame.nextRound(this.askOrders);
            return;
        }// end function

        private function askOrders(param1:int = 0) : void
        {
            if (!this.canContinue())
            {
                return;
            }
            this.vGame.askOrders(this.onOrdersPlayed);
            return;
        }// end function

        private function onOrdersPlayed(param1:String) : void
        {
            if (!this.canContinue())
            {
                return;
            }
            this.vPlayerOrders = param1;
            this.vPlayerOrders = this.vPlayerOrders + ("_" + this.vBot.getOrders(this.vGame));
            this.vGame.startResolution(this.vPlayerOrders, this.afterResolution);
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            var _loc_2:* = null;
            if (!this.canContinue())
            {
                return;
            }
            if (param1 == this.vGame.vCurTeam)
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_confetti"], 8, 0, 240, 90, 0.5, true, 1, 0.1, 0.25, 4, -4, 5, -2, 0.98, "normal", true, true);
            }
            else if (param1 == 3 - this.vGame.vCurTeam)
            {
            }
            if (param1 == 0)
            {
                this.nextRound();
            }
            else
            {
                TweenMax.delayedCall(2.5, this.restartRound);
            }
            return;
        }// end function

        private function startFake() : void
        {
            if (this.canContinue())
            {
                this.vStatus = "Fake";
                this.vGame.layerInfos.visible = false;
                this.vGame.layerInterface.visible = false;
                this.vGame.layerPlayers.visible = false;
                this.vGame.layerSocle.visible = false;
                Global.vServer.stopMatchmake();
                if (Global.vGame != null)
                {
                    Global.vGame.destroy();
                    Global.vGame = null;
                }
                Global.vServer.createFakeGame(this.onFakePlayerReady);
            }
            return;
        }// end function

        private function onFakePlayerReady(param1:Boolean) : void
        {
            if (!param1)
            {
                this.backToMenu();
                return;
            }
            return;
        }// end function

    }
}
