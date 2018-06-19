package menu.game
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import gbl.*;
    import gbl.infos.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class PlayOnline extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vStatus:String = "";
        private var vSendReadyDone:Boolean = false;
        private var vMsgBoxDisconnected:Boolean = false;
        private var vGameArgs:Object;
        private var vTimeLaunchSpent:Number = 0;
        private var vNbRoundInSuddenDeath:int = 0;
        private var vLastSendOrderRound:int;
        private var vLastSendOrderOrders:String;
        private var vLastSendOrderOrdersFake:String;
        private var vSendOrderTries:int;
        private var vFakeBotDelay:int = -1;
        private var vWholeOrdersReceived:Boolean = false;
        private var vCheckLeaverRunning:Boolean = false;
        private var vCheckLeaverDelayArg:int = 0;
        private var vCheckLeaverTime0:int;
        private var vCheckLeaverDelay:int = 0;
        private var vCheckLeaverNbDone:int = 0;
        private var vCheckLeaverNbFail:int = 0;
        private var vWinner:int = 0;
        private var vLastScore:int;
        private var vGameJoinRound:int;
        private var vJoiningLastScore:int = 0;
        private var vCanQuit:Boolean = true;
        private var vRewardData:Object;
        private var vRewardDataSave:Object;
        private var vRewardShown:Boolean = false;
        public static var vSeat:int = 0;
        public static var showMessageTrainingDone:Boolean = false;
        public static var vMatchToJoin:String = "";

        public function PlayOnline()
        {
            vTag = "PlayOnline";
            Global.vHitPoints = true;
            GBL_Main.vGameJoining = false;
            Global.vSound.stopMusic();
            Global.vStats.Stats_PageView("PlayOnline");
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            var _loc_2:* = null;
            return;
        }// end function

        public function addTrace(param1:String) : void
        {
            Global.addLogTrace("[Game] " + param1);
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
            this.addTrace("new GBL_Main");
            this.vStatus = "Init";
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            this.vGame.setCurTeam(1);
            this.vGame.init(this.onGameReady);
            this.initCheckLeaver();
            if (Global.vLogInfo)
            {
                addButton(this.vGame.layerInterface, new bitmapClip(this.vGame.vImages["button_info"]), new Point((-Global.vSize.x) / 2 + 30, Global.vSize.y / 2 - 30), this.showTrace);
            }
            return;
        }// end function

        private function onGameReady() : void
        {
            this.addTrace("onGameReady");
            this.vStatus = "Playing";
            this.vGame.showGameBG();
            Global.vServer.initMatch(this.onServerInfo);
            Global.addLogTrace("onGameReady vSeat=" + vSeat + " vMatchToJoin=" + vMatchToJoin, "PlayOnline");
            if (vSeat == 0)
            {
                if (vMatchToJoin != "")
                {
                    Global.vServer.gameJoin(this.onGameJoin, vMatchToJoin);
                }
                else
                {
                    Global.vRoot.restartApp("PlayOnline vSeat=0");
                }
            }
            else
            {
                this.vGame.setCurTeam(vSeat);
                Global.addLogTrace("onGameReady vStatus=" + this.vStatus);
                this.vStatus = "ReadySent";
                TweenMax.delayedCall(10, this.onGameReadyTimeout);
                this.sendReady();
            }
            if (showMessageTrainingDone)
            {
                showMessageTrainingDone = false;
                TweenMax.delayedCall(0.3, this.showTrainingDone);
            }
            this.vGame.vInterface.addQuit(this.onButtonQuitGame);
            return;
        }// end function

        private function sendReady() : void
        {
            if (this.vSendReadyDone)
            {
                Global.vStats.Stats_Error("vSendReadyDone=true userId=" + Global.vServer.vUser.vUserId + " vMatchId=" + Global.vServer.vMatchId + " vStatus:" + this.vStatus + " vOpponentId=" + Global.vServer.vOpponentId);
                return;
            }
            this.vSendReadyDone = true;
            this.addTrace("sendReady");
            Global.vServer.sendReady(this.onSendReady);
            return;
        }// end function

        private function onSendReady(param1:Boolean) : void
        {
            Global.addLogTrace("onSendReady pSuccess=" + param1);
            return;
        }// end function

        private function onGameReadyTimeout() : void
        {
            Global.addLogTrace("onGameReadyTimeout vStatus=" + this.vStatus);
            if (this.vStatus != "Running" && this.vStatus != "Quit")
            {
                Global.addLogTrace("PlayOnline : Match not started");
                Global.vRoot.goMainMenu();
            }
            return;
        }// end function

        private function showTrainingDone() : void
        {
            new MsgBox(Global.vRoot, Global.getText("txtMatchmakeTrainingDone"), null, 1, null, "", 1, 3);
            return;
        }// end function

        private function onMatchmakeInfo(param1:String) : void
        {
            this.addTrace("[Matchmake] " + param1);
            return;
        }// end function

        private function onServerInfo(param1:String, param2:Object = null) : void
        {
            Global.addLogTrace("PlayOnline.onServerInfo:" + param1, "PlayOnline");
            if (!stage)
            {
                return;
            }
            if (param1 != "Trace")
            {
                this.addTrace("onServerInfo:" + param1);
            }
            if (param1 == "onGameCancelled")
            {
                Global.vServer.killGame("onGameCancelled");
                this.backToMenu();
                return;
            }
            if (this.vGame == null)
            {
                return;
            }
            if (param1 == "Trace")
            {
                this.addTrace("[Server] Trace=" + param2.trace);
            }
            else if (param1 == "MatchFound")
            {
                this.vStatus = "MatchFound";
            }
            else if (param1 == "onSeatChange")
            {
            }
            else if (param1 == "onGameCancelled")
            {
                Global.vServer.killGame("onGameCancelled");
                this.backToMenu();
            }
            else if (param1 == "onOpponentLeft")
            {
                if (this.vGame.isStarted)
                {
                    this.onForfeitOpponent(param2.reward);
                }
                else
                {
                    Global.vRoot.goMainMenu();
                }
            }
            else if (param1 == "onGameStart")
            {
                this.onGameStart(param2);
            }
            else if (param1 == "onOrders")
            {
                if (param2.lastOrder1 != null && param2.lastOrder2 != null)
                {
                    this.calcTimeLaunchSpent(param2.lastOrder1, param2.lastOrder2);
                }
                this.onWholeOrdersReceived(param2.round, param2.orders, param2.reward);
            }
            else if (param1 == "onFatalError")
            {
                this.onFatalError(param2.message);
            }
            else if (param1 == "ChatMsg")
            {
                if (this.vGame != null)
                {
                    if (this.vGame.vInterface != null)
                    {
                        this.vGame.vInterface.onChatMessage(param2.senderId, parseInt(param2.chatMsg));
                    }
                }
            }
            else if (param1 == "GameAlreadyFinished")
            {
                Global.vGeneralMessageLastLoad = 0;
                Global.addLogTrace("GameAlreadyFinished > cancelled");
                if (param2 != null)
                {
                    if (param2.reward != null)
                    {
                        this.showRewards(param2.reward);
                        return;
                    }
                }
                if (this.vGame != null)
                {
                    Global.vServer.killGame("GameAlreadyFinished");
                }
                this.showMsgBoxDisconnected();
            }
            else
            {
                Global.onError("onServerInfo unknown info : " + param1);
            }
            return;
        }// end function

        private function reconnectWhenGameAlreadyFinished() : void
        {
            this.backToMenu();
            return;
        }// end function

        private function onFatalError(param1:String) : void
        {
            Global.vServer.killGame("onFatalError");
            new MsgBox(Global.vRoot.vMenu, param1);
            return;
        }// end function

        private function showMsgBoxDisconnected() : void
        {
            if (this.vMsgBoxDisconnected)
            {
                return;
            }
            this.vMsgBoxDisconnected = true;
            Global.vServer.killGame("showMsgBoxDisconnected");
            Global.addLogTrace("showMsgBoxDisconnected > txtDisconnected");
            new MsgBox(this, Global.getText("txtDisconnected"), this.reconnectWhenGameAlreadyFinished);
            return;
        }// end function

        private function afterMsgBoxDisconnected() : void
        {
            this.vMsgBoxDisconnected = false;
            this.reconnectWhenGameAlreadyFinished();
            return;
        }// end function

        private function onGameStart(param1:Object, param2:Boolean = false) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            Toolz.traceObject(param1, "onGameStart");
            this.vGameArgs = param1;
            this.addTrace("onGameStart id=" + this.vGameArgs._id);
            this.vStatus = "Running";
            this.vGame.removeInfoBox();
            Global.addLogTrace("vGameArgs:" + JSON.stringify(this.vGameArgs), "PlayOnline");
            var _loc_5:* = 0;
            while (_loc_5 < 2)
            {
                
                _loc_3 = new GBL_Team();
                _loc_4 = JSON.stringify(this.vGameArgs["team" + (_loc_5 + 1)]);
                _loc_3.parseTeam((_loc_5 + 1), _loc_4);
                this.vGame.addTeam(_loc_5, _loc_3);
                _loc_5++;
            }
            GBL_Main.parseDataSuddenDeath(this.vGameArgs.suddendeath);
            GBL_Main.parseDataHitPoints(this.vGameArgs.hitpoints);
            var _loc_6:* = Global.vWeather;
            GBL_Main.parseWeather(this.vGameArgs.weather);
            if (_loc_6 != Global.vWeather)
            {
                this.onNewWeather();
                return;
            }
            this.vGame.onGameStart(param2);
            this.vGame.prepareTeams(this.onTeamsReady);
            this.vGame.startTimebank();
            return;
        }// end function

        private function onNewWeather() : void
        {
            var _loc_1:* = new mcToBitmapQueue();
            this.vGame.vTerrain.rasterizeTerrainGraf(_loc_1);
            _loc_1.startConversion(this.onNewTerrainReady);
            return;
        }// end function

        private function onNewTerrainReady() : void
        {
            this.vGame.vTerrain.reinitBG();
            this.vGame.onGameStart();
            this.vGame.prepareTeams(this.onTeamsReady);
            this.vGame.startTimebank();
            return;
        }// end function

        private function onTeamsReady() : void
        {
            var _loc_1:* = 0;
            this.vGame.showTeams();
            if (this.vGameArgs.team1.startTrophies != null)
            {
                this.vGame.initPseudos(this.vGameArgs.name1, this.vGameArgs.name2, this.vGameArgs.team1.startTrophies, this.vGameArgs.team2.startTrophies);
            }
            else
            {
                this.vGame.initPseudos(this.vGameArgs.name1, this.vGameArgs.name2);
            }
            this.vGame.vInterface.showBoosters();
            this.vGame.vInterface.showChatMessages();
            if (GBL_Main.vGameJoining)
            {
                _loc_1 = Global.vServer.getTimeFrom(parseInt(this.vGameArgs.time_start) / 1000);
                this.vGame.vInterface.startTimer(_loc_1);
            }
            else
            {
                this.vGame.vInterface.startTimer();
            }
            if (GBL_Main.vGameJoining)
            {
                this.vGame.hideAllGlobs();
                this.gameJoinReadOrders();
                return;
            }
            this.vGame.restartRound(this.nextRound);
            return;
        }// end function

        private function showInfo(event:Event) : void
        {
            if (this.vGame.vInterface != null)
            {
                this.vGame.vInterface.showCharsInfos();
            }
            return;
        }// end function

        private function nextRound() : void
        {
            this.addTrace("nextRound");
            this.vGame.nextRound(this.askOrders);
            return;
        }// end function

        private function askOrders(param1:int = 0) : void
        {
            var _loc_2:* = 0;
            this.addTrace("askOrders pWinner=" + param1 + " Round=" + this.vGame.vNbRound);
            if (this.vGame.vSuddenDeath && this.vGame.vSuddenDeathEffective && this.vGame.vSuddenDeathBothTeam)
            {
                _loc_2 = 0;
                var _loc_3:* = this;
                var _loc_4:* = this.vNbRoundInSuddenDeath + 1;
                _loc_3.vNbRoundInSuddenDeath = _loc_4;
                if (this.vGame.vInterface.vScore1 > this.vGame.vInterface.vScore2)
                {
                    _loc_2 = 1;
                }
                if (this.vGame.vInterface.vScore2 > this.vGame.vInterface.vScore1)
                {
                    _loc_2 = 2;
                }
                if (_loc_2 > 0)
                {
                    if (GBL_Main.isReverse)
                    {
                        _loc_2 = 3 - _loc_2;
                    }
                    if (this.vNbRoundInSuddenDeath == 1)
                    {
                        this.vGame.vSuddenDeathEffective = false;
                        this.vGame.vInterface.setTimerZero();
                    }
                    this.vGame.onGameEnd(_loc_2, 0.5);
                    TweenMax.delayedCall(3, this.sendGameoverAfterSuddenDeath);
                    return;
                }
            }
            Global.addLogTrace("askOrders vTimeLaunchSpent=" + this.vTimeLaunchSpent, "PlayOnline");
            this.vGame.vInterface.enableBoosters();
            this.vGame.askOrders(this.onOrdersPlayed, this.vTimeLaunchSpent);
            this.vTimeLaunchSpent = 0;
            return;
        }// end function

        private function sendGameoverAfterSuddenDeath() : void
        {
            this.sendOrdersToServer(this.vGame.vNbRound + this.vGame.vNbGoal, "gameover", 0);
            return;
        }// end function

        private function onOrdersPlayed(param1:String, param2:Number = -1) : void
        {
            this.addTrace("onOrdersPlayed pOrders=" + param1);
            this.addTrace("Round=" + this.vGame.vNbRound + " Goals=" + this.vGame.vNbGoal);
            this.vGame.showInfoBox(Global.getText("txtWaitingOpponent"));
            this.vGame.vInterface.disableBoosters();
            if (param2 < 0)
            {
                param2 = this.vGame.vInterface.getTimerLaunchLeft();
            }
            this.sendOrdersToServer(this.vGame.vNbRound + this.vGame.vNbGoal, param1, param2);
            return;
        }// end function

        private function sendOrdersToServer(param1:int, param2:String, param3:int = 0) : void
        {
            var _loc_4:* = NaN;
            var _loc_5:* = null;
            this.vWholeOrdersReceived = false;
            this.vCheckLeaverDelayArg = param3;
            this.vLastSendOrderRound = param1;
            this.vLastSendOrderOrders = param2;
            this.vSendOrderTries = 0;
            this.vLastSendOrderOrdersFake = "";
            if (Global.vServer.vFakeGame)
            {
                if (this.vLastSendOrderOrders == "goal:1" || this.vLastSendOrderOrders == "goal:2" || this.vLastSendOrderOrders == "gameover")
                {
                    this.vLastSendOrderOrdersFake = this.vLastSendOrderOrders;
                }
                else
                {
                    _loc_5 = new GBL_Bot(GBL_Bot.TYPE_FAKE, Global.vServer.getFakeSkill());
                    this.vLastSendOrderOrdersFake = _loc_5.getOrders(this.vGame);
                    this.vLastSendOrderOrdersFake = this.vLastSendOrderOrdersFake + "_timer,2,0";
                }
                if (this.vFakeBotDelay == -1)
                {
                    this.vFakeBotDelay = 3 + 7 * Math.random();
                    Global.addLogTrace("BotPlayDelay=" + this.vFakeBotDelay, "FakeBot");
                }
                _loc_4 = this.vFakeBotDelay + 4 * (Math.random() - 0.5);
                if (_loc_4 < 2)
                {
                    _loc_4 = 2;
                }
                _loc_4 = _loc_4 - (12 - this.vCheckLeaverDelayArg);
                if (_loc_4 <= 0)
                {
                    this.sendOrdersToServerDo();
                }
                else
                {
                    TweenMax.delayedCall(_loc_4, this.sendOrdersToServerDo);
                }
            }
            else
            {
                this.sendOrdersToServerDo();
            }
            return;
        }// end function

        private function sendOrdersToServerDo() : void
        {
            if (Global.vGame == null)
            {
                return;
            }
            var _loc_1:* = this;
            var _loc_2:* = this.vSendOrderTries + 1;
            _loc_1.vSendOrderTries = _loc_2;
            Global.addLogTrace("sendOrdersToServerDo vSendOrderTries=" + this.vSendOrderTries);
            Global.addLogTrace("InstantPos=" + Global.vGame.buildInstantPos());
            Global.vServer.sendOrders(this.onOrdersSent, this.vLastSendOrderRound, this.vLastSendOrderOrders, this.vLastSendOrderOrdersFake);
            return;
        }// end function

        private function onOrdersSent(param1:Boolean, param2:Boolean = false) : void
        {
            var _loc_3:* = 0;
            Global.addLogTrace("onOrdersSent pSuccess=" + param1 + " pNeedSynchro=" + param2);
            if (param2)
            {
                this.needSynchro();
                return;
            }
            if (param1)
            {
                if (!this.vWholeOrdersReceived)
                {
                    _loc_3 = this.vCheckLeaverDelayArg;
                    this.vCheckLeaverDelayArg = 0;
                    this.startCheckLeaver(_loc_3);
                }
            }
            else
            {
                Global.addLogTrace("Error during send order vSendOrderTries=" + this.vSendOrderTries);
                if (this.vSendOrderTries == 6)
                {
                    if (Global.vServer.vFocusActivate)
                    {
                        Global.vRoot.restartApp("FailRetry 6");
                    }
                    else
                    {
                        this.restartAppAfterFailRetry();
                    }
                }
                else
                {
                    if (this.vSendOrderTries == 3)
                    {
                        this.vGame.showInfoBox(Global.getText("txtOnConnectionLost"));
                    }
                    if (Global.vGame == null)
                    {
                        return;
                    }
                    this.sendOrdersToServerDo();
                }
            }
            return;
        }// end function

        private function restartAppAfterFailRetry() : void
        {
            Global.vRoot.restartApp("SendOrder Fail Retry(" + this.vSendOrderTries + ")");
            return;
        }// end function

        private function onWholeOrdersReceived(param1:int, param2:String, param3:Object = null) : void
        {
            var _loc_4:* = 0;
            this.addTrace("onWholeOrdersReceived pRound=" + param1 + " pOrders=" + param2);
            if (param2 != "gameover" && param1 != this.vGame.vNbRound + this.vGame.vNbGoal)
            {
                this.needSynchro();
                return;
            }
            this.vWholeOrdersReceived = true;
            this.vGame.cancelAskOrders();
            this.vGame.removeInfoBox();
            this.stopCheckLeaver();
            if (this.vWinner == 0)
            {
                if (this.vGame.vInterface.vScore1 >= 2)
                {
                    this.vWinner = 1;
                }
                if (this.vGame.vInterface.vScore2 >= 2)
                {
                    this.vWinner = 2;
                }
            }
            if (param2.substr(0, 4) == "goal")
            {
                if (this.vWinner > 0)
                {
                    this.sendOrdersToServer(this.vGame.vNbRound + this.vGame.vNbGoal + 1, "gameover");
                    return;
                }
                if (this.vGame.vSuddenDeath && this.vGame.vSuddenDeathEffective && this.vGame.vSuddenDeathBothTeam)
                {
                    _loc_4 = 0;
                    var _loc_5:* = this;
                    var _loc_6:* = this.vNbRoundInSuddenDeath + 1;
                    _loc_5.vNbRoundInSuddenDeath = _loc_6;
                    if (this.vGame.vInterface.vScore1 > this.vGame.vInterface.vScore2)
                    {
                        _loc_4 = 1;
                    }
                    if (this.vGame.vInterface.vScore2 > this.vGame.vInterface.vScore1)
                    {
                        _loc_4 = 2;
                    }
                    if (_loc_4 > 0)
                    {
                        Global.addLogTrace("vNbRoundInSuddenDeath=" + this.vNbRoundInSuddenDeath);
                        if (this.vNbRoundInSuddenDeath == 1)
                        {
                            this.vGame.vSuddenDeathEffective = false;
                            this.vGame.vInterface.setTimerZero();
                        }
                        if (GBL_Main.isReverse)
                        {
                            _loc_4 = 3 - _loc_4;
                        }
                        this.vGame.onGameEnd(_loc_4);
                        TweenMax.delayedCall(3, this.sendGameOverAfterWinDuringSuddentDeath);
                        return;
                    }
                }
                if (this.vGame.vInterface.vScore1 >= 2 || this.vGame.vInterface.vScore2 >= 2)
                {
                    Global.addLogTrace("onWholeOrdersReceived Score 2 !");
                    this.nextRound();
                }
                else
                {
                    this.vGame.restartRound(this.nextRound);
                }
            }
            else if (param2 == "gameover")
            {
                this.showRewards(param3);
            }
            else
            {
                this.vGame.startResolution(param2, this.afterResolution);
            }
            return;
        }// end function

        private function sendGameOverAfterWinDuringSuddentDeath() : void
        {
            this.sendOrdersToServer(this.vGame.vNbRound + this.vGame.vNbGoal + 1, "gameover");
            return;
        }// end function

        private function needSynchro() : void
        {
            this.vGame.stopRunning();
            this.endCheckLeaver();
            Matchmaking.vSynchroOnly = true;
            Global.vRoot.launchMenu(Matchmaking);
            return;
        }// end function

        private function initCheckLeaver() : void
        {
            Global.addLogTrace("initCheckLeaver");
            this.vCheckLeaverRunning = false;
            this.addEventListener(Event.ENTER_FRAME, this.onFrameCheckLeaver);
            return;
        }// end function

        private function onFrameCheckLeaver(event:Event) : void
        {
            if (!this.vCheckLeaverRunning)
            {
                return;
            }
            if (!stage)
            {
                return;
            }
            if (this.vCheckLeaverDelay > 0)
            {
                if (getTimer() - this.vCheckLeaverTime0 > 1000 * this.vCheckLeaverDelay)
                {
                    if (this.stage == null)
                    {
                        this.removeEventListener(Event.ENTER_FRAME, this.onFrameCheckLeaver);
                        return;
                    }
                    this.vCheckLeaverDelay = 0;
                    Global.addLogTrace("vServer.checkLeaver (After starting delay))");
                    this.vCheckLeaverRunning = false;
                    Global.addLogTrace("CHECK LEAVER FIRST");
                    Global.vServer.checkLeaver(this.onCheckLeaverResult);
                }
                return;
            }
            var _loc_2:* = GBL_Main.vTimeoutLeaver;
            if (getTimer() - this.vCheckLeaverTime0 > 1000 * _loc_2)
            {
                if (this.stage == null)
                {
                    this.removeEventListener(Event.ENTER_FRAME, this.onFrameCheckLeaver);
                    return;
                }
                Global.addLogTrace("vServer.checkLeaver (Client Timeout)");
                this.vCheckLeaverRunning = false;
                Global.addLogTrace("CHECK LEAVER FOLLOWING");
                Global.vServer.checkLeaver(this.onCheckLeaverResult);
            }
            return;
        }// end function

        private function onCheckLeaverResult(param1:Boolean, param2:Object = null) : void
        {
            Global.addLogTrace("onCheckLeaverResult pReceived=" + param1 + " pLastOrder=" + param2);
            if (!stage)
            {
                return;
            }
            return;
        }// end function

        private function stopCheckLeaver() : void
        {
            this.vCheckLeaverRunning = false;
            this.vCheckLeaverDelay = 0;
            this.vCheckLeaverTime0 = getTimer();
            return;
        }// end function

        private function endCheckLeaver() : void
        {
            this.vCheckLeaverRunning = false;
            this.removeEventListener(Event.ENTER_FRAME, this.onFrameCheckLeaver);
            return;
        }// end function

        private function startCheckLeaver(param1:Number) : void
        {
            Global.addLogTrace("startCheckLeaver pDelayCheckLeaver=" + param1);
            if (this.vGame == null)
            {
                return;
            }
            if (this.vGame.vStopped)
            {
                return;
            }
            var _loc_2:* = 4;
            this.vCheckLeaverNbDone = 0;
            this.vCheckLeaverNbFail = 0;
            this.vTimeLaunchSpent = 0;
            this.restartCheckLeaver();
            this.vCheckLeaverDelay = param1 + _loc_2;
            return;
        }// end function

        private function restartCheckLeaver() : void
        {
            this.vCheckLeaverRunning = true;
            this.vCheckLeaverDelay = 0;
            this.vCheckLeaverTime0 = getTimer();
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            var _loc_2:* = null;
            this.addTrace("afterResolution pScored=" + param1 + " vGame.vSuddenDeath=" + this.vGame.vSuddenDeath);
            this.vGame.removeInfoBox();
            this.stopCheckLeaver();
            this.vLastScore = param1;
            if (Global.vServer.vFakeGame)
            {
                Global.vGame.vInterface.fakeChat();
            }
            if (this.vGame.vInterface.vScore1 == GBL_Main.vSuddenDeathGoals)
            {
                this.vWinner = 1;
            }
            if (this.vGame.vInterface.vScore2 == GBL_Main.vSuddenDeathGoals)
            {
                this.vWinner = 2;
            }
            if (param1 == Global.vServer.vSeat)
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_confetti"], 8, 0, 240, 90, 0.5, true, 1, 0.1, 0.25, 4, -4, 5, -2, 0.98, "normal", true, true);
                TweenMax.delayedCall(1, this.launchParticles, [true]);
                TweenMax.delayedCall(3, this.afterGoal);
            }
            else if (param1 == 3 - Global.vServer.vSeat)
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_smoke"], 8, 0, 120, 90, 0.5, true, 1.5, 0.5, 0.1, 4, -4, 5, -2, 0.98, "normal", true, true);
                TweenMax.delayedCall(1, this.launchParticles, [false]);
                TweenMax.delayedCall(3, this.afterGoal);
            }
            else if (param1 == 3)
            {
                new MsgBox(this, Global.getText("MsgGameScoreTie"), this.afterGoal, MsgBox.TYPE_SimpleText, null, "", 1, 3);
            }
            else
            {
                this.nextRound();
            }
            if (this.vWinner > 0)
            {
                if (GBL_Main.isReverse)
                {
                    this.vWinner = 3 - this.vWinner;
                }
                this.vGame.onGameEnd(this.vWinner);
            }
            return;
        }// end function

        private function launchParticles(param1:Boolean) : void
        {
            if (param1)
            {
                Global.vSound.firework();
                Global.startParticles(Global.vRoot.layerPopup, Global.ConvertPoint(208, 40, this.vGame.layerPlayers, this), Global.vImages["particle_confetti"], 5, 0, 30, 60, 0.25, true, 1, 0.1, 0.1, 10, -10, 10, -10, 0.98, "normal", true, false);
            }
            else
            {
                Global.startParticles(Global.vRoot.layerPopup, Global.ConvertPoint(208, -40, this.vGame.layerPlayers, this), Global.vImages["particle_smoke"], 30, 0, 30, 60, 0.5, true, 1, 0.1, 0, 8, -8, 8, -8, 1, "normal", true, false);
            }
            return;
        }// end function

        private function afterGoal() : void
        {
            this.addTrace("afterGoal vWinner=" + this.vWinner);
            var _loc_1:* = this.vGame;
            var _loc_2:* = _loc_1.vNbGoal + 1;
            _loc_1.vNbGoal = _loc_2;
            this.sendOrdersToServer(_loc_1.vNbRound + _loc_1.vNbGoal, "goal:" + this.vLastScore);
            this.startCheckLeaver(0);
            return;
        }// end function

        private function backToMenu() : void
        {
            this.addTrace("backToMenu");
            this.endCheckLeaver();
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function onGameJoin(param1:Boolean, param2:Object = null) : void
        {
            if (!param1)
            {
                Global.addLogTrace("onGameJoin Error:" + JSON.stringify(param2), "PlayOnline");
                Global.vRoot.goMainMenu();
                return;
            }
            Toolz.traceObject(param2, "onGameJoin:pData");
            GBL_Main.vGameJoining = true;
            vSeat = Global.vServer.getSeatOnMatchJoined(param2._id, param2.player1, param2.player2);
            if (vSeat == 0)
            {
                Global.addLogTrace("gameJoining not in game : " + Global.vServer.vUser.vUserId + " / " + param2.player1 + " / " + param2.player2);
                Global.vRoot.goMainMenu();
                return;
            }
            this.vGame.setCurTeam(vSeat);
            this.onGameStart(param2, true);
            return;
        }// end function

        private function gameJoinReadOrders() : void
        {
            Global.addLogTrace("----- gameJoinReadOrders -----");
            this.vGameJoinRound = -1;
            this.vGame.restartRound(this.gameJoinNextRound);
            return;
        }// end function

        private function gameJoinNextRound() : void
        {
            Global.addLogTrace("gameJoinNextRound vGame.vNbRound=" + this.vGame.vNbRound);
            this.vGame.nextRound(this.gameJoinNextOrder);
            return;
        }// end function

        private function gameJoinNextOrder(param1:int = 0) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = false;
            var _loc_5:* = this;
            var _loc_6:* = this.vGameJoinRound + 1;
            _loc_5.vGameJoinRound = _loc_6;
            Global.addLogTrace("gameJoinNextOrder vGame.vNbRound=" + this.vGame.vNbRound + " vGameArgs.orders.length=" + this.vGameArgs.orders.length);
            if (this.vGameJoinRound == this.vGameArgs.orders.length)
            {
                this.gameJoinDoneNeedOrders();
            }
            else
            {
                _loc_2 = this.vGameArgs.orders[this.vGameJoinRound];
                Toolz.traceObject(_loc_2, "orders round " + this.vGameJoinRound);
                if (_loc_2.seat1 == null)
                {
                    if (vSeat == 1)
                    {
                        this.gameJoinDoneNeedOrders();
                    }
                    else if (vSeat == 2)
                    {
                        this.gameJoinDoneCheckLeaver();
                    }
                }
                else if (_loc_2.seat2 == null)
                {
                    if (vSeat == 2)
                    {
                        this.gameJoinDoneNeedOrders();
                    }
                    else if (vSeat == 1)
                    {
                        this.gameJoinDoneCheckLeaver();
                    }
                }
                else if (_loc_2.seat1.split(":")[0] == "goal")
                {
                    this.afterResolutionJoining(0);
                }
                else
                {
                    _loc_3 = _loc_2.seat1 + "_" + _loc_2.seat2;
                    _loc_4 = true;
                    if (this.getTimerLeft(_loc_2.seat1) != 0)
                    {
                        _loc_4 = false;
                    }
                    if (this.getTimerLeft(_loc_2.seat2) != 0)
                    {
                        _loc_4 = false;
                    }
                    if (_loc_4)
                    {
                        this.vGame.vSuddenDeath = true;
                    }
                    this.vGame.startResolution(_loc_3, this.afterResolutionJoining, true);
                }
            }
            return;
        }// end function

        private function getTimerLeft(param1:String) : int
        {
            var _loc_4:* = null;
            var _loc_2:* = param1.split("_");
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = _loc_2[_loc_3].split(",");
                if (_loc_4[0] == "timer")
                {
                    return _loc_4[2];
                }
                _loc_3++;
            }
            return -1;
        }// end function

        private function afterResolutionJoining(param1:int) : void
        {
            Global.addLogTrace("afterResolutionJoining pScored=" + param1 + " vGame.vNbRound=" + this.vGame.vNbRound + " vGameArgs.orders.length=" + this.vGameArgs.orders.length);
            if (param1 > 0)
            {
                if (this.vGame.vNbRound >= (this.vGameArgs.orders.length - 1))
                {
                    Global.addLogTrace("afterResolutionJoining - End of Joining");
                    this.vJoiningLastScore = param1;
                    this.gameJoinNextRound();
                }
                else
                {
                    Global.addLogTrace("afterResolutionJoining - Restart Round");
                    this.vJoiningLastScore = 0;
                    this.vGame.restartRound(this.gameJoinNextRound);
                }
                return;
            }
            this.gameJoinNextRound();
            return;
        }// end function

        private function gameJoinDone() : void
        {
            GBL_Main.vGameJoining = false;
            if (this.vGameArgs.fake == 1)
            {
                Global.vServer.vFakeGame = true;
                Global.vServer.vFakeData = new Object();
                Global.vServer.vFakeData.Id = this.vGameArgs.player2;
                this.vGame.vInterface.initFakeChat(false);
            }
            this.calcTimeLaunchSpent(this.vGameArgs.lastOrder1, this.vGameArgs.lastOrder2);
            this.vGame.showAllGlobsAlive();
            return;
        }// end function

        private function calcTimeLaunchSpent(param1:String, param2:String) : void
        {
            var _loc_3:* = Global.vServer.getTimeFrom(parseInt(param1) / 1000);
            var _loc_4:* = Global.vServer.getTimeFrom(parseInt(param2) / 1000);
            Global.addLogTrace("lTimeLast1=" + _loc_3, "PlayOnline");
            Global.addLogTrace("lTimeLast2=" + _loc_4, "PlayOnline");
            if (_loc_4 < _loc_3)
            {
                this.vTimeLaunchSpent = _loc_4;
            }
            else
            {
                this.vTimeLaunchSpent = _loc_3;
            }
            Global.addLogTrace("calcTimeLaunchSpent vTimeLaunchSpent=" + this.vTimeLaunchSpent, "PlayOnline");
            this.vTimeLaunchSpent = this.vTimeLaunchSpent - 4;
            if (this.vTimeLaunchSpent < 0)
            {
                this.vTimeLaunchSpent = 0;
            }
            return;
        }// end function

        private function gameJoinDoneNeedOrders() : void
        {
            var _loc_3:* = null;
            Global.addLogTrace("gameJoin Done : NeedOrders", "PlayOnline");
            this.gameJoinDone();
            var _loc_1:* = this.vGame.buildOrders();
            Global.addLogTrace("vJoiningLastScore=" + this.vJoiningLastScore);
            if (this.vJoiningLastScore > 0)
            {
                _loc_1 = "goal:" + this.vJoiningLastScore;
            }
            var _loc_2:* = this.vGameArgs.orders[this.vGameJoinRound];
            if (_loc_2 != null)
            {
                _loc_3 = _loc_2["seat" + (3 - this.vGame.vCurTeam)];
                if (_loc_3 == "gameover")
                {
                    _loc_1 = _loc_3;
                }
                else if (_loc_3.split(":")[0] == "goal")
                {
                    _loc_1 = _loc_3;
                }
            }
            this.onOrdersPlayed(_loc_1, GBL_Main.vTimerDuration);
            return;
        }// end function

        private function gameJoinDoneCheckLeaver() : void
        {
            Global.addLogTrace("gameJoin Done : CheckLeaver", "PlayOnline");
            this.gameJoinDone();
            this.vGame.showInfoBox(Global.getText("txtWaitingOpponent"));
            this.startCheckLeaver(0);
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
            }
            else
            {
                if (this.vStatus == "Matchfound")
                {
                    return;
                }
                if (this.vWinner == 0)
                {
                    new MsgBox(this, Global.getText("txtForfeitConfirm"), this.onForfeitConfirm, MsgBox.TYPE_YesNo);
                }
            }
            return;
        }// end function

        private function onForfeitConfirm(param1:Boolean) : void
        {
            if (param1)
            {
                this.addTrace("onForfeitConfirm");
                if (!this.vCanQuit)
                {
                    return;
                }
                this.vStatus = "Quit";
                this.vCanQuit = false;
                this.vWinner = 3 - Global.vServer.vSeat;
                this.vGame.stopRunning();
                Global.vServer.forfeitMatch(this.afterForfeit);
            }
            return;
        }// end function

        private function afterForfeit(param1:Object) : void
        {
            var _loc_2:* = 3 - vSeat;
            this.vGame.onGameEnd(_loc_2, 0);
            this.showRewards(param1.reward);
            return;
        }// end function

        private function onForfeitOpponent(param1:Object) : void
        {
            this.endCheckLeaver();
            this.vWinner = Global.vServer.vSeat;
            this.vGame.stopRunning();
            this.vGame.onGameEnd(this.vWinner);
            var _loc_2:* = Global.getText("txtForfeitOpponent");
            if (param1.statusScore1 == "forfeit" || param1.statusScore2 == "forfeit")
            {
                _loc_2 = Global.getText("txtEndGameOpponentForfeit");
            }
            if (param1.statusScore1 == "leaver" || param1.statusScore2 == "leaver")
            {
                _loc_2 = Global.getText("txtEndGameOpponentLeaver");
            }
            new MsgBox(this, _loc_2, this.afterForfeitOpponent, MsgBox.TYPE_SimpleText, {rewardData:param1});
            return;
        }// end function

        private function afterForfeitOpponent(param1:Object) : void
        {
            this.vRewardDataSave = param1.rewardData;
            var _loc_2:* = 1;
            if (GBL_Main.isReverse)
            {
                _loc_2 = 2;
            }
            this.vGame.onGameEndAnim(_loc_2);
            TweenMax.delayedCall(1, this.rewardAfterForfeit);
            return;
        }// end function

        private function rewardAfterForfeit() : void
        {
            this.showRewards(this.vRewardDataSave);
            return;
        }// end function

        private function showRewards(param1:Object = null) : void
        {
            var _loc_2:* = undefined;
            Global.addLogTrace("showRewards:" + JSON.stringify(param1));
            this.endCheckLeaver();
            if (this.vRewardData != null)
            {
                return;
            }
            if (param1 == null)
            {
                return;
            }
            this.vRewardData = param1;
            if (this.vRewardShown)
            {
                return;
            }
            this.vRewardShown = true;
            if (this.vGameArgs == null)
            {
                this.backToMenu();
                return;
            }
            this.vRewardData.name1 = this.vGameArgs.name1;
            this.vRewardData.name2 = this.vGameArgs.name2;
            this.vRewardData.vScore1 = this.vGame.vInterface.vScore1;
            this.vRewardData.vScore2 = this.vGame.vInterface.vScore2;
            this.vRewardDataSave = new Object();
            for (_loc_2 in this.vRewardData)
            {
                
                this.vRewardDataSave[_loc_2] = _loc_4[_loc_2];
            }
            TweenMax.delayedCall(0.5, this.showRewardPopup);
            return;
        }// end function

        private function showRewardPopup() : void
        {
            new RewardPopup(this, this.vRewardDataSave, this.backToMenu);
            return;
        }// end function

    }
}
