package gbl
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class GBL_Resolution extends MovieClip
    {
        private var vGame:GBL_Main;
        private var vTimeLast:int;
        private var vTimeStart:int;
        private var vGlobs:Vector.<GBL_Glob>;
        private var vCallback:Function;
        private var vRunning:Boolean = true;
        private var vCompute:GBL_Compute;
        private var vWinner:int;
        private var vDurationPreview:Number = 0.1;
        private var vDurationRun:Number = 1;
        private var vPause:Boolean = false;
        private var vPauseTime0:int;
        public static var vSpeedCoef:Number = 1;

        public function GBL_Resolution(param1:GBL_Main)
        {
            this.vGame = param1;
            return;
        }// end function

        public function start(param1:String, param2:Function, param3:Boolean = false) : void
        {
            this.vCallback = param2;
            this.vGlobs = this.vGame.vTerrain.vGlobs;
            this.vWinner = 0;
            this.vDurationPreview = GBL_Main.vResolutionShowOrders;
            this.vDurationRun = GBL_Main.vResolutionShowMoves;
            this.vCompute = new GBL_Compute(this.vGame, this.vGlobs, param1);
            this.vGame.vTerrain.parseOrders(param1);
            if (param3)
            {
                this.instantRun();
            }
            else
            {
                TweenMax.delayedCall(this.vDurationPreview / vSpeedCoef, this.startRun);
            }
            return;
        }// end function

        private function instantRun() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].hideArrow();
                _loc_1++;
            }
            this.vCompute.initResolution();
            this.vGame.vTerrain.beforeResolution();
            var _loc_2:* = this.vCompute.getEvents(1);
            _loc_1 = 0;
            while (_loc_1 < _loc_2.length)
            {
                
                this.executeEvent(_loc_2[_loc_1], true);
                _loc_1++;
            }
            var _loc_3:* = this.vCompute.getPosAtPercentTime(1);
            _loc_1 = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                if (!this.vGlobs[_loc_1].isKilled)
                {
                    this.vGlobs[_loc_1].vPos.x = _loc_3.pos[_loc_1].x;
                    this.vGlobs[_loc_1].vPos.y = _loc_3.pos[_loc_1].y;
                    this.vGlobs[_loc_1].setOrientation(_loc_3.orientation[_loc_1]);
                    this.vGlobs[_loc_1].compress(_loc_3.compress[_loc_1].x, _loc_3.compress[_loc_1].y);
                    this.vGlobs[_loc_1].refresh();
                }
                else
                {
                    this.vGlobs[_loc_1].vPos.x = _loc_3.pos[_loc_1].x;
                    this.vGlobs[_loc_1].vPos.y = _loc_3.pos[_loc_1].y;
                    this.vGlobs[_loc_1].refresh();
                }
                _loc_1++;
            }
            this.vGame.vTerrain.refreshZOrder();
            this.vGame.vTerrain.refreshSpecific();
            this.vRunning = false;
            this.endResolution();
            return;
        }// end function

        private function startRun() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].hideArrow();
                _loc_1++;
            }
            this.vTimeStart = getTimer();
            this.vCompute.initResolution();
            this.vGame.vTerrain.beforeResolution();
            addEventListener(Event.ENTER_FRAME, this.onFrame);
            return;
        }// end function

        public function stopRunning() : void
        {
            this.vRunning = false;
            return;
        }// end function

        public function changeSpeedCoef(param1:Number) : void
        {
            var _loc_2:* = (getTimer() - this.vTimeStart) / 1000 / (this.vDurationRun / vSpeedCoef);
            if (_loc_2 >= 1)
            {
                _loc_2 = 1;
            }
            vSpeedCoef = param1;
            this.vTimeStart = getTimer() - 1000 * _loc_2 * (this.vDurationRun / vSpeedCoef);
            return;
        }// end function

        public function togglePause() : void
        {
            if (!this.vPause)
            {
                this.vPauseTime0 = getTimer();
                this.vPause = true;
                TweenMax.pauseAll();
            }
            else
            {
                this.vTimeStart = this.vTimeStart + (getTimer() - this.vPauseTime0);
                this.vPause = false;
                TweenMax.resumeAll();
            }
            return;
        }// end function

        private function onFrame(event:Event = null) : void
        {
            var _loc_2:* = 0;
            var _loc_5:* = null;
            Global.addEventTrace("GBL_Resolution.destroy");
            if (this.vPause)
            {
                return;
            }
            if (!this.vRunning)
            {
                return;
            }
            var _loc_3:* = (getTimer() - this.vTimeStart) / 1000 / (this.vDurationRun / vSpeedCoef);
            if (_loc_3 >= 1)
            {
                _loc_3 = 1;
            }
            else if (_loc_3 <= 0)
            {
                _loc_3 = 0;
            }
            var _loc_4:* = this.vCompute.getEvents(_loc_3);
            _loc_2 = 0;
            while (_loc_2 < _loc_4.length)
            {
                
                this.executeEvent(_loc_4[_loc_2]);
                _loc_2++;
            }
            if (this.vWinner == 0)
            {
                _loc_5 = this.vCompute.getPosAtPercentTime(_loc_3);
                _loc_2 = 0;
                while (_loc_2 < this.vGlobs.length)
                {
                    
                    if (!this.vGlobs[_loc_2].isKilled)
                    {
                        this.vGlobs[_loc_2].vPos.x = _loc_5.pos[_loc_2].x;
                        this.vGlobs[_loc_2].vPos.y = _loc_5.pos[_loc_2].y;
                        this.vGlobs[_loc_2].setOrientation(_loc_5.orientation[_loc_2]);
                        this.vGlobs[_loc_2].compress(_loc_5.compress[_loc_2].x, _loc_5.compress[_loc_2].y);
                        this.vGlobs[_loc_2].refresh();
                    }
                    else
                    {
                        this.vGlobs[_loc_2].vPos.x = _loc_5.pos[_loc_2].x;
                        this.vGlobs[_loc_2].vPos.y = _loc_5.pos[_loc_2].y;
                        this.vGlobs[_loc_2].refresh();
                    }
                    _loc_2++;
                }
                this.vGame.vTerrain.refreshZOrder();
                this.vGame.vTerrain.refreshSpecific();
            }
            else
            {
                _loc_3 = 1;
            }
            if (_loc_3 == 1)
            {
                this.vRunning = false;
                this.endResolution();
            }
            return;
        }// end function

        private function executeEvent(param1:Object, param2:Boolean = false) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            if (param1.type == "impact")
            {
                if (param2)
                {
                    return;
                }
                this.vGame.addImpact(param1.args.x, param1.args.y, param1.args.num);
            }
            else if (param1.type == "setHP")
            {
                this.vGlobs[param1.args.id].vHP = param1.args.hp;
                Global.addLogTrace("executeEvents pEvent.args.id=" + param1.args.id + " pEvent.args.hp=" + param1.args.hp);
                this.vGlobs[param1.args.id].refreshHP();
            }
            else if (param1.type == "killed")
            {
                _loc_4 = this.vGlobs[param1.args.id].vPos.clone();
                if (GBL_Main.isReverse)
                {
                    _loc_4.x = _loc_4.x * -1;
                    _loc_4.y = _loc_4.y * -1;
                }
                if (this.vGlobs[param1.args.id].vTeam == 3)
                {
                    if (!param2)
                    {
                        Global.startParticles(this.vGame.layerPlayers, _loc_4, Global.vImages["particle_line_1"], 12, 0, 12, 30 / GBL_Resolution.vSpeedCoef, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 1, "add", true, false);
                    }
                }
                else
                {
                    if (!param2)
                    {
                        if (this.vGlobs[param1.args.id].vTeam == this.vGame.vCurTeam)
                        {
                            Global.startParticles(this.vGame.layerPlayers, _loc_4, Global.vImages["particle_smoke"], 8, 0, 8, 60 / GBL_Resolution.vSpeedCoef, 1, true, 1, 0, 0, 2, -2, 2, -2, 0.98, "normal", true, true);
                            Global.vSound.onPlayerFall();
                        }
                        else
                        {
                            Global.startParticles(this.vGame.layerPlayers, _loc_4, Global.vImages["particle_confetti"], 16, 0, 16, 60 / GBL_Resolution.vSpeedCoef, 1, true, 1, 0, 0, 4, -4, 4, -4, 0.98, "normal", true, true);
                            Global.vSound.onPlayerFall();
                            Global.vSound.firework();
                        }
                    }
                    var _loc_7:* = this.vGlobs[param1.args.id].vEnergyStats;
                    var _loc_8:* = _loc_7.nbKilled + 1;
                    _loc_7.nbKilled = _loc_8;
                }
                this.vGlobs[param1.args.id].kill(param2);
            }
            else if (param1.type == "winner")
            {
                if (!param2)
                {
                    this.vGame.vTerrain.animWinner(param1.args.winner);
                }
                this.vWinner = param1.args.winner;
            }
            else if (param1.type == "soundImpact")
            {
                if (param2)
                {
                    return;
                }
                Global.vSound.onImpact(param1.args.coef);
            }
            else if (param1.type == "soundImpactSoft")
            {
                if (param2)
                {
                    return;
                }
                Global.vSound.onImpactSoft(param1.args.coef);
            }
            else if (param1.type == "soundWall")
            {
                if (param2)
                {
                    return;
                }
                Global.vSound.onImpactWall(param1.args.coef);
            }
            else if (param1.type == "soundBall")
            {
                if (param2)
                {
                    return;
                }
                Global.vSound.onHitBall(param1.args.coef);
                _loc_5 = new Point(param1.args.x, param1.args.y);
                if (GBL_Main.isReverse)
                {
                    _loc_5.x = -_loc_5.x;
                    _loc_5.y = -_loc_5.y;
                }
                Global.startParticles(this.vGame.layerPlayers, _loc_5, Global.vImages["particle_grass"], 6, 0, 6, 60 / GBL_Resolution.vSpeedCoef, 1, true, 1, 0, 0, 2, -2, 2, -2, 0.98, "normal", true, true);
            }
            else if (param1.type == "booster")
            {
                if (param2)
                {
                    return;
                }
                _loc_6 = param1.args.team;
                this.vGame.vInterface.showBoosterUsed(_loc_6, param1.args.num);
            }
            else if (param1.type == "soundWow")
            {
                if (param2)
                {
                    return;
                }
                Global.vSound.onGoalLost();
                ;
            }
            return;
        }// end function

        private function endResolution() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onFrame);
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].unCompress();
                _loc_1++;
            }
            this.vGame.vTerrain.afterResolution();
            this.vCallback.call(0, this.vWinner);
            return;
        }// end function

    }
}
