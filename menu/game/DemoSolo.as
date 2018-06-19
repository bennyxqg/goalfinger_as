package menu.game
{
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class DemoSolo extends MenuXXX
    {
        private var vGame:GBL_Main;

        public function DemoSolo()
        {
            Global.vSound.stopMusic();
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            Global.vPseudo = "Demo Solo";
            this.vGame.activateDemoSolo();
            this.vGame.setCurTeam(1);
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            this.vGame.showGameBG();
            var _loc_2:* = Global.vServer.vUser.getTeamDesc();
            var _loc_3:* = 0;
            while (_loc_3 < 2)
            {
                
                _loc_1 = new GBL_Team();
                _loc_1.parseTeam((_loc_3 + 1), _loc_2);
                this.vGame.addTeam(_loc_3, _loc_1);
                _loc_3++;
            }
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.vGame.showTeams();
            this.vGame.initPseudos(Global.vServer.vDisplayName, Global.vServer.vDisplayName);
            this.vGame.vInterface.addQuit(this.quitDemo);
            this.vGame.vInterface.startTimer();
            this.vGame.vInterface.showChatMessages();
            this.vGame.vInterface.showBoosters();
            this.vGame.onGameStart();
            this.vGame.restartRound(this.nextRound);
            return;
        }// end function

        private function quitDemo(event:Event) : void
        {
            this.vGame.destroy();
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function restartRound() : void
        {
            this.vGame.restartRound(this.nextRound);
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
            this.vGame.startResolution(param1, this.afterResolution);
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            var _loc_2:* = null;
            if (param1 == 1)
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_confetti"], 8, 0, 240, 90, 0.5, true, 1, 0.1, 0.25, 4, -4, 5, -2, 0.98, "normal", true, true);
                TweenMax.delayedCall(2, this.launchParticles, [true]);
                TweenMax.delayedCall(4, this.restartRound);
            }
            else if (param1 == 2)
            {
                _loc_2 = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
                Global.startParticles(this, new Rectangle(_loc_2.x - Global.vSize.x * 0.4, _loc_2.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_smoke"], 8, 0, 120, 90, 0.5, true, 1.5, 0.5, 0.1, 4, -4, 5, -2, 0.98, "normal", true, true);
                TweenMax.delayedCall(2, this.launchParticles, [false]);
                TweenMax.delayedCall(4, this.restartRound);
            }
            else if (param1 == 3)
            {
                new MsgBox(this, Global.getText("MsgGameScoreTie"), this.restartRound);
            }
            else
            {
                this.nextRound();
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

    }
}
