package gbl.terrain
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;

    public class Foot2 extends TerrainXXX
    {
        private var vBG:bitmapClip;
        private var vGrafGoalBot:bitmapClip;
        private var vGrafBlackBot:bitmapClip;
        private var vGrafGoalTop:bitmapClip;
        private var vGrafBlackTop:bitmapClip;
        private var vPosBall:Point;
        private var vBallOver:bitmapClip;
        private var vRadiusWidthInit:int = 216;
        private var vRadiusHeightInit:int = 370;
        private var vGoalWidthInit:int = 180;
        private var vGoalDeltaInsideInit:int = 20;
        private var vGoalDepthInit:int = 54;
        private var vRadiusWidth:int;
        private var vRadiusHeight:int;
        private var vGoalWidth:int;
        private var vGoalDeltaInside:int;
        private var vGoalDepth:int;
        private var vGoalNbStep:int = 0;

        public function Foot2(param1:GBL_Main)
        {
            this.vPosBall = new Point(0, 0);
            super(param1);
            this.initDimensions();
            return;
        }// end function

        override public function rasterizeTerrainGraf(param1:mcToBitmapQueue) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            _loc_2 = new MovieClip();
            _loc_3 = new Foot2_Under();
            _loc_3.mcGrass.gotoAndStop(Global.vWeather);
            _loc_2.addChild(_loc_3);
            vGame.vImages["terrain_under"] = new mcToBitmapAS3(_loc_2, 0, GBL_Main.vZoomCoef * Global.vResolution, true, null, 0, param1, 0, false);
            _loc_2 = new Foot2_GoalTop();
            vGame.vImages["terrain_goaltop"] = new mcToBitmapAS3(_loc_2, 0, GBL_Main.vZoomCoef * Global.vResolution, true, null, 0, param1, 0, false);
            _loc_2 = new Foot2_Bot_Black();
            vGame.vImages["terrain_blackbot"] = new mcToBitmapAS3(_loc_2, 0, GBL_Main.vZoomCoef * Global.vResolution, true, null, 0, param1, 0, false);
            _loc_2 = new Foot2_GoalBot();
            vGame.vImages["terrain_goalbot"] = new mcToBitmapAS3(_loc_2, 0, GBL_Main.vZoomCoef * Global.vResolution, true, null, 0, param1, 0, false);
            _loc_2 = new Foot2_Top_Black();
            vGame.vImages["terrain_blacktop"] = new mcToBitmapAS3(_loc_2, 0, GBL_Main.vZoomCoef * Global.vResolution, true, null, 0, param1, 0, false);
            vGame.vImages["glob_team3_pos0"] = new mcToBitmapAS3(new GameBall(), 0, Global.vResolution, true, null, 0, param1, 0, true);
            _loc_4 = new GrafFootBallOver();
            var _loc_5:* = GBL_Glob.BALL_SIZE_COEF;
            _loc_4.scaleY = GBL_Glob.BALL_SIZE_COEF;
            _loc_4.scaleX = _loc_5;
            _loc_2 = new MovieClip();
            _loc_2.addChild(_loc_4);
            vGame.vImages["ball_over"] = new mcToBitmapAS3(_loc_2, 0, Global.vResolution, true, null, 0, param1);
            return;
        }// end function

        private function tintShadow(param1:MovieClip) : MovieClip
        {
            var _loc_2:* = new ColorTransform();
            var _loc_3:* = 70;
            _loc_2.redOffset = -_loc_3;
            _loc_2.greenOffset = -_loc_3;
            _loc_2.blueOffset = -_loc_3;
            param1.transform.colorTransform = _loc_2;
            return param1;
        }// end function

        override public function initBG() : void
        {
            if (this.vBG != null)
            {
                return;
            }
            var _loc_1:* = new MsgboxBG();
            _loc_1.width = Global.vSize.x + 2 * Global.vScreenDelta.x / Global.vResolution;
            _loc_1.height = Global.vSize.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            _loc_1.alpha = 0;
            vGame.layerBG.addChild(_loc_1);
            this.vBG = new bitmapClip(vGame.vImages["terrain_under"]);
            vGame.layerBG.addChild(this.vBG);
            this.vGrafGoalBot = new bitmapClip(vGame.vImages["terrain_goalbot"]);
            vGame.layerFG.addChild(this.vGrafGoalBot);
            this.vGrafBlackBot = new bitmapClip(vGame.vImages["terrain_blackbot"]);
            vGame.layerBG.addChild(this.vGrafBlackBot);
            this.vGrafGoalTop = new bitmapClip(vGame.vImages["terrain_goaltop"]);
            vGame.layerBG.addChild(this.vGrafGoalTop);
            this.vGrafBlackTop = new bitmapClip(vGame.vImages["terrain_blacktop"]);
            vGame.layerBG.addChild(this.vGrafBlackTop);
            return;
        }// end function

        override public function reinitBG() : void
        {
            if (this.vBG != null)
            {
                vGame.layerBG.removeChild(this.vBG);
                this.vBG = null;
            }
            while (vGame.layerBG.numChildren > 0)
            {
                
                vGame.layerBG.removeChildAt(0);
            }
            while (vGame.layerFG.numChildren > 0)
            {
                
                vGame.layerFG.removeChildAt(0);
            }
            this.initBG();
            return;
        }// end function

        override public function getPosInit(param1:int, param2:int) : Point
        {
            var _loc_3:* = null;
            if (param2 == 0)
            {
                _loc_3 = new Point(0, 300);
            }
            else if (param2 == 1)
            {
                _loc_3 = new Point(-60, 330);
            }
            else if (param2 == 2)
            {
                _loc_3 = new Point(60, 330);
            }
            else
            {
                Global.onError("Foot2.getPosInit pPos=" + param2);
                _loc_3 = new Point(0, 0);
            }
            if (Global.vDev)
            {
            }
            if (param1 == 1)
            {
                _loc_3.x = -_loc_3.x;
                _loc_3.y = -_loc_3.y;
            }
            return _loc_3;
        }// end function

        override public function addSpecificGlob() : void
        {
            var _loc_1:* = new GBL_Glob(3);
            _loc_1.setGame(vGame);
            _loc_1.setRadius(_loc_1.vRadius * GBL_Glob.BALL_SIZE_COEF);
            if (Global.vDev)
            {
            }
            addGlob(_loc_1, this.vPosBall);
            this.vBallOver = new bitmapClip(vGame.vImages["ball_over"]);
            vGame.layerPlayers.addChild(this.vBallOver);
            this.vBallOver.visible = false;
            return;
        }// end function

        override public function resetSpecificGlob() : void
        {
            vGlobs[6].setPosInit(this.vPosBall);
            this.refreshSpecific();
            return;
        }// end function

        override public function getWinner(param1:Vector.<GBL_Glob>) : int
        {
            var _loc_2:* = param1[6];
            if (_loc_2.isKilled)
            {
                if (_loc_2.vPos.y < 0)
                {
                    return 1;
                }
                return 2;
            }
            if (!vScoreOnTeamDead)
            {
                return 0;
            }
            var _loc_3:* = getNbLeftInTeam(param1, 1);
            var _loc_4:* = getNbLeftInTeam(param1, 2);
            if (_loc_3 == 0 && _loc_4 == 0)
            {
                return 3;
            }
            if (_loc_3 == 0)
            {
                return 2;
            }
            if (_loc_4 == 0)
            {
                return 1;
            }
            return 0;
        }// end function

        override public function restartRoundSpecific() : void
        {
            return;
        }// end function

        override public function resetRoundSpecific(param1:Function, param2:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_6:* = NaN;
            if (GBL_Main.vGameJoining)
            {
                param2 = true;
            }
            var _loc_3:* = vGame.getGlob(3, 0).vPos.clone();
            var _loc_5:* = 0.3;
            if (param2)
            {
                _loc_5 = 0;
            }
            var _loc_7:* = 0;
            while (_loc_7 < vGlobs.length)
            {
                
                _loc_4 = vGlobs[_loc_7];
                if (_loc_4.vTeam != 3)
                {
                    _loc_6 = Math.atan2(_loc_3.y - _loc_4.vPos.y, _loc_3.x - _loc_4.vPos.x) * 180 / Math.PI;
                    if (GBL_Main.isReverse)
                    {
                        _loc_6 = _loc_6 + 180;
                    }
                    _loc_4.setOrientation(_loc_6, _loc_5);
                }
                _loc_7++;
            }
            if (param2)
            {
                param1.call();
            }
            else
            {
                TweenMax.delayedCall(_loc_5, param1);
            }
            return;
        }// end function

        override public function initDimensions() : void
        {
            this.vRadiusWidth = this.vRadiusWidthInit;
            this.vRadiusHeight = this.vRadiusHeightInit;
            this.vGoalWidth = this.vGoalWidthInit;
            this.vGoalDeltaInside = this.vGoalDeltaInsideInit;
            this.vGoalDepth = this.vGoalDepthInit;
            this.vGoalNbStep = 0;
            return;
        }// end function

        override public function getGoalRadius() : int
        {
            return this.vGoalWidth / 2;
        }// end function

        override public function updateSuddenDeath(param1:Boolean = false) : void
        {
            if (vGame.vNbRound <= 1)
            {
                param1 = true;
            }
            var _loc_3:* = this;
            var _loc_4:* = this.vGoalNbStep + 1;
            _loc_3.vGoalNbStep = _loc_4;
            this.vGoalWidth = this.vGoalWidthInit + this.vGoalNbStep * GBL_Main.vSuddenDeathInc;
            if (this.vGoalWidth > this.vRadiusWidth * 2 - 10)
            {
                this.vGoalWidth = this.vRadiusWidth * 2 + 4;
            }
            var _loc_2:* = this.vGoalNbStep;
            if (this.vGoalNbStep > 5)
            {
                this.vGoalNbStep = 5;
            }
            if (Global.vDev)
            {
            }
            this.vGrafGoalBot.gotoAndStop((_loc_2 + 1));
            this.vGrafBlackBot.gotoAndStop((_loc_2 + 1));
            this.vGrafGoalTop.gotoAndStop((_loc_2 + 1));
            this.vGrafBlackTop.gotoAndStop((_loc_2 + 1));
            return;
        }// end function

        private function setLineSize(param1:DisplayObject, param2:Number) : void
        {
            var _loc_3:* = param1.rotation;
            param1.rotation = 0;
            param1.width = param2;
            param1.rotation = _loc_3;
            param1.alpha = 0.7;
            return;
        }// end function

        override public function checkWalls(param1:GBL_Glob) : void
        {
            var _loc_2:* = NaN;
            _loc_2 = param1.vPos.x - (-this.vRadiusWidth) - param1.vRadius;
            if (_loc_2 < 0)
            {
                param1.onTunnelCollision(1, 0, _loc_2);
            }
            _loc_2 = this.vRadiusWidth - param1.vPos.x - param1.vRadius;
            if (_loc_2 < 0)
            {
                param1.onTunnelCollision(-1, 0, _loc_2);
            }
            _loc_2 = param1.vPos.y - (-this.vRadiusHeight) - param1.vRadius;
            if (_loc_2 < 0)
            {
                if (param1.vPos.x < (-this.vGoalWidth) / 2)
                {
                    param1.onTunnelCollision(0, 1, _loc_2);
                }
                else if (param1.vPos.x > this.vGoalWidth / 2)
                {
                    param1.onTunnelCollision(0, 1, _loc_2);
                }
                else if (_loc_2 < -this.vGoalDeltaInside)
                {
                    param1.kill();
                }
            }
            _loc_2 = this.vRadiusHeight - param1.vPos.y - param1.vRadius;
            if (_loc_2 < 0)
            {
                if (param1.vPos.x < (-this.vGoalWidth) / 2)
                {
                    param1.onTunnelCollision(0, -1, _loc_2);
                }
                else if (param1.vPos.x > this.vGoalWidth / 2)
                {
                    param1.onTunnelCollision(0, -1, _loc_2);
                }
                else if (_loc_2 < -this.vGoalDeltaInside)
                {
                    param1.kill();
                }
            }
            return;
        }// end function

        override public function checkWow(param1:GBL_Glob) : Boolean
        {
            var _loc_2:* = NaN;
            if (param1.isKilled)
            {
                return false;
            }
            var _loc_3:* = 2;
            _loc_2 = param1.vPos.y - (-this.vRadiusHeight) - param1.vRadius;
            if (_loc_2 < _loc_3)
            {
                if (param1.vPos.x < (-this.vGoalWidth) / 2)
                {
                }
                else if (param1.vPos.x > this.vGoalWidth / 2)
                {
                }
                else
                {
                    return true;
                }
            }
            _loc_2 = this.vRadiusHeight - param1.vPos.y - param1.vRadius;
            if (_loc_2 < _loc_3)
            {
                if (param1.vPos.x < (-this.vGoalWidth) / 2)
                {
                }
                else if (param1.vPos.x > this.vGoalWidth / 2)
                {
                }
                else
                {
                    return true;
                }
            }
            return false;
        }// end function

        override public function refreshSpecific() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            while (_loc_2 < vGlobs.length)
            {
                
                _loc_1 = vGlobs[_loc_2];
                if (!_loc_1.isKilled)
                {
                    if (GBL_Main.isReverse)
                    {
                        if (_loc_1.vPos.x < -this.vRadiusWidth)
                        {
                            _loc_1.vPerso.x = this.vRadiusWidth;
                        }
                        if (_loc_1.vPos.x > this.vRadiusWidth)
                        {
                            _loc_1.vPerso.x = -this.vRadiusWidth;
                        }
                        if (_loc_1.vPos.y < -this.vRadiusHeight)
                        {
                            if (_loc_1.vPos.x < (-this.vGoalWidth) / 2)
                            {
                                _loc_1.vPerso.y = this.vRadiusHeight;
                            }
                            else if (_loc_1.vPos.x > this.vGoalWidth / 2)
                            {
                                _loc_1.vPerso.y = this.vRadiusHeight;
                            }
                        }
                        if (_loc_1.vPos.y > this.vRadiusHeight)
                        {
                            if (_loc_1.vPos.x < (-this.vGoalWidth) / 2)
                            {
                                _loc_1.vPerso.y = -this.vRadiusHeight;
                            }
                            else if (_loc_1.vPos.x > this.vGoalWidth / 2)
                            {
                                _loc_1.vPerso.y = -this.vRadiusHeight;
                            }
                        }
                    }
                    else
                    {
                        if (_loc_1.vPos.x < -this.vRadiusWidth)
                        {
                            _loc_1.vPerso.x = -this.vRadiusWidth;
                        }
                        if (_loc_1.vPos.x > this.vRadiusWidth)
                        {
                            _loc_1.vPerso.x = this.vRadiusWidth;
                        }
                        if (_loc_1.vPos.y < -this.vRadiusHeight)
                        {
                            if (_loc_1.vPos.x < (-this.vGoalWidth) / 2)
                            {
                                _loc_1.vPerso.y = -this.vRadiusHeight;
                            }
                            else if (_loc_1.vPos.x > this.vGoalWidth / 2)
                            {
                                _loc_1.vPerso.y = -this.vRadiusHeight;
                            }
                        }
                        if (_loc_1.vPos.y > this.vRadiusHeight)
                        {
                            if (_loc_1.vPos.x < (-this.vGoalWidth) / 2)
                            {
                                _loc_1.vPerso.y = this.vRadiusHeight;
                            }
                            else if (_loc_1.vPos.x > this.vGoalWidth / 2)
                            {
                                _loc_1.vPerso.y = this.vRadiusHeight;
                            }
                        }
                    }
                    _loc_1.vPerso.onRefreshPos();
                }
                _loc_2++;
            }
            return;
        }// end function

        override public function beforeResolution() : void
        {
            return;
        }// end function

        override public function afterResolution() : void
        {
            return;
        }// end function

        override public function hideOutlines() : void
        {
            this.vBallOver.visible = false;
            var _loc_1:* = 0;
            while (_loc_1 < vGame.vTerrain.vGlobs.length)
            {
                
                vGame.vTerrain.vGlobs[_loc_1].hideArrowOutline();
                _loc_1++;
            }
            return;
        }// end function

        override public function showOutlines() : void
        {
            this.vBallOver.x = vGlobs[6].vPos.x;
            this.vBallOver.y = vGlobs[6].vPos.y;
            if (GBL_Main.isReverse)
            {
                this.vBallOver.x = -this.vBallOver.x;
                this.vBallOver.y = -this.vBallOver.y;
            }
            vGame.layerPlayers.setChildIndex(this.vBallOver, (vGame.layerPlayers.numChildren - 1));
            if (!vGlobs[6].vCanCollide)
            {
                this.vBallOver.visible = false;
            }
            else if (vGlobs[6].isKilled)
            {
                this.vBallOver.visible = false;
            }
            else
            {
                this.vBallOver.visible = true;
            }
            var _loc_1:* = 0;
            while (_loc_1 < vGame.vTerrain.vGlobs.length)
            {
                
                vGame.vTerrain.vGlobs[_loc_1].showArrowOutline();
                _loc_1++;
            }
            return;
        }// end function

    }
}
