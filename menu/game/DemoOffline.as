package menu.game
{
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class DemoOffline extends MenuXXX
    {
        private var vGame:GBL_Main;

        public function DemoOffline()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            vImages["button_quit"] = new mcToBitmapAS3(new MenuButton_Quit(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["button_info"] = new mcToBitmapAS3(new MenuButton_Info(), 0, Global.vResolution * 1, true, null, 0, param1);
            return;
        }// end function

        override protected function init() : void
        {
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            addButton(this, new bitmapClip(vImages["button_quit"]), new Point(610, 30), this.quitDemo, 1);
            addButton(this, new bitmapClip(vImages["button_info"]), new Point(30, 30), this.showInfo, 1);
            this.vGame.setCurTeam(1);
            if (Global.vDev)
            {
            }
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            this.vGame.showGameBG();
            var _loc_2:* = "{\"player1\":{\"speed\":0,\"vitality\":0,\"category\":\"A\",\"name\":\"Flavio\",\"force\":0,\"code\":\"PA_008\"},\"player2\":{\"speed\":0,\"vitality\":0,\"category\":\"A\",\"name\":\"Antonio\",\"force\":0,\"code\":\"PA_006\"},\"shirt\":\"SA_001\",\"player3\":{\"speed\":0,\"vitality\":0,\"category\":\"A\",\"name\":\"Alberto\",\"force\":0,\"code\":\"PA_005\"}}";
            if (Global.vDev)
            {
            }
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
            this.vGame.initPseudos("Player1", "Player2");
            this.vGame.vInterface.startTimer();
            this.vGame.restartRound(this.nextRound);
            return;
        }// end function

        private function showInfo(event:Event) : void
        {
            this.vGame.vInterface.showCharsInfos();
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
            if (param1 == this.vGame.vCurTeam)
            {
                Global.startParticles(Global.vRoot.layerPopup, Global.ConvertPoint(192, 40, this.vGame.layerInterface, Global.vRoot.layerPopup), Global.vImages["particle_confetti"], 20, 0, 60, 120, 0.5, true, 1, 0.1, 0.25, -3, 3, -9, -3, 1, "normal", true, true);
                TweenMax.delayedCall(1, this.restartRound);
            }
            else if (param1 == 3 - this.vGame.vCurTeam)
            {
                Global.startParticles(Global.vRoot.layerPopup, Global.ConvertPoint(192, -40, this.vGame.layerInterface, Global.vRoot.layerPopup), Global.vImages["particle_smoke"], 10, 0, 60, 120, 0.5, true, 1, 0.1, 0, -3, 3, -3, 3, 1, "normal", true, true);
                TweenMax.delayedCall(1, this.restartRound);
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

    }
}
