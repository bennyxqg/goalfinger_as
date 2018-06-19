package menu.game
{
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class Training extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vStatus:String = "";
        private var vStatsTimer:int = 0;
        private var vCanQuit:Boolean = true;
        private var vBotStarted:Boolean = false;
        private var vBot:GBL_Bot;
        private var vBotRetry:int = 0;
        private var vPlayerOrders:String;
        public static var vPrivatePass:String = "";

        public function Training()
        {
            vTag = "Training";
            Global.vSound.stopMusic();
            Global.vSound.aroundGame();
            Global.vStats.Stats_PageView("Training");
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
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
            this.vStatus = "Init";
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            this.vGame.activateDemoSolo();
            this.vGame.setCurTeam(1);
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = "{\"shirt\":\"SA_001\",\"player1\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Roberto\",\"code\":\"PA_001\",\"vitality\":0},\"player3\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Sergio\",\"code\":\"PA_002\",\"vitality\":0},\"player2\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Cartlo\",\"code\":\"PA_003\",\"vitality\":0}}";
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(1, _loc_2);
            this.vGame.addTeam(1, _loc_1);
            var _loc_3:* = "{\"shirt\":\"SA_002\",\"player1\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Paulo\",\"code\":\"PA_004\",\"vitality\":0},\"player3\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Alberto\",\"code\":\"PA_005\",\"vitality\":0},\"player2\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Carlo\",\"code\":\"PA_006\",\"vitality\":0}}";
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(2, _loc_3);
            this.vGame.addTeam(2, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.vStatus = "Playing";
            this.startGame();
            this.vGame.vInterface.addQuit(this.onButtonQuitGame);
            this.vStatsTimer = getTimer();
            this.doStats("Start");
            return;
        }// end function

        private function doStats(param1:String) : void
        {
            var _loc_2:* = Math.round((getTimer() - this.vStatsTimer) / 1000);
            this.vStatsTimer = getTimer();
            Global.vStats.Stats_Event("Training", param1, "Timer", _loc_2);
            return;
        }// end function

        private function onButtonQuitGame(event:Event = null) : void
        {
            Global.vSound.onButton();
            Global.addLogTrace("backToMenu");
            Global.vRoot.restartAfterCantConnect();
            return;
        }// end function

        private function startGame() : void
        {
            this.vGame.showGameBG();
            TweenMax.from(this.vGame, 0.3, {alpha:0});
            TweenMax.delayedCall(0.6, this.launchBot);
            return;
        }// end function

        private function launchBot() : void
        {
            Global.vHitPoints = false;
            this.vGame.vTerrain.initDimensions();
            this.vGame.vTerrain.initGlobsGraf();
            this.prepareBot();
            this.restartRound();
            this.vBotStarted = true;
            return;
        }// end function

        private function prepareBot() : void
        {
            var _loc_1:* = GBL_Bot.TYPE_TRAINER;
            if (Global.vServer.vUser != null)
            {
                if (Global.vServer.vUser.vTrophy > GBL_Bot.vTrophyLimit)
                {
                    _loc_1 = GBL_Bot.TYPE_BOT;
                }
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
            this.vGame.nextRound(this.askOrders);
            return;
        }// end function

        private function askOrders(param1:int = 0) : void
        {
            this.vGame.askOrders(this.onOrdersPlayed);
            return;
        }// end function

        private function onOrdersPlayed(param1:String) : void
        {
            this.vPlayerOrders = param1;
            this.vPlayerOrders = this.vPlayerOrders + ("_" + this.vBot.getOrders(this.vGame));
            this.vGame.startResolution(this.vPlayerOrders, this.afterResolution);
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            var _loc_2:* = null;
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

    }
}
