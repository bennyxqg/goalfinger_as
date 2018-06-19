package gbl
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import gbl.ergo.*;
    import gbl.infos.*;
    import gbl.terrain.*;
    import globz.*;
    import tools.*;

    public class GBL_Main extends Sprite
    {
        public var vRunning:Boolean = true;
        public var vReplay:Boolean = false;
        private var vClassTerrain:Class;
        public var vTerrain:TerrainXXX;
        private var vCallbackInit:Function;
        public var vCompute:GBL_Compute;
        public var isStarted:Boolean = false;
        public var vCurTeam:int = 0;
        public var vInterface:GBL_Interface;
        public var vDemoSolo:Boolean = false;
        public var vAIRunning:Boolean = false;
        public var vNbRound:int;
        public var vLastRoundRestarted:int;
        public var vNbGoal:int;
        private var vLastGlobHittingBall:int = -1;
        public var layerBG:Sprite;
        public var layerInfos:Sprite;
        public var layerSocle:Sprite;
        public var layerArrow:Sprite;
        public var layerPlayers:Sprite;
        public var layerFG:Sprite;
        public var layerInterface:Sprite;
        public var vImages:Object;
        private var vCallbackGrafDone:Function;
        private var vInfoBox:InfoBox;
        public var vTeams:Vector.<GBL_Team>;
        public var vAction:GBL_Action;
        private var vCallbackOrders:Function;
        public var vHandlerOrder:Function;
        public var vOrderExtra:String = "";
        public var vCoefInitiative:Number = 0.8;
        public var vResolution:GBL_Resolution;
        private var vCallbackResolution:Function;
        public var vSuddenDeath:Boolean = false;
        public var vSuddenDeathEffective:Boolean = false;
        public var vSuddenDeathBothTeam:Boolean = false;
        public var vInstant:Boolean = false;
        public var vStopped:Boolean = false;
        public var vEndDone:Boolean = false;
        private var vInstantReplaySave:String = "";
        public var vInstantReplayTab:Array;
        public var vChallenge:GBL_Challenge;
        private var vTimeBankActive:Boolean = false;
        private var vBankLeft:Number = -1;
        private var vBankDeactivated:Boolean = false;
        private var vBankTimer:int;
        private var vSaveTeams:String = "";
        private var vTraceBefore:String = "[NoTrace]";
        public static var vZoomCoef:Number = 1.15;
        public static var isReverse:Boolean = false;
        public static var vStepDt:Number = 0.004;
        public static var vWeatherCoef:Number = 1;
        public static var vGameJoining:Boolean = false;
        public static var vDelta169:Number = -25;
        public static var vSuddenDeathDatas:String = "";
        public static var vSuddenDeathVersion:int = 0;
        public static var vSuddenDeathGoals:int = 2;
        public static var vSuddenDeathRound:int = 12;
        public static var vSuddenDeathSeconds:int = 1800;
        public static var vSuddenDeathInc:int = 51;
        public static var vTimerDuration:int = 15;
        public static var vTimeoutLeaver:Number = 10;
        public static var vResolutionShowOrders:Number = 0.5;
        public static var vResolutionShowMoves:Number = 2;
        public static var vTimebankDuration:int = 0;
        public static var vCheckDisconnectedPingStart:int = 0;
        public static var vCheckDisconnectedPingTimeout:int = 5;
        public static var vHitPoints_Start:int = 2;
        public static var vHitPoints_Regen:int = 2;
        public static var vHitPoints_ForceMin:Number = 5;

        public function GBL_Main(param1:Class = null)
        {
            this.vTeams = new Vector.<GBL_Team>;
            Global.vGame = this;
            if (Global.v169e)
            {
                vZoomCoef = 1.25;
            }
            if (param1 == null)
            {
                this.vTerrain = new Foot2(this);
            }
            else
            {
                this.vTerrain = new param1(this);
            }
            isReverse = false;
            Global.vAiming = false;
            addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            return;
        }// end function

        public function destroy(event:Event = null) : void
        {
            var _loc_2:* = undefined;
            Global.addEventTrace("GBL_Main.destroy");
            this.stopRunning(false);
            if (this.vImages != null)
            {
                for (_loc_2 in this.vImages)
                {
                    
                    _loc_4[_loc_2].destroyAll();
                    delete _loc_4[_loc_2];
                }
                this.vImages = null;
            }
            if (this.vAction != null)
            {
                this.vAction.destroy();
                this.vAction = null;
            }
            this.vTerrain.destroy();
            if (this.vInterface != null)
            {
                this.vInterface.destroy();
            }
            return;
        }// end function

        public function init(param1:Function) : void
        {
            this.vCallbackInit = param1;
            x = Global.vSize.x / 2;
            y = Global.vSize.y / 2;
            this.initLayers();
            if (this.vInterface != null)
            {
                this.vInterface.removeAll();
                this.layerInterface.removeChild(this.vInterface);
            }
            this.vInterface = new GBL_Interface(this);
            this.layerInterface.addChild(this.vInterface);
            this.initGraf(this.vCallbackInit);
            return;
        }// end function

        public function activateDemoSolo(param1:Boolean = true) : void
        {
            this.vDemoSolo = param1;
            return;
        }// end function

        public function showGameBG() : void
        {
            this.vTerrain.initBG();
            return;
        }// end function

        public function onGameStart(param1:Boolean = false) : void
        {
            if (!this.isStarted)
            {
                if (!param1)
                {
                    Global.vSound.onGameStart();
                }
            }
            this.isStarted = true;
            return;
        }// end function

        public function showTeams(param1:Boolean = true) : void
        {
            var _loc_2:* = false;
            this.vInterface.initInfos();
            this.vTerrain.initGlobsGraf();
            if (!param1)
            {
                this.deactivateGlobs();
            }
            this.vNbRound = 0;
            this.vNbGoal = 0;
            this.saveInstantReplay("");
            return;
        }// end function

        public function deactivateGlobs() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_1].isKilled = true;
                this.vTerrain.vGlobs[_loc_1].vPerso.setVisible(false);
                _loc_1++;
            }
            return;
        }// end function

        public function activateGlobs() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_1].isKilled = false;
                this.vTerrain.vGlobs[_loc_1].vPerso.setVisible(true);
                _loc_1++;
            }
            return;
        }// end function

        public function hideAllGlobs() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_1].vPerso.setVisible(false);
                _loc_1++;
            }
            return;
        }// end function

        public function showAllGlobs() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_1].vPerso.setVisible(true);
                _loc_1++;
            }
            return;
        }// end function

        public function showAllGlobsAlive() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_1].vPerso.setVisible(!this.vTerrain.vGlobs[_loc_1].isKilled);
                _loc_1++;
            }
            return;
        }// end function

        public function restartRound(param1:Function, param2:Boolean = false, param3:Boolean = true) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            this.vLastRoundRestarted = this.vNbRound + 1;
            this.vTerrain.restartRound(param3);
            this.showAllGlobs();
            this.resetRound(param1);
            return;
        }// end function

        public function resetRound(param1:Function) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (Global.vDev)
            {
            }
            this.vTerrain.resetRound(param1);
            return;
        }// end function

        public function nextRound(param1:Function) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            this.vLastGlobHittingBall = -1;
            var _loc_2:* = this;
            var _loc_3:* = this.vNbRound + 1;
            _loc_2.vNbRound = _loc_3;
            this.vInterface.setRound(this.vNbRound);
            if (this.vSuddenDeath && this.vSuddenDeathEffective && this.vSuddenDeathBothTeam)
            {
                if (this.vInterface.vScore1 > this.vInterface.vScore2)
                {
                    param1.call(0, 1);
                    return;
                }
                if (this.vInterface.vScore2 > this.vInterface.vScore1)
                {
                    param1.call(0, 2);
                    return;
                }
                this.vTerrain.updateSuddenDeath();
            }
            this.resetRound(param1);
            return;
        }// end function

        public function setCurTeam(param1:int) : void
        {
            this.vCurTeam = param1;
            if (this.vCurTeam == 2)
            {
                isReverse = true;
            }
            else
            {
                isReverse = false;
            }
            this.vTerrain.refreshGlobs();
            return;
        }// end function

        public function onImpact(param1:GBL_Glob, param2:GBL_Glob, param3:Point) : void
        {
            var _loc_5:* = false;
            var _loc_6:* = 0;
            if (param1 == null)
            {
                return;
            }
            if (param2 == null)
            {
                return;
            }
            var _loc_4:* = param3.length / GBL_Main.vHitPoints_ForceMin;
            if (Global.vHitPoints)
            {
                if (this.vAction == null)
                {
                    _loc_5 = false;
                    if (param1.vTeam == 1 && param2.vTeam == 2 || param1.vTeam == 2 && param2.vTeam == 1)
                    {
                        if (param3.length > GBL_Main.vHitPoints_ForceMin)
                        {
                            _loc_6 = 0;
                            if (param1.removeHP(param2))
                            {
                                _loc_5 = true;
                                _loc_6++;
                            }
                            if (param2.removeHP(param1))
                            {
                                _loc_5 = true;
                                _loc_6++;
                            }
                            if (_loc_5)
                            {
                                this.addImpact((param1.vPos.x + param2.vPos.x) / 2, (param1.vPos.y + param2.vPos.y) / 2, _loc_6);
                            }
                        }
                    }
                    if (_loc_5)
                    {
                        this.vCompute.saveEvent("soundImpact", {coef:_loc_4, x:(param1.vPos.x + param2.vPos.x) / 2, y:(param1.vPos.y + param2.vPos.y) / 2});
                    }
                    else
                    {
                        this.vCompute.saveEvent("soundImpactSoft", {coef:_loc_4, x:(param1.vPos.x + param2.vPos.x) / 2, y:(param1.vPos.y + param2.vPos.y) / 2});
                    }
                }
            }
            if (param1.vTeam == 3)
            {
                if (this.vLastGlobHittingBall != param2.vId)
                {
                    this.vLastGlobHittingBall = param2.vId;
                    if (this.vCompute != null)
                    {
                        this.vCompute.saveEvent("soundBall", {x:param1.vPos.x, y:param1.vPos.y, coef:_loc_4});
                    }
                }
            }
            else if (param2.vTeam == 3)
            {
                if (this.vLastGlobHittingBall != param1.vId)
                {
                    this.vLastGlobHittingBall = param1.vId;
                    if (this.vCompute != null)
                    {
                        this.vCompute.saveEvent("soundBall", {x:param2.vPos.x, y:param2.vPos.y, coef:_loc_4});
                    }
                }
            }
            return;
        }// end function

        public function addImpact(param1:Number, param2:Number, param3:int = 2) : void
        {
            if (this.vAction != null)
            {
                return;
            }
            if (this.vCompute != null)
            {
                this.vCompute.saveEvent("impact", {x:Math.round(param1), y:Math.round(param2), num:param3});
                return;
            }
            var _loc_4:* = new Point(param1, param2);
            if (isReverse)
            {
                _loc_4.x = -_loc_4.x;
                _loc_4.y = -_loc_4.y;
            }
            Global.startParticles(this.layerPlayers, _loc_4, Global.vImages["particle_line_3"], 8, 0, 8, 30 / GBL_Resolution.vSpeedCoef, 1, true, 1, 0, 0, 2, -2, 2, -2, 1, "normal", true, false);
            if (param3 == 2)
            {
                Global.startParticles(this.layerFG, _loc_4, this.vImages["particle_hit"], 1, 0, 1, 60 / GBL_Resolution.vSpeedCoef, 1, false, 2, 0, 0.1, -1, -1, -4, -4, 0.99, "normal", false, false);
                Global.startParticles(this.layerFG, _loc_4, this.vImages["particle_hit"], 1, 0, 1, 60 / GBL_Resolution.vSpeedCoef, 1, false, 2, 0, 0.1, 1, 1, -4, -4, 0.99, "normal", false, false);
            }
            else
            {
                Global.startParticles(this.layerFG, _loc_4, this.vImages["particle_hit"], 1, 0, 1, 60 / GBL_Resolution.vSpeedCoef, 1, false, 2, 0, 0.1, -0, -0, -4, -4, 0.99, "normal", false, false);
            }
            return;
        }// end function

        private function initLayers() : void
        {
            this.layerBG = this.newLayer();
            this.layerInfos = this.newLayer();
            this.layerSocle = this.newLayer();
            this.layerArrow = this.newLayer();
            this.layerPlayers = this.newLayer();
            this.layerFG = this.newLayer();
            this.layerInterface = this.newLayer(false);
            if (Global.v169e)
            {
                this.adjustLayer169e(this.layerBG);
                this.adjustLayer169e(this.layerInfos);
                this.adjustLayer169e(this.layerSocle);
                this.adjustLayer169e(this.layerArrow);
                this.adjustLayer169e(this.layerPlayers);
                this.adjustLayer169e(this.layerFG);
            }
            return;
        }// end function

        private function newLayer(param1:Boolean = true) : Sprite
        {
            var _loc_2:* = new Sprite();
            if (param1)
            {
                var _loc_3:* = vZoomCoef;
                _loc_2.scaleY = vZoomCoef;
                _loc_2.scaleX = _loc_3;
            }
            addChild(_loc_2);
            return _loc_2;
        }// end function

        private function adjustLayer169e(param1:Sprite) : void
        {
            var _loc_2:* = 1.25;
            param1.x = param1.x + vDelta169;
            return;
        }// end function

        private function initGraf(param1:Function) : void
        {
            var _loc_2:* = null;
            this.vImages = new Object();
            var _loc_3:* = new mcToBitmapQueue();
            this.vImages["arrow_line"] = new mcToBitmapAS3(new ArrowGrafLine(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3);
            this.vImages["arrow_end"] = new mcToBitmapAS3(new ArrowGrafEnd(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3);
            if (Global.vHitPoints)
            {
                this.vImages["particle_hit"] = new mcToBitmapAS3(new HitPointGraf(), 1, Global.vResolution, true, null, 0, _loc_3);
            }
            this.vImages["turncount_graf"] = new mcToBitmapAS3(new TurnCountGraf(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3);
            this.vImages["turncount_bar"] = new mcToBitmapAS3(new TurnCountBar(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3);
            this.vImages["button_launch"] = new mcToBitmapAS3(new ButtonLaunch(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3);
            this.vImages["button_gauge"] = new mcToBitmapAS3(new GaugeButton(), 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_3, 0, true);
            this.vImages["button_info"] = new mcToBitmapAS3(new MenuButton_Info(), 0, Global.vResolution, true, null, 0, _loc_3);
            this.vImages["button_chat"] = new mcToBitmapAS3(new ChatMessageButton(), 0, Global.vResolution, true, null, 0, _loc_3);
            this.vImages["button_quit"] = new mcToBitmapAS3(new MenuButton_Quit(), 0, Global.vResolution, true, null, 0, _loc_3);
            this.vTerrain.rasterizeTerrainGraf(_loc_3);
            _loc_3.startConversion(param1);
            return;
        }// end function

        public function prepareTeams(param1:Function) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            this.vTerrain.prepareGlobs();
            if (this.vTeams.length != 2)
            {
                Global.onError("GBL_Main.rasterizeTeams vTeams.length=" + this.vTeams.length);
                param1.call();
                return;
            }
            var _loc_8:* = new mcToBitmapQueue();
            _loc_2 = 1;
            while (_loc_2 <= 2)
            {
                
                _loc_3 = 1;
                while (_loc_3 <= 3)
                {
                    
                    _loc_5 = this.getGlob(_loc_2, _loc_3);
                    _loc_4 = new MovieClip();
                    _loc_6 = new GrafGlobSimple();
                    _loc_6.gotoAndStop(_loc_2);
                    var _loc_11:* = _loc_5.vCoefMass;
                    _loc_6.scaleY = _loc_5.vCoefMass;
                    _loc_6.scaleX = _loc_11;
                    _loc_4.addChild(_loc_6);
                    _loc_7 = new GrafGlobPosition();
                    _loc_7.txtPosition.text = _loc_3.toString();
                    _loc_4.addChild(_loc_7);
                    if (this.vImages["glob_team" + _loc_2 + "_pos" + _loc_3] != null)
                    {
                        this.vImages["glob_team" + _loc_2 + "_pos" + _loc_3].destroyAll();
                    }
                    this.vImages["glob_team" + _loc_2 + "_pos" + _loc_3] = new mcToBitmapAS3(_loc_4, 0, vZoomCoef * Global.vResolution, true, null, 0, _loc_8);
                    _loc_3++;
                }
                _loc_10 = 0;
                while (_loc_10 < this.vTeams[(_loc_2 - 1)].vBoosters.length)
                {
                    
                    _loc_9 = new BoosterButton();
                    if (_loc_2 == this.vCurTeam)
                    {
                        _loc_9.gotoAndStop(this.vTeams[(_loc_2 - 1)].vBoosters[_loc_10].type);
                    }
                    else
                    {
                        _loc_9.gotoAndStop(this.vTeams[(_loc_2 - 1)].vBoosters[_loc_10].type + "_Flat");
                    }
                    _loc_4 = new MovieClip();
                    _loc_4.addChild(_loc_9);
                    this.vImages["booster_" + (_loc_2 - 1) + "_" + _loc_10] = new mcToBitmapAS3(_loc_4, 0, Global.vResolution, true, null, 0, _loc_8);
                    _loc_10++;
                }
                this.vImages["booster_closed"] = new mcToBitmapAS3(new BoosterButtonClosed(), 0, Global.vResolution, true, null, 0, _loc_8);
                this.vImages["booster_confirm"] = new mcToBitmapAS3(new BoosterButtonConfirm(), 0, Global.vResolution, true, null, 0, _loc_8);
                _loc_2++;
            }
            _loc_8.startConversion(param1);
            return;
        }// end function

        public function showInfoBox(param1:String, param2:int = 1) : void
        {
            this.removeInfoBox();
            this.vInfoBox = new InfoBox(this, param1, param2);
            return;
        }// end function

        public function removeInfoBox() : void
        {
            if (this.vInfoBox != null)
            {
                this.vInfoBox.remove();
                this.vInfoBox = null;
            }
            return;
        }// end function

        public function addTeam(param1:int, param2:GBL_Team) : void
        {
            param2.vSide = param1;
            this.vTeams.push(param2);
            return;
        }// end function

        public function initPseudos(param1:String, param2:String, param3:String = "", param4:String = "") : void
        {
            this.vInterface.setPseudos(param1, param2, GBL_Main.isReverse, param3, param4);
            return;
        }// end function

        public function getGlob(param1:int, param2:int) : GBL_Glob
        {
            var _loc_3:* = null;
            var _loc_4:* = 0;
            while (_loc_4 < this.vTerrain.vGlobs.length)
            {
                
                _loc_3 = this.vTerrain.vGlobs[_loc_4];
                if (_loc_3.vTeam == param1)
                {
                    if (_loc_3.vPosition == param2)
                    {
                        return _loc_3;
                    }
                }
                _loc_4++;
            }
            Global.onError("GBL_Main.getGlob not found pTeam=" + param1 + " pPosition=" + param2);
            return null;
        }// end function

        public function setOrderHandler(param1:Function) : void
        {
            this.vHandlerOrder = param1;
            return;
        }// end function

        public function askOrders(param1:Function, param2:Number = 0) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            this.vCallbackOrders = param1;
            this.vOrderExtra = "";
            if (this.vAction != null)
            {
                this.vAction.destroy();
            }
            this.vAction = new GBL_Action_Golf(this);
            this.vAction.startListenOrder();
            this.vInterface.startButtonLaunch(this.sendOrders, param2);
            this.vTerrain.showOutlines();
            Global.vRoot.stage.frameRate = 30;
            return;
        }// end function

        public function cancelAskOrders() : void
        {
            this.vInterface.removeButtonLaunch();
            this.vTerrain.hideOutlines();
            if (this.vAction != null)
            {
                this.vAction.destroy();
                this.vAction = null;
            }
            return;
        }// end function

        public function sendOrders() : void
        {
            if (!this.vRunning)
            {
                return;
            }
            this.vInterface.removeButtonLaunch();
            this.vTerrain.hideOutlines();
            if (this.vAction != null)
            {
                this.vAction.destroy();
                this.vAction = null;
            }
            else
            {
                return;
            }
            if (this.vCallbackOrders != null)
            {
                this.vCallbackOrders.call(0, this.buildOrders());
            }
            return;
        }// end function

        public function addOrderExtra(param1:String) : void
        {
            if (this.vOrderExtra != "")
            {
                this.vOrderExtra = this.vOrderExtra + ",";
            }
            this.vOrderExtra = this.vOrderExtra + param1;
            return;
        }// end function

        public function onOrderExtra(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            Global.addLogTrace("onOrderExtra : " + param1);
            var _loc_2:* = param1.split(":");
            if (_loc_2[0] == "booster")
            {
                _loc_3 = parseInt(_loc_2[1]);
                _loc_4 = parseInt(_loc_2[2]);
                Global.addLogTrace("lTeam=" + _loc_3 + " myTeam=" + this.vCurTeam);
                this.vInterface.onBoosterJoining(_loc_3, _loc_4);
            }
            else
            {
                Global.addLogTrace("onOrderExtra unknown:" + param1, "GBL_Main");
            }
            return;
        }// end function

        public function buildOrders() : String
        {
            var _loc_2:* = null;
            var _loc_1:* = "";
            var _loc_3:* = 0;
            while (_loc_3 < this.vTerrain.vGlobs.length)
            {
                
                _loc_2 = this.vTerrain.vGlobs[_loc_3];
                if (this.isInTeam(_loc_2))
                {
                    if (_loc_1 != "")
                    {
                        _loc_1 = _loc_1 + "_";
                    }
                    _loc_1 = _loc_1 + _loc_2.vId + "," + _loc_2.getOrder();
                }
                _loc_3++;
            }
            var _loc_4:* = this.vInterface.vTimeTotal - this.vInterface.getSecondsPlayed();
            if (this.vInterface.vTimeTotal - this.vInterface.getSecondsPlayed() < 0)
            {
                _loc_4 = 0;
            }
            _loc_1 = _loc_1 + "_timer," + this.vCurTeam + "," + _loc_4;
            if (this.vOrderExtra != "")
            {
                _loc_1 = _loc_1 + "_extra," + this.vOrderExtra;
            }
            return _loc_1;
        }// end function

        public function isInTeam(param1:GBL_Glob) : Boolean
        {
            if (param1.vTeam == 3)
            {
                return false;
            }
            if (!this.isChallenge() && this.vDemoSolo)
            {
                return true;
            }
            if (param1.vTeam == this.vCurTeam)
            {
                return true;
            }
            return false;
        }// end function

        public function attemptReconnect() : void
        {
            Global.addLogTrace("attemptReconnect Current Round:" + this.vNbRound + " nbgoal:" + this.vNbGoal, "GBL_Main");
            if (this.vResolution != null)
            {
                Global.addLogTrace("Resolution running", "GBL_Main");
            }
            return;
        }// end function

        public function getEnergyRoundInfos() : Array
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Array();
            var _loc_4:* = 1;
            while (_loc_4 <= 3)
            {
                
                _loc_3 = this.getGlob(this.vCurTeam, _loc_4);
                _loc_2 = new Object();
                _loc_2.ArrowSum = Math.round(100 * _loc_3.vEnergyStats.ordersTotal);
                _loc_2.KO = _loc_3.vEnergyStats.nbKos;
                _loc_2.Kill = _loc_3.vEnergyStats.nbKilled;
                _loc_1.push(_loc_2);
                _loc_4++;
            }
            return _loc_1;
        }// end function

        public function startResolution(param1:String, param2:Function, param3:Boolean = false) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (this.isRunning())
            {
                return;
            }
            this.saveInstantReplay(param1);
            this.vCallbackResolution = param2;
            this.vResolution = new GBL_Resolution(this);
            this.vTerrain.hideOutlines();
            var _loc_4:* = 0;
            while (_loc_4 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_4].vPerso.setHighlight(false);
                _loc_4++;
            }
            this.vInterface.hideCharsInfos();
            Global.vRoot.stage.frameRate = 60;
            this.vInstant = param3;
            this.vResolution.start(param1, this.afterResolution, this.vInstant);
            return;
        }// end function

        public function changeSpeedResolution(param1:Number) : void
        {
            if (this.vResolution != null)
            {
                this.vResolution.changeSpeedCoef(param1);
            }
            else
            {
                GBL_Resolution.vSpeedCoef = param1;
            }
            return;
        }// end function

        public function togglePause() : void
        {
            if (this.vResolution != null)
            {
                this.vResolution.togglePause();
            }
            return;
        }// end function

        public function isRunning() : Boolean
        {
            return this.vResolution != null;
        }// end function

        private function afterResolution(param1:int) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (param1 == 1 || param1 == 2)
            {
                this.vInterface.addScore(param1, GBL_Main.isReverse, this.vInstant);
            }
            this.vResolution = null;
            this.vCallbackResolution.call(0, param1);
            return;
        }// end function

        public function onGameEnd(param1:int, param2:Number = 2) : void
        {
            if (stage)
            {
                stage.frameRate = 60;
            }
            TweenMax.delayedCall(param2, this.onGameEndAnim, [param1]);
            return;
        }// end function

        public function onGameEndAnim(param1:int) : void
        {
            if (this.vEndDone)
            {
                return;
            }
            this.vEndDone = true;
            Global.vSound.onGameEnd();
            if (param1 > 0)
            {
                this.vTerrain.animWinner(param1);
            }
            return;
        }// end function

        public function stopRunning(param1:Boolean = true) : void
        {
            var _loc_2:* = 0;
            this.vStopped = true;
            this.vRunning = false;
            if (!param1)
            {
                Global.vSound.stopGameLoop();
            }
            if (this.vInfoBox != null)
            {
                this.vInfoBox.remove();
            }
            if (this.vAction != null)
            {
                this.vAction.destroy();
            }
            if (this.vInterface != null)
            {
                this.vInterface.stopTimer();
            }
            if (this.vResolution != null)
            {
                this.vResolution.stopRunning();
            }
            if (this.vTerrain != null)
            {
                if (this.vTerrain.vGlobs != null)
                {
                    _loc_2 = 0;
                    while (_loc_2 < this.vTerrain.vGlobs.length)
                    {
                        
                        this.vTerrain.vGlobs[_loc_2].hideArrow();
                        _loc_2++;
                    }
                }
            }
            this.vCallbackOrders = null;
            return;
        }// end function

        public function onSuddentDeathGameOver(param1:int) : void
        {
            if (Global.vServer.vMatchCallback != null)
            {
                Global.vServer.vMatchCallback.call(0, "SuddenDeathWinner", {winner:param1});
            }
            return;
        }// end function

        public function sendMailInstantReplay() : void
        {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getInstantReplayDesc());
            if (this.parent)
            {
                new MsgBox(this.parent, "InstantReplay dans le copier/coller");
            }
            return;
        }// end function

        public function saveInstantReplay(param1:String) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = param1;
            _loc_2 = _loc_2 + "§" + this.vTeams[0].vDesc;
            _loc_2 = _loc_2 + "§" + this.vTeams[1].vDesc;
            _loc_2 = _loc_2 + "§" + this.vNbRound.toString();
            var _loc_4:* = 0;
            while (_loc_4 < this.vTerrain.vGlobs.length)
            {
                
                _loc_3 = this.vTerrain.vGlobs[_loc_4];
                if (_loc_4 == 0)
                {
                    _loc_2 = _loc_2 + "§";
                }
                else
                {
                    _loc_2 = _loc_2 + "_";
                }
                _loc_2 = _loc_2 + _loc_3.vId + "," + GBL_Glob.formatValue(_loc_3.vPos.x) + "," + GBL_Glob.formatValue(_loc_3.vPos.y);
                if (_loc_3.isKilled)
                {
                    _loc_2 = _loc_2 + ",1";
                }
                else
                {
                    _loc_2 = _loc_2 + ",0";
                }
                _loc_4++;
            }
            this.vInstantReplaySave = _loc_2;
            this.vTraceBefore = this.buildInstantPos();
            return;
        }// end function

        public function getInstantReplayDesc() : String
        {
            return this.vInstantReplaySave;
        }// end function

        public function parseInstantReplay(param1:String) : void
        {
            this.vInstantReplayTab = param1.split("§");
            return;
        }// end function

        public function initChallenge() : void
        {
            this.vChallenge = new GBL_Challenge(this);
            this.vTerrain.initGlobsGraf();
            this.deactivateGlobs();
            return;
        }// end function

        public function startChallenge(param1:Function) : void
        {
            this.vChallenge.startChallenge(param1);
            return;
        }// end function

        public function stopChallenge() : void
        {
            this.vChallenge = null;
            return;
        }// end function

        public function isChallenge() : Boolean
        {
            if (this.vChallenge == null)
            {
                return false;
            }
            return true;
        }// end function

        public function deactivateBall() : void
        {
            var _loc_1:* = this.getGlob(3, 0);
            _loc_1.vCanCollide = false;
            _loc_1.vPerso.visible = false;
            return;
        }// end function

        public function reactivateBall() : void
        {
            var _loc_1:* = this.getGlob(3, 0);
            _loc_1.vCanCollide = true;
            _loc_1.vPerso.visible = true;
            return;
        }// end function

        public function startTimebank() : void
        {
            if (!this.vTimeBankActive)
            {
                return;
            }
            Global.addLogTrace("startTimebank", "TimeBank");
            if (vTimebankDuration > 0)
            {
                this.vBankLeft = vTimebankDuration;
            }
            else
            {
                this.vBankLeft = -1;
            }
            return;
        }// end function

        public function onTimebankDeactivate() : void
        {
            if (!this.vTimeBankActive)
            {
                return;
            }
            Global.addLogTrace("onTimebankDeactivate vBankLeft=" + this.vBankLeft, "TimeBank");
            if (this.vBankLeft < 0)
            {
                return;
            }
            this.vBankDeactivated = true;
            this.vBankTimer = getTimer();
            return;
        }// end function

        public function onTimebankReactivate() : void
        {
            if (!this.vTimeBankActive)
            {
                return;
            }
            Global.addLogTrace("onTimebankReactivate vBankLeft=" + this.vBankLeft, "TimeBank");
            if (this.vBankLeft < 0)
            {
                return;
            }
            if (!this.vBankDeactivated)
            {
                return;
            }
            if (!this.vRunning)
            {
                return;
            }
            var _loc_1:* = (getTimer() - this.vBankTimer) / 1000;
            this.vBankLeft = this.vBankLeft - _loc_1;
            if (this.vBankLeft < 0)
            {
                Global.addLogTrace("Timeout !", "TimeBank");
                Global.vStats.Stats_Event("TimeBank", "Timeout", "UserId", parseInt(Global.vServer.vUser.vUserId));
                Global.vServer.forceDisconnect("Timebank Timeout");
            }
            return;
        }// end function

        public function saveInstantPos() : void
        {
            var _loc_1:* = this.buildInstantPos();
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            _loc_2.data.instant_pos = _loc_1;
            _loc_2.flush();
            return;
        }// end function

        public function buildInstantPos() : String
        {
            var _loc_1:* = "";
            var _loc_2:* = 0;
            while (_loc_2 < this.vTerrain.vGlobs.length)
            {
                
                if (_loc_2 > 0)
                {
                    _loc_1 = _loc_1 + "_";
                }
                _loc_1 = _loc_1 + this.vTerrain.vGlobs[_loc_2].getInstantPos();
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public function loadInstantPos(param1:String = "") : void
        {
            var _loc_4:* = null;
            if (param1 == "")
            {
                _loc_4 = SharedObject.getLocal(Global.SO_ID);
                param1 = _loc_4.data.instant_pos;
            }
            var _loc_2:* = param1.split("_");
            var _loc_3:* = 0;
            while (_loc_3 < this.vTerrain.vGlobs.length)
            {
                
                this.vTerrain.vGlobs[_loc_3].setInstantPos(_loc_2[_loc_3]);
                this.vTerrain.vGlobs[_loc_3].hideArrow();
                _loc_3++;
            }
            this.vTerrain.resetRoundSpecific(this.noFun, true);
            this.vTerrain.hideOutlines();
            this.vLastRoundRestarted = 0;
            this.vNbRound = 1;
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        public function getTraceBefore() : String
        {
            var _loc_1:* = "";
            _loc_1 = GBL_Main.vWeatherCoef.toString();
            var _loc_2:* = 0;
            while (_loc_2 < this.vTeams.length)
            {
                
                _loc_1 = _loc_1 + "¤";
                _loc_1 = _loc_1 + this.vTeams[_loc_2].vDesc;
                _loc_2++;
            }
            _loc_1 = _loc_1 + "¤";
            _loc_1 = _loc_1 + this.vTraceBefore;
            _loc_1 = _loc_1.split("\"").join("\'");
            return _loc_1;
        }// end function

        public static function parseDataSuddenDeath(param1:Object) : void
        {
            if (param1 == null)
            {
                return;
            }
            vSuddenDeathRound = param1.SD_Round;
            vSuddenDeathSeconds = param1.SD_Seconds;
            vSuddenDeathInc = param1.SD_WidthInc;
            vTimerDuration = param1.SD_RoundTimer;
            return;
        }// end function

        public static function parseGameMisc(param1:Object) : void
        {
            if (param1 == null)
            {
                return;
            }
            vTimeoutLeaver = param1.timeout_leaver_client;
            vResolutionShowOrders = param1.resolution_show_orders;
            vResolutionShowMoves = param1.resolution_show_moves;
            if (param1.timebank == null)
            {
                vTimebankDuration = 0;
            }
            else
            {
                vTimebankDuration = param1.timebank;
            }
            if (param1.checkdisconnected_ping_start == null)
            {
                vCheckDisconnectedPingStart = 0;
            }
            else
            {
                vCheckDisconnectedPingStart = param1.checkdisconnected_ping_start;
            }
            if (param1.checkdisconnected_ping_timeout == null)
            {
                vCheckDisconnectedPingTimeout = 0;
            }
            else
            {
                vCheckDisconnectedPingTimeout = param1.checkdisconnected_ping_timeout;
            }
            return;
        }// end function

        public static function parseDataHitPoints(param1:Object) : void
        {
            if (param1 == null)
            {
                return;
            }
            vHitPoints_Start = param1.HP_Start;
            vHitPoints_Regen = param1.HP_Regen;
            return;
        }// end function

        public static function parseWeather(param1:Object) : void
        {
            Global.vWeather = 1;
            if (param1 == null)
            {
                return;
            }
            vWeatherCoef = 1;
            if (param1.type == "Low")
            {
                Global.vWeather = 2;
            }
            else if (param1.type == "High")
            {
                Global.vWeather = 3;
            }
            vWeatherCoef = param1.coef;
            return;
        }// end function

        public static function replayWeather(param1:Object) : void
        {
            if (param1 == null)
            {
                param1 = {type:"Normal", coef:0};
            }
            Global.vWeatherSave = {globalType:Global.vWeather, gblValue:vWeatherCoef};
            Toolz.traceObject(Global.vWeatherSave, "Global.vWeatherSave");
            parseWeather(param1);
            return;
        }// end function

    }
}
