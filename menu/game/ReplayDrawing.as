package menu.game
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import menu.tools.*;
    import tools.*;

    public class ReplayDrawing extends MenuXXX
    {
        private var vGame:GBL_Main;
        private var vData:Object;
        private var vCurGoal:int;
        private var vLoading:ButtonGrafBitmap;
        private var vCanQuit:Boolean = true;
        private var vPause:Boolean = true;
        private var vButtonSpeed:Sprite;
        private var vGraf:Sprite;
        private var vGrafSpot:Sprite;
        private var vGrafBall:Sprite;
        private var vBall:Sprite;
        private const TYPE_TRACE:int = 1;
        private const TYPE_SPOT:int = 2;
        private const TYPE_HIT:int = 3;
        private const TYPE_DEAD:int = 4;
        private var vRound:int = -1;
        private var vSuddenDeathStarted:Boolean = false;
        private var vGlobs:Vector.<GBL_Glob>;
        private var vButtonNum:Sprite;
        private var vButtonShare:Sprite;
        private var vGameShare:GBL_Main;
        private var vGameLayerPlayersSave:Sprite;
        public static var vGameId:String = "";
        public static var vPhotoNum:int = 1;
        public static var vReverse:Boolean = false;

        public function ReplayDrawing()
        {
            vTag = "ReplayDrawing";
            Global.vSound.stopMusic();
            Global.vStats.Stats_PageView("ReplayDrawing");
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            vImages["trace"] = new mcToBitmapAS3(new ReplayTrace(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["traceSpot"] = new mcToBitmapAS3(new ReplayTraceSpot(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["traceHit"] = new mcToBitmapAS3(new ReplayTraceHit(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["traceDead"] = new mcToBitmapAS3(new ReplayTraceDead(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["button_num_1"] = new mcToBitmapAS3(new MenuButton_Num_1(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["button_num_2"] = new mcToBitmapAS3(new MenuButton_Num_2(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["button_num_3"] = new mcToBitmapAS3(new MenuButton_Num_3(), 0, Global.vResolution * 1, true, null, 0, param1);
            if (true == true)
            {
                vImages["button_share"] = new mcToBitmapAS3(new MenuButton_Share_Android(), 0, Global.vResolution * 1, true, null, 0, param1);
            }
            else
            {
                vImages["button_share"] = new mcToBitmapAS3(new MenuButton_Share_iOS(), 0, Global.vResolution * 1, true, null, 0, param1);
            }
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
            if (Global.vDev)
            {
            }
            if (vGameId == "")
            {
                this.onError("No GameId");
                return;
            }
            this.loadReplay();
            return;
        }// end function

        private function loadReplay() : void
        {
            Global.vServer.loadReplay(this.onReplay, vGameId);
            return;
        }// end function

        private function onReplay(param1:Object) : void
        {
            this.vData = param1;
            GBL_Main.replayWeather(this.vData.weather);
            GBL_Main.parseDataSuddenDeath(this.vData.suddendeath);
            GBL_Main.parseDataHitPoints(this.vData.hitpoints);
            if (this.vData.player2 == Global.vServer.vUser.vUserId)
            {
                vReverse = true;
            }
            this.initGame();
            return;
        }// end function

        private function initGame() : void
        {
            this.vCurGoal = 0;
            this.vRound = -1;
            GBL_Resolution.vSpeedCoef = 1;
            this.vGame = new GBL_Main();
            this.vGame.vReplay = true;
            addChild(this.vGame);
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onError(param1:String) : void
        {
            Global.addLogTrace("Replay.onError:" + param1);
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = JSON.stringify(this.vData.team1);
            if (_loc_2 == "" || _loc_2 == null)
            {
                this.onError("lTeamDesc1=" + _loc_2);
                return;
            }
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(1, _loc_2);
            this.vGame.addTeam(1, _loc_1);
            var _loc_3:* = JSON.stringify(this.vData.team2);
            if (_loc_3 == "" || _loc_3 == null)
            {
                this.onError("lTeamDesc2=" + _loc_3);
                return;
            }
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(2, _loc_3);
            this.vGame.addTeam(2, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            var _loc_1:* = new GBL_Glob(3);
            _loc_1.setGame(this.vGame);
            _loc_1.setRadius(_loc_1.vRadius * GBL_Glob.BALL_SIZE_COEF);
            var _loc_2:* = new MovieClip();
            _loc_2.addChild(_loc_1.getPersoGraf());
            vImages["ball"] = new mcToBitmapAS3(_loc_2, 0, Global.vResolution * 1, true, null, 0, this.startGame);
            return;
        }// end function

        private function startGame() : void
        {
            this.vGame.showGameBG();
            this.vGame.vInterface.addQuit(this.onButtonQuitGame);
            this.vLoading = new ButtonGrafBitmap(new ReplayBuildInvite());
            this.vGame.layerInterface.addChild(this.vLoading);
            TweenMax.delayedCall(0.3, this.startReplay);
            return;
        }// end function

        private function onButtonQuitGame(event:Event = null) : void
        {
            if (!this.vCanQuit)
            {
                return;
            }
            this.vCanQuit = false;
            if (this.vGame != null)
            {
                this.vGame.destroy();
            }
            Global.vSound.stopMusic();
            Global.vSound.onButton();
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function initGraf() : void
        {
            if (vImages == null)
            {
                return;
            }
            this.vGraf = new Sprite();
            this.vGrafSpot = new Sprite();
            this.vGrafBall = new Sprite();
            this.vBall = new bitmapClip(vImages["ball"], "stop", false);
            return;
        }// end function

        private function draw(param1:int, param2:GBL_Glob) : void
        {
            var _loc_5:* = null;
            if (this.vCurGoal != vPhotoNum)
            {
                return;
            }
            var _loc_3:* = param2.vTeam;
            var _loc_4:* = 1;
            if (vReverse)
            {
                _loc_4 = -1;
            }
            if (param1 == this.TYPE_TRACE)
            {
                param2.vShape.graphics.lineTo(_loc_4 * param2.vPos.x, _loc_4 * param2.vPos.y);
                return;
            }
            if (param1 == this.TYPE_SPOT)
            {
                _loc_5 = new bitmapClip(vImages["traceSpot"], "stop", false);
                if (_loc_3 == 3)
                {
                    this.vGrafBall.addChild(_loc_5);
                }
                else
                {
                    this.vGrafSpot.addChild(_loc_5);
                }
            }
            else if (param1 == this.TYPE_HIT)
            {
                _loc_5 = new bitmapClip(vImages["traceHit"], "stop", false);
                this.vGrafSpot.addChild(_loc_5);
            }
            else if (param1 == this.TYPE_DEAD)
            {
                _loc_5 = new bitmapClip(vImages["traceDead"], "stop", false);
                if (_loc_3 == 3)
                {
                    this.vGrafBall.addChild(_loc_5);
                }
                else
                {
                    this.vGrafSpot.addChild(_loc_5);
                }
            }
            _loc_5.x = _loc_4 * param2.vPos.x;
            _loc_5.y = _loc_4 * param2.vPos.y;
            if (_loc_3 == 3)
            {
                _loc_5.gotoAndStop(_loc_3);
            }
            else if (vReverse)
            {
                _loc_5.gotoAndStop(3 - _loc_3);
            }
            else
            {
                _loc_5.gotoAndStop(_loc_3);
            }
            return;
        }// end function

        private function startReplay() : void
        {
            this.vGame.vTerrain.initDimensions();
            this.vGame.vTerrain.initGlobsGraf();
            this.vGame.vInterface.initInfos(false);
            this.vGame.vInterface.hideTimer();
            this.vGame.vInterface.hideCharInfoButton();
            this.initGraf();
            this.vGlobs = this.vGame.vTerrain.vGlobs;
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].vPerso.setVisible(false);
                _loc_1++;
            }
            this.vCurGoal = 1;
            this.restartRound();
            return;
        }// end function

        private function restartRound(param1:Boolean = true) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 3117820;
            var _loc_4:* = 16668166;
            var _loc_5:* = 0;
            while (_loc_5 < this.vGlobs.length)
            {
                
                _loc_2 = new Shape();
                if (vReverse)
                {
                    if (this.vGlobs[_loc_5].vTeam == 1)
                    {
                        _loc_2.graphics.lineStyle(1.5, _loc_4);
                    }
                    else if (this.vGlobs[_loc_5].vTeam == 2)
                    {
                        _loc_2.graphics.lineStyle(1.5, _loc_3);
                    }
                    else if (this.vGlobs[_loc_5].vTeam == 3)
                    {
                        _loc_2.graphics.lineStyle(4, 16777215);
                    }
                    _loc_2.graphics.moveTo(-this.vGlobs[_loc_5].vPos.x, -this.vGlobs[_loc_5].vPos.y);
                }
                else
                {
                    if (this.vGlobs[_loc_5].vTeam == 1)
                    {
                        _loc_2.graphics.lineStyle(1.5, _loc_3);
                    }
                    else if (this.vGlobs[_loc_5].vTeam == 2)
                    {
                        _loc_2.graphics.lineStyle(1.5, _loc_4);
                    }
                    else if (this.vGlobs[_loc_5].vTeam == 3)
                    {
                        _loc_2.graphics.lineStyle(4, 16777215);
                    }
                    _loc_2.graphics.moveTo(this.vGlobs[_loc_5].vPos.x, this.vGlobs[_loc_5].vPos.y);
                }
                this.vGlobs[_loc_5].vShape = _loc_2;
                _loc_5++;
            }
            this.vGame.restartRound(this.nextRound, true, false);
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        private function nextRound() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = NaN;
            var _loc_13:* = null;
            var _loc_14:* = this;
            var _loc_15:* = this.vRound + 1;
            _loc_14.vRound = _loc_15;
            var _loc_1:* = false;
            var _loc_2:* = "";
            _loc_3 = 0;
            while (_loc_3 < this.vGlobs.length)
            {
                
                if (!this.vGlobs[_loc_3].isKilled)
                {
                    this.draw(this.TYPE_SPOT, this.vGlobs[_loc_3]);
                }
                _loc_3++;
            }
            if (this.vData.orders == null || this.vRound >= this.vData.orders.length)
            {
                _loc_1 = true;
            }
            else if (this.vData.orders[this.vRound].seat1 == null)
            {
                _loc_1 = true;
            }
            else if (this.vData.orders[this.vRound].seat2 == null)
            {
                _loc_1 = true;
            }
            else
            {
                _loc_2 = this.vData.orders[this.vRound].seat1 + "_" + this.vData.orders[this.vRound].seat2;
            }
            if (_loc_1)
            {
                this.endReplay();
                return;
            }
            _loc_5 = _loc_2.split("_");
            if (_loc_5.length > 0)
            {
                _loc_5 = _loc_5[0].split(":");
                if (_loc_5.length > 0)
                {
                    if (_loc_5[0] == "goal")
                    {
                        var _loc_14:* = this;
                        var _loc_15:* = this.vCurGoal + 1;
                        _loc_14.vCurGoal = _loc_15;
                        if (this.vCurGoal > vPhotoNum)
                        {
                            this.endReplay();
                            return;
                        }
                        this.restartRound();
                        return;
                    }
                    else if (_loc_5[0] == "gameover")
                    {
                        this.endReplay();
                        return;
                    }
                }
            }
            if (this.vSuddenDeathStarted)
            {
                this.vGame.vTerrain.updateSuddenDeath();
            }
            else
            {
                _loc_5 = _loc_2.split("_");
                _loc_10 = new Object();
                _loc_3 = 0;
                while (_loc_3 < _loc_5.length)
                {
                    
                    _loc_11 = _loc_5[_loc_3].split(",");
                    if (_loc_11.length > 2)
                    {
                        if (_loc_11[0] == "timer")
                        {
                            if (_loc_11[2] == 0)
                            {
                                _loc_10["timer" + _loc_11[1]] = true;
                            }
                        }
                    }
                    _loc_3++;
                }
                if (_loc_10.timer1 == true && _loc_10.timer2 == true)
                {
                    this.vSuddenDeathStarted = true;
                }
            }
            _loc_6 = new GBL_Compute(this.vGame, this.vGlobs, _loc_2);
            _loc_6.initResolution();
            this.vGame.vTerrain.beforeResolution();
            _loc_7 = 100;
            _loc_8 = 0;
            _loc_9 = 0;
            while (_loc_9 <= _loc_7)
            {
                
                _loc_12 = _loc_9 / _loc_7;
                if (_loc_12 >= 1)
                {
                    _loc_12 = 1;
                }
                else if (_loc_12 <= 0)
                {
                    _loc_12 = 0;
                }
                _loc_5 = _loc_6.getEvents(_loc_12);
                _loc_3 = 0;
                while (_loc_3 < _loc_5.length)
                {
                    
                    this.executeEvent(_loc_5[_loc_3]);
                    _loc_3++;
                }
                if (_loc_8 == 0)
                {
                    _loc_13 = _loc_6.getPosAtPercentTime(_loc_12);
                    _loc_3 = 0;
                    while (_loc_3 < this.vGlobs.length)
                    {
                        
                        if (!this.vGlobs[_loc_3].isKilled)
                        {
                            this.vGlobs[_loc_3].vPos.x = _loc_13.pos[_loc_3].x;
                            this.vGlobs[_loc_3].vPos.y = _loc_13.pos[_loc_3].y;
                            this.draw(this.TYPE_TRACE, this.vGlobs[_loc_3]);
                            if (vPhotoNum == this.vCurGoal)
                            {
                                if (this.vGlobs[_loc_3].vTeam == 3)
                                {
                                    if (vReverse)
                                    {
                                        this.vBall.x = -this.vGlobs[_loc_3].vPos.x;
                                        this.vBall.y = -this.vGlobs[_loc_3].vPos.y;
                                    }
                                    else
                                    {
                                        this.vBall.x = this.vGlobs[_loc_3].vPos.x;
                                        this.vBall.y = this.vGlobs[_loc_3].vPos.y;
                                    }
                                }
                            }
                        }
                        else
                        {
                            this.vGlobs[_loc_3].vPos.x = _loc_13.pos[_loc_3].x;
                            this.vGlobs[_loc_3].vPos.y = _loc_13.pos[_loc_3].y;
                        }
                        _loc_3++;
                    }
                }
                else
                {
                    _loc_12 = 1;
                }
                if (_loc_12 == 1)
                {
                    this.nextRound();
                }
                _loc_9++;
            }
            _loc_6.destroy();
            return;
        }// end function

        private function executeEvent(param1:Object) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            if (param1.type == "killed")
            {
                _loc_3 = this.vGlobs[param1.args.id].vPos;
                this.draw(this.TYPE_DEAD, this.vGlobs[param1.args.id]);
                this.vGlobs[param1.args.id].isKilled = true;
                if (vPhotoNum == this.vCurGoal)
                {
                    if (this.vGlobs[param1.args.id].vTeam == 3)
                    {
                        if (vReverse)
                        {
                            this.vBall.x = -_loc_3.x;
                            this.vBall.y = -_loc_3.y;
                        }
                        else
                        {
                            this.vBall.x = _loc_3.x;
                            this.vBall.y = _loc_3.y;
                        }
                    }
                }
            }
            else
            {
                return;
            }
            if (param1.type == "soundImpactSoft")
            {
            }
            else if (param1.type == "soundImpact")
            {
            }
            else if (param1.type == "soundWall")
            {
            }
            else if (param1.type == "soundBall")
            {
            }
            return;
        }// end function

        private function afterResolution(param1:int) : void
        {
            if (param1 == 0)
            {
                this.nextRound();
            }
            else if (this.vGame.vInterface.vScore1 == 2 || this.vGame.vInterface.vScore2 == 2)
            {
                this.endReplay();
            }
            else
            {
                this.restartRound();
            }
            return;
        }// end function

        private function endReplay() : void
        {
            this.showGraf();
            this.setButtons();
            return;
        }// end function

        private function showGraf() : void
        {
            this.vLoading.visible = false;
            var _loc_1:* = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGame.layerPlayers.addChild(this.vGlobs[_loc_1].vShape);
                this.vGlobs[_loc_1].vPerso.setVisible(false);
                _loc_1++;
            }
            this.vBall.visible = false;
            this.vGame.layerPlayers.addChild(this.vGraf);
            this.vGame.layerPlayers.addChild(this.vGrafSpot);
            this.vGame.layerPlayers.addChild(this.vGrafBall);
            this.vGame.layerPlayers.addChild(this.vBall);
            return;
        }// end function

        private function setButtons() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = parseInt(this.vData.score1) + parseInt(this.vData.score2);
            if (_loc_1 <= 0)
            {
                _loc_1 = 1;
            }
            if (_loc_1 > 3)
            {
                _loc_1 = 3;
            }
            if (this.vButtonNum != null)
            {
                if (this.vButtonNum.parent != null)
                {
                    this.vButtonNum.parent.removeChild(this.vButtonNum);
                }
                this.vButtonNum = null;
            }
            this.vButtonNum = new Sprite();
            this.vGame.layerInterface.addChild(this.vButtonNum);
            var _loc_2:* = 70;
            var _loc_4:* = 1;
            while (_loc_4 <= _loc_1)
            {
                
                _loc_3 = new bitmapClip(vImages["button_num_" + _loc_4]);
                if (_loc_4 == vPhotoNum)
                {
                    _loc_3.gotoAndStop(2);
                }
                addButton(this.vButtonNum, _loc_3, new Point(Global.vSize.x / 2 - 30, _loc_2 * (_loc_4 - 1)), this.goPhoto, 1, {photo:_loc_4});
                _loc_4++;
            }
            Global.adjustPos(this.vButtonNum, 1, 0);
            this.vButtonNum.y = this.vButtonNum.y - (_loc_1 - 1) * _loc_2 / 2;
            _loc_3 = new bitmapClip(vImages["button_share"]);
            this.vButtonShare = addButton(this.vGame.layerInterface, _loc_3, new Point(Global.vSize.x / 2 - 30, Global.vSize.y / 2 - 30), this.goShare);
            Global.adjustPos(this.vButtonShare, 1, 1);
            return;
        }// end function

        private function goPhoto(event:Event) : void
        {
            var _loc_2:* = event.currentTarget.vArgs.photo;
            if (_loc_2 == vPhotoNum)
            {
                return;
            }
            Global.vSound.onButton();
            vPhotoNum = _loc_2;
            this.vButtonNum.visible = false;
            this.vButtonShare.visible = false;
            this.vGame.layerInterface.visible = false;
            this.vGame.destroy();
            if (this.vGame.parent)
            {
                this.vGame.parent.removeChild(this.vGame);
            }
            this.vGame = null;
            this.vSuddenDeathStarted = false;
            this.initGame();
            return;
        }// end function

        private function goShare(event:Event) : void
        {
            var _loc_2:* = new MovieClip();
            this.vGameShare = new GBL_Main();
            this.vGameShare.init(this.onGameShareReady);
            Global.vSound.onButton();
            Global.vStats.Stats_Event("Share", "ShareStart");
            return;
        }// end function

        private function onGameShareReady() : void
        {
            this.vGameShare.showGameBG();
            var _loc_1:* = new ShareGraf();
            while (_loc_1.mcGame.numChildren > 0)
            {
                
                _loc_1.mcGame.removeChildAt(0);
            }
            _loc_1.mcGame.addChild(this.vGameShare);
            this.vGameShare.addChild(this.vGame.layerPlayers);
            this.vGameLayerPlayersSave = this.vGame.layerPlayers;
            this.vGame.layerPlayers = new Sprite();
            var _loc_2:* = new MyShare(3, _loc_1, this.onShareDone);
            addChild(_loc_2);
            return;
        }// end function

        private function onShareDone() : void
        {
            this.vGame.addChild(this.vGameLayerPlayersSave);
            this.vGame.layerPlayers = this.vGameLayerPlayersSave;
            return;
        }// end function

    }
}
