package menu.game
{
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import tools.*;

    public class BotOffline extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vDebugLoad:String = "";
        private var vDebugLoadTab:Array;

        public function BotOffline()
        {
            Global.vSound.stopMusic();
            this.vDebugLoad = "20¤{\'player1\':{\'code\':\'PA_011\',\'vitality\':0,\'name\':\'Lorenzo\',\'force\':0,\'category\':\'A\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':1},\'boosters\':[],\'player2\':{\'code\':\'PA_010\',\'vitality\':0,\'name\':\'Olivio\',\'force\':0,\'category\':\'A\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':1},\'player3\':{\'code\':\'PA_012\',\'vitality\':0,\'name\':\'Jereminho\',\'force\':1,\'category\':\'A\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':0},\'shirt\':\'SA_001\'}¤{\'shirt\':\'SC_011\',\'boosters\':[],\'player2\':{\'code\':\'PA_013\',\'vitality\':0,\'name\':\'Fabinho\',\'force\':1,\'category\':\'A\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':5},\'player3\':{\'code\':\'PB_004\',\'vitality\':3,\'name\':\'Cesar\',\'force\':4,\'category\':\'B\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':3},\'player1\':{\'code\':\'PC_002\',\'vitality\':2,\'name\':\'Razbero\',\'force\':4,\'category\':\'C\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':7}}¤200.46,350.82,0,0,2_-6.36,-309.17,0,1,0_-189.85,-100.71,0,1,0_-16.72,-1.06,0,0,1_13.56,-388.04,1,1,0_-45.17,-389.24,1,0,4_155.08,-357.37,0,0,3";
            this.vDebugLoad = "-20¤{\'startTrophies\':169,\'player1\':{\'vitality\':0,\'name\':\'Fabinho\',\'force\':1,\'code\':\'PA_013\',\'infos\':{\'ArrowSum\':1600,\'Kill\':0,\'KO\':2},\'speed\':0,\'category\':\'A\'},\'player2\':{\'vitality\':1,\'name\':\'Moncado\',\'force\':0,\'code\':\'PA_014\',\'infos\':{\'ArrowSum\':1190,\'Kill\':1,\'KO\':1},\'speed\':0,\'category\':\'A\'},\'boosters\':[\'BA\'],\'player3\':{\'vitality\':0,\'name\':\'Lorenzo\',\'force\':0,\'code\':\'PA_011\',\'infos\':{\'ArrowSum\':1724,\'Kill\':0,\'KO\':2},\'speed\':1,\'category\':\'A\'},\'shirt\':\'SA_003\'}¤{\'startTrophies\':586,\'player1\':{\'vitality\':0,\'name\':\'Fabinho\',\'force\':1,\'code\':\'PA_013\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':5,\'category\':\'A\'},\'player2\':{\'vitality\':5,\'name\':\'Moncado\',\'force\':1,\'code\':\'PA_014\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':0,\'category\':\'A\'},\'boosters\':[],\'player3\':{\'vitality\':0,\'name\':\'Jereminho\',\'force\':5,\'code\':\'PA_012\',\'infos\':{\'ArrowSum\':0,\'Kill\':0,\'KO\':0},\'speed\':1,\'category\':\'A\'},\'shirt\':\'SA_005\'}¤32.97,265.48,0,1,0_-15.36,378.09,1,0,1_97.64,350.56,0,0,1_33.56,42.04,0,0,2_140.44,224.96,0,0,2_80.6,195.87,0,0,2_94.29,163.23,0,0,3";
            this.vDebugLoad = "-20¤{\'player2\':{\'category\':\'A\',\'force\':0,\'name\':\'Moncado\',\'code\':\'PA_014\',\'infos\':{\'ArrowSum\':1190,\'KO\':1,\'Kill\':1},\'speed\':0,\'vitality\':1},\'player1\':{\'category\':\'A\',\'force\':1,\'name\':\'Fabinho\',\'code\':\'PA_013\',\'infos\':{\'ArrowSum\':1600,\'KO\':2,\'Kill\':0},\'speed\':0,\'vitality\':0},\'player3\':{\'category\':\'A\',\'force\':0,\'name\':\'Lorenzo\',\'code\':\'PA_011\',\'infos\':{\'ArrowSum\':1724,\'KO\':2,\'Kill\':0},\'speed\':1,\'vitality\':0},\'shirt\':\'SA_003\',\'startTrophies\':169,\'boosters\':[\'BA\']}¤{\'player2\':{\'category\':\'A\',\'force\':1,\'name\':\'Moncado\',\'code\':\'PA_014\',\'infos\':{\'ArrowSum\':0,\'KO\':0,\'Kill\':0},\'speed\':0,\'vitality\':5},\'boosters\':[],\'player3\':{\'category\':\'A\',\'force\':5,\'name\':\'Jereminho\',\'code\':\'PA_012\',\'infos\':{\'ArrowSum\':0,\'KO\':0,\'Kill\':0},\'speed\':1,\'vitality\':0},\'shirt\':\'SA_005\',\'startTrophies\':586,\'player1\':{\'category\':\'A\',\'force\':1,\'name\':\'Fabinho\',\'code\':\'PA_013\',\'infos\':{\'ArrowSum\':0,\'KO\':0,\'Kill\':0},\'speed\':5,\'vitality\':0}}¤32.97,265.48,0,1,0_-15.36,378.09,1,0,1_97.64,350.56,0,0,1_33.56,42.04,0,0,2_140.44,224.96,0,0,2_80.6,195.87,0,0,2_94.29,163.23,0,0,3";
            this.vDebugLoad = "-20¤{\'player3\':{\'code\':\'PA_011\',\'force\':0,\'name\':\'Lorenzo\',\'infos\':{\'Kill\':0,\'KO\':3,\'ArrowSum\':1741},\'category\':\'A\',\'speed\':1,\'vitality\':0},\'shirt\':\'SA_002\',\'startTrophies\':165,\'player2\':{\'code\':\'PA_010\',\'force\':0,\'name\':\'Olivio\',\'infos\':{\'Kill\':1,\'KO\':3,\'ArrowSum\':1220},\'category\':\'A\',\'speed\':1,\'vitality\':0},\'player1\':{\'code\':\'PA_015\',\'force\':0,\'name\':\'Alessandro\',\'infos\':{\'Kill\':0,\'KO\':3,\'ArrowSum\':1563},\'category\':\'A\',\'speed\':0,\'vitality\':1},\'boosters\':[\'BA\']}¤{\'player3\':{\'code\':\'PA_012\',\'force\':5,\'name\':\'Jereminho\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'category\':\'A\',\'speed\':1,\'vitality\':0},\'shirt\':\'SA_003\',\'startTrophies\':595,\'player2\':{\'code\':\'PA_014\',\'force\':1,\'name\':\'Moncado\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'category\':\'A\',\'speed\':0,\'vitality\':5},\'player1\':{\'code\':\'PA_013\',\'force\':1,\'name\':\'Fabinho\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'category\':\'A\',\'speed\':5,\'vitality\':0},\'boosters\':[]}¤162.79,-80.13,0,0,1_4.61,-377.22,1,1,0_-0.27,-247.95,0,0,1_-72.19,-299.19,0,0,1_22.65,-376.85,1,0,0_126.66,-236.75,0,1,0_202.06,-210.55,0,0,3";
            this.vDebugLoad = "20¤{\'boosters\':[\'BA\'],\'player2\':{\'name\':\'Olivio\',\'vitality\':0,\'code\':\'PA_010\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':1,\'force\':0},\'shirt\':\'SA_001\',\'player1\':{\'name\':\'Alessandro\',\'vitality\':1,\'code\':\'PA_015\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':0,\'force\':0},\'player3\':{\'name\':\'Lorenzo\',\'vitality\':0,\'code\':\'PA_011\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':1,\'force\':0}}¤{\'player3\':{\'name\':\'Carlo\',\'vitality\':1,\'code\':\'PA_003\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':1,\'force\':1},\'player2\':{\'name\':\'Paulo\',\'vitality\':1,\'code\':\'PA_004\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':0,\'force\':1},\'shirt\':\'SA_002\',\'player1\':{\'name\':\'Olivio\',\'vitality\':0,\'code\':\'PA_010\',\'category\':\'A\',\'infos\':{\'Kill\':0,\'KO\':0,\'ArrowSum\':0},\'speed\':1,\'force\':0},\'boosters\':[]}¤-140.61,351.95,0,0,2_-36.69,214.34,0,0,2_-106.77,276.11,0,0,3_-49.36,329.4,0,0,2_26.59,89.8,0,0,3_134.96,259.18,0,0,3_95.26,104.94,0,0,3";
            if (this.vDebugLoad != "")
            {
                this.vDebugLoad = this.vDebugLoad.split("\'").join("\"");
                this.vDebugLoadTab = this.vDebugLoad.split("¤");
                GBL_Main.vWeatherCoef = parseInt(this.vDebugLoadTab[0]);
            }
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            if (GBL_Main.vWeatherCoef < 0)
            {
                Global.vWeather = 2;
            }
            else if (GBL_Main.vWeatherCoef > 0)
            {
                Global.vWeather = 3;
            }
            else
            {
                Global.vWeather = 1;
            }
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            this.vGame.setCurTeam(1);
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            this.vGame.showGameBG();
            _loc_2 = {boosters:["BA"], shirt:"SA_011", player1:{code:"PA_013", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:1, speed:0, vitality:0, name:"Fabinho"}, player2:{code:"PA_011", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:1, speed:0, vitality:0, name:"Alberto"}, player3:{code:"PA_004", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:0, speed:0, vitality:0, name:"Paulo"}};
            _loc_1 = new GBL_Team();
            if (this.vDebugLoad != "")
            {
                _loc_1.parseTeam(1, this.vDebugLoadTab[1]);
            }
            else
            {
                _loc_1.parseTeam(1, JSON.stringify(_loc_2));
            }
            this.vGame.addTeam(0, _loc_1);
            _loc_2 = {boosters:["BA"], shirt:"SC_016", player1:{code:"PA_005", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:1, speed:0, vitality:0, name:"Fabinho"}, player2:{code:"PA_006", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:1, speed:0, vitality:0, name:"Alberto"}, player3:{code:"PA_007", infos:{Kill:0, ArrowSum:0, KO:0}, category:"A", force:0, speed:0, vitality:0, name:"Paulo"}};
            _loc_1 = new GBL_Team();
            if (this.vDebugLoad != "")
            {
                _loc_1.parseTeam(2, this.vDebugLoadTab[2]);
            }
            else
            {
                _loc_1.parseTeam(2, JSON.stringify(_loc_2));
            }
            this.vGame.addTeam(1, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.vGame.showTeams();
            this.vGame.initPseudos("Player", "Bot");
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
            if (this.vDebugLoad != "")
            {
                this.vGame.loadInstantPos(this.vDebugLoadTab[3]);
            }
            this.vGame.askOrders(this.onOrdersPlayed);
            return;
        }// end function

        private function onOrdersPlayed(param1:String) : void
        {
            var _loc_2:* = new GBL_Bot(GBL_Bot.TYPE_FAKE);
            param1 = param1 + "_" + _loc_2.getOrders(this.vGame);
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
