package gbl.terrain
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import gbl.*;
    import gbl.perso.*;
    import globz.*;
    import sparks.*;

    public class TerrainXXX extends Object
    {
        public var vGame:GBL_Main;
        public var vScoreOnTeamDead:Boolean = true;
        public var vGlobs:Vector.<GBL_Glob>;
        public var vNbTeam:int = 2;
        public var vGlobsPerTeam:int = 3;
        private var vResetRoundCallback:Function;
        private var vTimeout1:Boolean = false;
        private var vTimeout2:Boolean = false;

        public function TerrainXXX(param1:GBL_Main)
        {
            this.vGame = param1;
            this.initGlobs();
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].destroyPersoGraf();
                _loc_1++;
            }
            return;
        }// end function

        private function initDebug() : void
        {
            if (Capabilities.isDebugger)
            {
                this.vGame.addEventListener(MouseEvent.MOUSE_DOWN, this.onDebugDown);
            }
            else
            {
                this.vGame.addEventListener(TouchEvent.TOUCH_BEGIN, this.onDebugDown);
            }
            return;
        }// end function

        private function onDebugDown(event:Event) : void
        {
            return;
        }// end function

        public function initDimensions() : void
        {
            return;
        }// end function

        public function getGoalRadius() : int
        {
            return 50;
        }// end function

        public function rasterizeTerrainGraf(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        public function updateSuddenDeath(param1:Boolean = false) : void
        {
            return;
        }// end function

        public function getPosInit(param1:int, param2:int) : Point
        {
            return new Point(0, 0);
        }// end function

        public function addSpecificGlob() : void
        {
            return;
        }// end function

        public function resetSpecificGlob() : void
        {
            return;
        }// end function

        public function checkWalls(param1:GBL_Glob) : void
        {
            return;
        }// end function

        public function checkWow(param1:GBL_Glob) : Boolean
        {
            return false;
        }// end function

        public function getWinner(param1:Vector.<GBL_Glob>) : int
        {
            return 0;
        }// end function

        public function getNbLeftInTeam(param1:Vector.<GBL_Glob>, param2:int) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (_loc_4 < param1.length)
            {
                
                if (param1[_loc_4].vTeam == param2)
                {
                    if (!param1[_loc_4].isKilled)
                    {
                        _loc_3++;
                    }
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function resetRoundSpecific(param1:Function, param2:Boolean = true) : void
        {
            param1.call();
            return;
        }// end function

        public function restartRoundSpecific() : void
        {
            return;
        }// end function

        public function beforeResolution() : void
        {
            return;
        }// end function

        public function afterResolution() : void
        {
            return;
        }// end function

        public function showOutlines() : void
        {
            return;
        }// end function

        public function hideOutlines() : void
        {
            return;
        }// end function

        public function initBG() : void
        {
            return;
        }// end function

        public function reinitBG() : void
        {
            return;
        }// end function

        private function initGlobs() : void
        {
            this.vGlobs = new Vector.<GBL_Glob>;
            return;
        }// end function

        public function prepareGlobs() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (this.vGame.vTeams.length != this.vNbTeam)
            {
                Global.onError("TerrainXXX.prepareGlobs vGame.vTeams.length=" + this.vGame.vTeams.length);
                return;
            }
            _loc_1 = 0;
            while (_loc_1 < this.vNbTeam)
            {
                
                if (this.vGame.vTeams[_loc_1].vGlobs.length < this.vGlobsPerTeam)
                {
                    Global.onError("TerrainXXX.prepareGlobs vGame.vTeams[" + _loc_1 + "].vGlobs.length=" + this.vGame.vTeams[_loc_1].vGlobs.length);
                    return;
                }
                _loc_2 = 0;
                while (_loc_2 < this.vGlobsPerTeam)
                {
                    
                    _loc_3 = this.vGame.vTeams[_loc_1].vGlobs[_loc_2].clone();
                    _loc_3.setGame(this.vGame);
                    this.addGlob(_loc_3, new Point(0, 0));
                    _loc_2++;
                }
                _loc_1++;
            }
            this.addSpecificGlob();
            return;
        }// end function

        public function initGlobsGraf() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                if (this.vGlobs[_loc_2].vPerso == null)
                {
                    _loc_1 = this.vGlobs[_loc_2].getPersoGraf(true);
                    this.vGame.layerPlayers.addChild(_loc_1);
                    this.vGame.layerSocle.addChild(_loc_1.getSocle());
                }
                if (this.vGlobs[_loc_2].vTeam == 1)
                {
                    this.vGlobs[_loc_2].setOrientation(-90);
                }
                if (this.vGlobs[_loc_2].vTeam == 2)
                {
                    this.vGlobs[_loc_2].setOrientation(90);
                }
                _loc_2++;
            }
            this.refreshGlobs();
            return;
        }// end function

        public function refreshGlobs() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].refresh();
                _loc_1++;
            }
            return;
        }// end function

        public function refreshSpecific() : void
        {
            return;
        }// end function

        public function refreshZOrder() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = new Array();
            _loc_1 = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                _loc_3.push(this.vGlobs[_loc_1]);
                _loc_1++;
            }
            _loc_3 = _loc_3.sort(this.sortOnY);
            _loc_1 = 0;
            while (_loc_1 < _loc_3.length)
            {
                
                this.vGame.layerPlayers.setChildIndex(_loc_3[_loc_1].getPersoGraf(), (this.vGame.layerPlayers.numChildren - 1));
                _loc_1++;
            }
            return;
        }// end function

        private function sortOnY(param1:GBL_Glob, param2:GBL_Glob) : int
        {
            if (GBL_Main.isReverse)
            {
                if (param1.vPos.y < param2.vPos.y)
                {
                    return 1;
                }
                if (param1.vPos.y > param2.vPos.y)
                {
                    return -1;
                }
            }
            else
            {
                if (param1.vPos.y < param2.vPos.y)
                {
                    return -1;
                }
                if (param1.vPos.y > param2.vPos.y)
                {
                    return 1;
                }
            }
            return 0;
        }// end function

        public function restartRound(param1:Boolean = true) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_5:* = 0;
            Global.addLogTrace("restartRound");
            var _loc_4:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.vNbTeam)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.vGlobsPerTeam)
                {
                    
                    this.vGlobs[_loc_4].setPosInit(this.getPosInit(_loc_2, _loc_3));
                    this.vGlobs[_loc_2].vPerso.setVisible(true);
                    _loc_4++;
                    _loc_3++;
                }
                _loc_2++;
            }
            if (Global.vHitPoints)
            {
                if (this.vGame.vNbRound == 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < this.vGlobs.length)
                    {
                        
                        _loc_5 = this.vGlobs[_loc_2].vAttributeVitality;
                        this.vGlobs[_loc_2].setHitPoints(Sparks_Char.getHitPointsMax(_loc_5), Sparks_Char.getHitPointsRegen(_loc_5));
                        _loc_2++;
                    }
                }
            }
            this.restartRoundSpecific();
            this.resetSpecificGlob();
            this.refreshZOrder();
            if (param1)
            {
                Global.vSound.onPlayerAppear();
            }
            return;
        }// end function

        public function resetRound(param1:Function, param2:Boolean = true) : void
        {
            var _loc_3:* = 0;
            while (_loc_3 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_3].reset();
                _loc_3++;
            }
            this.hideOutlines();
            this.vResetRoundCallback = param1;
            if (Global.vHitPoints)
            {
                _loc_3 = 0;
                while (_loc_3 < this.vGlobs.length)
                {
                    
                    this.vGlobs[_loc_3].checkWound();
                    _loc_3++;
                }
            }
            this.resetRoundSpecific(this.afterResetRoundSpecific, param2);
            return;
        }// end function

        private function afterResetRoundSpecific() : void
        {
            this.vResetRoundCallback.call();
            return;
        }// end function

        public function addGlob(param1:GBL_Glob, param2:Point) : void
        {
            param1.vPos.x = param2.x;
            param1.vPos.y = param2.y;
            param1.vId = this.vGlobs.length;
            this.vGlobs.push(param1);
            return;
        }// end function

        public function getGlobInRange(param1:int, param2:Point) : GBL_Glob
        {
            var _loc_4:* = NaN;
            var _loc_5:* = null;
            var _loc_3:* = 1000000;
            var _loc_6:* = 0;
            while (_loc_6 < this.vGlobs.length)
            {
                
                if (this.vGame.isInTeam(this.vGlobs[_loc_6]))
                {
                    _loc_4 = Point.distance(this.vGlobs[_loc_6].getGrafPos(), param2);
                    if (_loc_4 < _loc_3)
                    {
                        _loc_3 = _loc_4;
                        _loc_5 = this.vGlobs[_loc_6];
                    }
                }
                _loc_6++;
            }
            if (_loc_3 > 40)
            {
                return null;
            }
            return _loc_5;
        }// end function

        public function parseOrders(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = param1.split("_");
            var _loc_5:* = new Point(0, 0);
            Global.addLogTrace("parseOrder:" + param1, "TerrainXXX");
            var _loc_6:* = 0;
            while (_loc_6 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_6].split(",");
                if (_loc_3[0] == "extra")
                {
                    this.vGame.onOrderExtra(_loc_3[1]);
                }
                else if (_loc_3[0] == "timer")
                {
                    if (_loc_3[2] == 0)
                    {
                        if (_loc_3[1] == 1)
                        {
                            this.vTimeout1 = true;
                        }
                        if (_loc_3[1] == 2)
                        {
                            this.vTimeout2 = true;
                        }
                    }
                    if (this.vTimeout1 && this.vTimeout2)
                    {
                        this.vGame.vSuddenDeathBothTeam = true;
                    }
                }
                else if (_loc_3[0] == "99")
                {
                }
                else
                {
                    _loc_4 = this.vGlobs[parseInt(_loc_3[0])];
                    _loc_5.x = GBL_Glob.unformatValue(_loc_3[1]);
                    _loc_5.y = GBL_Glob.unformatValue(_loc_3[2]);
                    _loc_4.addForce(_loc_5);
                    _loc_4.previewArrow(_loc_5);
                    if (_loc_4.vEnergyStats != null)
                    {
                        _loc_4.vEnergyStats.orders.push(_loc_5.length);
                        _loc_4.vEnergyStats.ordersTotal = _loc_4.vEnergyStats.ordersTotal + _loc_5.length / 90;
                        _loc_4.vEnergyStats.ordersNorm = _loc_4.vEnergyStats.ordersNorm + _loc_5.length / _loc_4.getArrowMax();
                    }
                }
                _loc_6++;
            }
            return;
        }// end function

        public function getSynchro() : String
        {
            var _loc_2:* = null;
            var _loc_1:* = "";
            var _loc_3:* = 0;
            while (_loc_3 < this.vGlobs.length)
            {
                
                _loc_2 = this.vGlobs[_loc_3];
                if (_loc_3 > 0)
                {
                    _loc_1 = _loc_1 + "_";
                }
                _loc_1 = _loc_1 + _loc_2.vPos.x + "," + _loc_2.vPos.y + "," + _loc_2.vHP + ",";
                if (_loc_2.isKilled)
                {
                    _loc_1 = _loc_1 + "0";
                }
                else
                {
                    _loc_1 = _loc_1 + "1";
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

        public function animWinner(param1:int) : void
        {
            if (param1 > 0)
            {
            }
            var _loc_2:* = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                if (this.vGlobs[_loc_2].vPerso != null)
                {
                    if (param1 == 1)
                    {
                        if (this.vGlobs[_loc_2].vTeam == 1 && !this.vGlobs[_loc_2].isKilled)
                        {
                            GBL_Perso_Puppet(this.vGlobs[_loc_2].vPerso).anim("win", -1, _loc_2 * 4);
                        }
                        if (this.vGlobs[_loc_2].vTeam == 2 && !this.vGlobs[_loc_2].isKilled)
                        {
                            GBL_Perso_Puppet(this.vGlobs[_loc_2].vPerso).anim("lose", -1, _loc_2 * 4);
                        }
                    }
                    else if (param1 == 2)
                    {
                        if (this.vGlobs[_loc_2].vTeam == 1 && !this.vGlobs[_loc_2].isKilled)
                        {
                            GBL_Perso_Puppet(this.vGlobs[_loc_2].vPerso).anim("lose", -1, _loc_2 * 4);
                        }
                        if (this.vGlobs[_loc_2].vTeam == 2 && !this.vGlobs[_loc_2].isKilled)
                        {
                            GBL_Perso_Puppet(this.vGlobs[_loc_2].vPerso).anim("win", -1, _loc_2 * 4);
                        }
                    }
                }
                _loc_2++;
            }
            if (Global.vServer == null)
            {
                Global.vSound.onGoalWon();
            }
            else if (Global.vServer.vSeat == param1 || Global.vServer.vSeat == 0)
            {
                Global.vSound.onGoalWon();
            }
            else
            {
                Global.vSound.onGoalLost();
            }
            return;
        }// end function

    }
}
