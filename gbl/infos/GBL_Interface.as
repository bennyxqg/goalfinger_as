package gbl.infos
{
    import __AS3__.vec.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;
    import menu.tools.*;
    import tools.*;

    public class GBL_Interface extends MovieClip
    {
        public var vGame:GBL_Main;
        private var vLaunchCallback:Function;
        public var vButtonLaunch:GBL_ButtonLaunch;
        private var vRoundTimeTotal:Number = 15;
        private var vLaunchTimeLeft:Number = 0;
        private var vQuitButton:MovieClip;
        private var isChallenge:Boolean = false;
        private var vInfos:Foot2_Interface;
        public var vScore1:int;
        public var vScore2:int;
        private var vRound:int = 1;
        private var vCharInfoButton:MovieClip;
        private var vCharInfoButtonPos:Point;
        private var vTurnCount:Sprite;
        private var vTurnCountMax:int;
        private var vTime0:int;
        public var vTimeTotal:Number = 240;
        private var vTimerBumpStart:int = 21;
        private var vSoundSuddenDeathDone:Boolean = false;
        private var vBoosterCur:int;
        private var vBoosterBG:MovieClip;
        private var vAllBoosters:Vector.<MovieClip>;
        private var vChatButton:MovieClip;
        private var vChatButtonPos:Point;
        private var vChatBox:ChatMessageWindow;
        private var vChatBoxTransition:Boolean = false;
        private var vMsgs:Array;
        private var vRunning:Boolean = true;
        private var vCaptureEvents:Boolean = false;
        private var vCharsInfos:CharsInfo;
        private var vHandSlideSpeed:Number = 500;
        private var vHandSlideLast:MovieClip;
        private var vFakeChat:Object;

        public function GBL_Interface(param1:GBL_Main)
        {
            this.vMsgs = [1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13, 14];
            this.vGame = param1;
            if (Capabilities.isDebugger)
            {
                this.vGame.layerInterface.addEventListener(MouseEvent.MOUSE_DOWN, this.onTrapDown, true);
                Global.vRoot.stage.addEventListener(MouseEvent.MOUSE_UP, this.onTrapUp, true);
            }
            else
            {
                this.vGame.layerInterface.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTrapDown, true);
                Global.vRoot.stage.addEventListener(TouchEvent.TOUCH_END, this.onTrapUp, true);
            }
            return;
        }// end function

        private function onTrapDown(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onTrapDown");
            if (this.vGame.vAction != null)
            {
                this.vGame.vAction.vActive = false;
            }
            return;
        }// end function

        private function onTrapUp(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onTrapUp");
            if (this.vGame.vAction != null)
            {
                this.vGame.vAction.vActive = true;
            }
            return;
        }// end function

        public function addButton(param1:DisplayObjectContainer, param2:DisplayObject, param3:Point, param4:Function, param5:Number = 1, param6 = null) : MovieClip
        {
            var _loc_7:* = new MovieClip();
            _loc_7.addChild(param2);
            _loc_7.x = param3.x;
            _loc_7.y = param3.y;
            if (param6 != null)
            {
                _loc_7.vArgs = param6;
            }
            var _loc_8:* = param5;
            param2.scaleY = param5;
            param2.scaleX = _loc_8;
            param1.addChild(_loc_7);
            if (Capabilities.isDebugger)
            {
                _loc_7.addEventListener(MouseEvent.MOUSE_DOWN, param4);
                _loc_7.addEventListener(MouseEvent.MOUSE_DOWN, this.onButtonTrace);
            }
            else
            {
                _loc_7.addEventListener(TouchEvent.TOUCH_BEGIN, param4);
                _loc_7.addEventListener(MouseEvent.MOUSE_DOWN, this.onButtonTrace);
            }
            return _loc_7;
        }// end function

        private function onButtonTrace(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onButtonTrace");
            return;
        }// end function

        public function startButtonLaunch(param1:Function, param2:Number = 0) : void
        {
            var _loc_3:* = 0;
            this.vLaunchCallback = param1;
            var _loc_4:* = GBL_Main.vTimerDuration;
            var _loc_5:* = false;
            _loc_3 = 0;
            while (_loc_3 < this.vGame.vTerrain.vGlobs.length)
            {
                
                if (this.vGame.vTerrain.vGlobs[_loc_3].vTeam == this.vGame.vCurTeam)
                {
                    if (this.vGame.vTerrain.vGlobs[_loc_3].canPlay())
                    {
                        _loc_5 = true;
                    }
                }
                _loc_3++;
            }
            if (this.vGame.isChallenge())
            {
                _loc_5 = true;
            }
            if (!_loc_5)
            {
                TweenMax.delayedCall(0.1, this.autoLaunch);
                return;
            }
            if (this.vButtonLaunch != null)
            {
                this.vButtonLaunch.destroy();
                this.vButtonLaunch = null;
            }
            this.vButtonLaunch = new GBL_ButtonLaunch(this.vGame, _loc_4, this.vLaunchCallback, param2);
            if (this.vChatBox != null)
            {
                this.vGame.layerInterface.setChildIndex(this.vChatBox, (this.vGame.layerInterface.numChildren - 1));
            }
            if (this.vGame.isChallenge() || Global.vBotOffline)
            {
                this.vButtonLaunch.setUnlimited();
            }
            var _loc_6:* = 1;
            if (GBL_Main.isReverse)
            {
                _loc_6 = 2;
            }
            _loc_3 = 0;
            while (_loc_3 < this.vGame.vTerrain.vGlobs.length)
            {
                
                if (this.vGame.vTerrain.vGlobs[_loc_3].vTeam == _loc_6)
                {
                    this.vGame.vTerrain.vGlobs[_loc_3].vPerso.setGlow(true);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function getTimerLaunchLeft() : Number
        {
            return this.vLaunchTimeLeft;
        }// end function

        private function autoLaunch() : void
        {
            this.vLaunchTimeLeft = GBL_Main.vTimerDuration;
            this.vLaunchCallback.call();
            return;
        }// end function

        public function bumpButtonLaunch() : void
        {
            if (this.vButtonLaunch == null)
            {
                return;
            }
            if (this.vButtonLaunch.vGraf != null)
            {
                this.vButtonLaunch.doBump();
            }
            return;
        }// end function

        public function removeButtonLaunch() : void
        {
            if (this.vButtonLaunch != null)
            {
                this.vLaunchTimeLeft = this.vButtonLaunch.getTimeLeft();
                this.vButtonLaunch.remove();
                this.vButtonLaunch = null;
            }
            var _loc_1:* = 0;
            while (_loc_1 < this.vGame.vTerrain.vGlobs.length)
            {
                
                if (this.vGame.vTerrain.vGlobs[_loc_1].vPerso != null)
                {
                    this.vGame.vTerrain.vGlobs[_loc_1].vPerso.setGlow(false);
                }
                _loc_1++;
            }
            return;
        }// end function

        public function removeAll() : void
        {
            this.removeButtonLaunch();
            if (this.vInfos != null)
            {
                this.vGame.layerInfos.removeChild(this.vInfos);
                this.vInfos = null;
            }
            this.destroy();
            return;
        }// end function

        public function addQuit(param1:Function) : void
        {
            if (this.vGame == null)
            {
                return;
            }
            if (this.vGame.layerInterface == null)
            {
                return;
            }
            if (this.vGame.vImages == null)
            {
                return;
            }
            this.vQuitButton = this.addButton(this.vGame.layerInterface, new bitmapClip(this.vGame.vImages["button_quit"]), new Point(Global.vSize.x / 2 - 30, (-Global.vSize.y) / 2 + 30), param1);
            if (Global.v169e)
            {
                Global.adjustPos(this.vQuitButton, 0, -1);
            }
            else
            {
                Global.adjustPos(this.vQuitButton, 1, 0);
            }
            if (Global.vDebug)
            {
                this.addButton(this.vGame.layerInterface, new bitmapClip(this.vGame.vImages["button_info"]), new Point(this.vQuitButton.x, this.vQuitButton.y + 100), this.doTrace);
            }
            return;
        }// end function

        private function doTrace(event:Event) : void
        {
            var _loc_2:* = this.vGame.getTraceBefore();
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _loc_2);
            return;
        }// end function

        public function removeQuit() : void
        {
            if (this.vQuitButton != null)
            {
                this.vGame.layerInterface.removeChild(this.vQuitButton);
                this.vQuitButton = null;
            }
            return;
        }// end function

        public function setChallengeMode() : void
        {
            this.isChallenge = true;
            this.vInfos.visible = false;
            if (this.vTurnCount != null)
            {
                this.vTurnCount.visible = false;
            }
            return;
        }// end function

        public function initInfos(param1:Boolean = true) : void
        {
            var _loc_2:* = null;
            if (this.vGame.vImages == null)
            {
                return;
            }
            if (this.vInfos != null)
            {
                this.vGame.layerInfos.removeChild(this.vInfos);
                this.vInfos = null;
            }
            this.vInfos = new Foot2_Interface();
            this.vInfos.visible = param1;
            this.vInfos.alpha = 0.5;
            this.vGame.layerInfos.addChild(this.vInfos);
            this.vInfos.txtPseudo1.text = "";
            this.vInfos.txtPseudo2.text = "";
            this.vInfos.txtRank1.text = "";
            this.vInfos.txtRank2.text = "";
            this.vInfos.mcTimer.vScore1 = 0;
            this.vScore2 = 0;
            this.refreshScore();
            this.vInfos.mcTimer.txtTimerMinut.text = "";
            this.vInfos.mcTimer.txtTimerSecond.text = "";
            this.vInfos.txtSuddenDeath.text = "";
            this.setRound(0);
            this.vCharInfoButtonPos = new Point((-Global.vSize.x) / 2 + 30, (-Global.vSize.y) / 2 + 30);
            this.vCharInfoButton = this.addButton(this, new bitmapClip(this.vGame.vImages["button_info"]), this.vCharInfoButtonPos, this.showCharsInfos);
            if (Global.v169e)
            {
                Global.adjustPos(this.vCharInfoButton, 0, -1);
            }
            else
            {
                Global.adjustPos(this.vCharInfoButton, -1, 0);
            }
            this.vCharInfoButtonPos.x = this.vCharInfoButton.x;
            this.vCharInfoButtonPos.y = this.vCharInfoButton.y;
            if (Global.vBotOffline)
            {
                _loc_2 = this.vCharInfoButtonPos.clone();
                _loc_2.x = _loc_2.x + 100;
                this.addButton(this, new bitmapClip(this.vGame.vImages["button_info"]), _loc_2, this.onBotOfflineSave);
                _loc_2.x = _loc_2.x + 100;
                this.addButton(this, new bitmapClip(this.vGame.vImages["button_info"]), _loc_2, this.onBotOfflineLoad);
            }
            this.initEvents();
            if (Global.vServer != null)
            {
                if (Global.vServer.vFakeGame)
                {
                    this.initFakeChat();
                }
            }
            return;
        }// end function

        public function hideCharInfoButton() : void
        {
            if (this.vCharInfoButton != null)
            {
                this.vCharInfoButton.visible = false;
            }
            return;
        }// end function

        public function setPseudos(param1:String, param2:String, param3:Boolean, param4:String, param5:String) : void
        {
            if (param3)
            {
                this.vInfos.txtPseudo1.text = param2;
                this.vInfos.txtPseudo2.text = param1;
                this.vInfos.txtRank1.text = param5;
                this.vInfos.txtRank2.text = param4;
                if (param4 == "")
                {
                    this.vInfos.mcRank2.visible = false;
                }
                if (param5 == "")
                {
                    this.vInfos.mcRank1.visible = false;
                }
            }
            else
            {
                this.vInfos.txtPseudo1.text = param1;
                this.vInfos.txtPseudo2.text = param2;
                this.vInfos.txtRank1.text = param4;
                this.vInfos.txtRank2.text = param5;
                if (param4 == "")
                {
                    this.vInfos.mcRank1.visible = false;
                }
                if (param5 == "")
                {
                    this.vInfos.mcRank2.visible = false;
                }
            }
            return;
        }// end function

        public function setRound(param1:int) : void
        {
            this.vRound = param1;
            this.refreshTurnCount();
            if (!this.vGame.vSuddenDeathEffective)
            {
                if (this.vGame.vSuddenDeath)
                {
                    if (this.vGame.vSuddenDeathBothTeam)
                    {
                        this.vGame.vSuddenDeathEffective = true;
                    }
                }
            }
            return;
        }// end function

        public function refreshScore() : void
        {
            this.vInfos.txtScore1.text = this.vScore1.toString();
            this.vInfos.txtScore2.text = this.vScore2.toString();
            return;
        }// end function

        public function addScore(param1:int, param2:Boolean, param3:Boolean = false) : void
        {
            if (param2)
            {
                param1 = 3 - param1;
            }
            if (param1 == 1)
            {
                if (!param3)
                {
                    Global.vSound.onGoalWon();
                }
                var _loc_4:* = this;
                var _loc_5:* = this.vScore1 + 1;
                _loc_4.vScore1 = _loc_5;
            }
            if (param1 == 2)
            {
                if (!param3)
                {
                    Global.vSound.onGoalLost();
                }
                var _loc_4:* = this;
                var _loc_5:* = this.vScore2 + 1;
                _loc_4.vScore2 = _loc_5;
            }
            this.refreshScore();
            return;
        }// end function

        private function onBotOfflineSave(event:Event) : void
        {
            Global.vGame.saveInstantPos();
            return;
        }// end function

        private function onBotOfflineLoad(event:Event) : void
        {
            Global.vGame.loadInstantPos();
            return;
        }// end function

        private function initTurnCount(param1:int) : void
        {
            this.vTurnCountMax = param1;
            this.vTurnCount = new Sprite();
            this.vTurnCount.x = -292;
            this.vGame.layerInterface.addChild(this.vTurnCount);
            this.vTurnCount.addChild(new bitmapClip(this.vGame.vImages["turncount_graf"]));
            this.refreshTurnCount();
            return;
        }// end function

        private function refreshTurnCount() : void
        {
            var _loc_4:* = null;
            if (this.vTurnCount == null)
            {
                return;
            }
            while (this.vTurnCount.numChildren > 1)
            {
                
                this.vTurnCount.removeChildAt(1);
            }
            var _loc_1:* = 205;
            var _loc_2:* = 3;
            var _loc_3:* = (_loc_1 - (this.vTurnCountMax - 1) * _loc_2) / this.vTurnCountMax;
            var _loc_5:* = this.vTurnCountMax - this.vRound + 1;
            var _loc_6:* = 0;
            while (_loc_6 < this.vTurnCountMax)
            {
                
                if (_loc_6 < _loc_5)
                {
                    _loc_4 = new bitmapClip(this.vGame.vImages["turncount_bar"]);
                    _loc_4.height = _loc_3;
                    _loc_4.y = (-_loc_3) / 2 - _loc_6 * (_loc_3 + _loc_2) + _loc_1 / 2;
                    this.vTurnCount.addChild(_loc_4);
                }
                _loc_6++;
            }
            return;
        }// end function

        public function startTimer(param1:int = 0) : void
        {
            if (!stage)
            {
                return;
            }
            if (Global.vDev)
            {
            }
            this.vTimeTotal = this.vTimeTotal - param1;
            this.vTime0 = getTimer();
            addEventListener(Event.ENTER_FRAME, this.onFrameTimer);
            stage.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
            return;
        }// end function

        public function stopTimer() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onFrameTimer);
            this.removeButtonLaunch();
            return;
        }// end function

        public function hideTimer() : void
        {
            if (this.vInfos == null)
            {
                return;
            }
            this.vInfos.mcTimer.visible = false;
            this.vInfos.txtSuddenDeath.visible = false;
            return;
        }// end function

        public function showTimer() : void
        {
            if (this.vInfos == null)
            {
                return;
            }
            this.vInfos.mcTimer.visible = true;
            this.vInfos.txtSuddenDeath.visible = true;
            return;
        }// end function

        public function getSecondsPlayed() : int
        {
            var _loc_1:* = Math.round((getTimer() - this.vTime0) / 1000);
            return _loc_1;
        }// end function

        private function onFrameTimer(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onFrameTimer");
            if (!parent)
            {
                return;
            }
            this.refreshTimer();
            return;
        }// end function

        public function setTimerZero() : void
        {
            this.vInfos.mcTimer.txtTimerMinut.htmlText = "0\'";
            this.vInfos.mcTimer.txtTimerSecond.htmlText = "00";
            this.vInfos.txtSuddenDeath.htmlText = "";
            return;
        }// end function

        private function refreshTimer() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            if (this.vGame.isChallenge())
            {
                return;
            }
            if (!this.vInfos.mcTimer.visible)
            {
                return;
            }
            var _loc_1:* = this.getSecondsPlayed();
            var _loc_2:* = this.vTimeTotal - _loc_1;
            if (_loc_2 <= 0)
            {
                if (this.vGame.vSuddenDeathEffective)
                {
                    this.vInfos.mcTimer.txtTimerMinut.htmlText = "";
                    this.vInfos.mcTimer.txtTimerSecond.htmlText = "";
                    this.vInfos.txtSuddenDeath.htmlText = "<font color=\'#FF0000\'>" + Global.getText("txtSuddenDeath") + "</color>";
                    Global.vLang.checkSans(this.vInfos.txtSuddenDeath);
                    Toolz.textReduce(this.vInfos.txtSuddenDeath);
                    if (!this.vSoundSuddenDeathDone)
                    {
                        this.vSoundSuddenDeathDone = true;
                        Global.vSound.onSuddenDeathStarted();
                    }
                }
                else if (!this.vGame.vSuddenDeath)
                {
                    this.vGame.vSuddenDeath = true;
                    this.setTimerZero();
                }
            }
            else
            {
                _loc_3 = Math.floor(_loc_2 / 60);
                this.vInfos.mcTimer.txtTimerMinut.htmlText = _loc_3.toString() + "\'";
                _loc_1 = _loc_2 - _loc_3 * 60;
                _loc_4 = "";
                if (_loc_1 < 10)
                {
                    _loc_4 = "0";
                }
                _loc_4 = _loc_4 + _loc_1.toString();
                this.vInfos.mcTimer.txtTimerSecond.htmlText = _loc_4;
                this.vInfos.txtSuddenDeath.htmlText = "";
            }
            if (_loc_2 > 0 && _loc_2 < this.vTimerBumpStart)
            {
                (this.vTimerBumpStart - 1);
                Toolz.doBumpOnce(this.vInfos.mcTimer);
            }
            return;
        }// end function

        private function onRemoved(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onRemoved");
            this.stopTimer();
            return;
        }// end function

        public function showBoosters() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_5:* = null;
            var _loc_7:* = 0;
            var _loc_4:* = new Point(0, 0);
            this.vAllBoosters = new Vector.<MovieClip>;
            var _loc_6:* = 0;
            while (_loc_6 < 2)
            {
                
                _loc_1 = this.vGame.vTeams[_loc_6].vBoosters;
                _loc_7 = 0;
                while (_loc_7 < _loc_1.length)
                {
                    
                    _loc_2 = new bitmapClip(this.vGame.vImages["booster_" + _loc_6 + "_" + _loc_7]);
                    _loc_3 = new ButtonGrafBitmap(_loc_2);
                    _loc_4 = this.getBoosterPos(_loc_7, _loc_6);
                    _loc_5 = this.addButton(this.vGame.layerInterface, _loc_3, _loc_4, this.onBoosterAction);
                    if (this.vGame.vCurTeam != (_loc_6 + 1))
                    {
                        _loc_5.alpha = 0;
                    }
                    _loc_5.vTeam = _loc_6;
                    _loc_5.vType = _loc_1[_loc_7].type;
                    _loc_5.vUsed = _loc_1[_loc_7].used;
                    _loc_5.vNum = _loc_7;
                    this.vAllBoosters.push(_loc_5);
                    _loc_7++;
                }
                _loc_6++;
            }
            return;
        }// end function

        private function getBoosterPos(param1:int, param2:int) : Point
        {
            var _loc_3:* = new Point(0, 0);
            if (GBL_Main.isReverse)
            {
                param2 = 1 - param2;
            }
            if (Global.v169e)
            {
                _loc_3.x = (-Global.vSize.x) / 2 + 37 + 70 * param1;
                _loc_3.y = Global.vSize.y / 2 - 45;
                if (param2 == 1)
                {
                    _loc_3.x = -_loc_3.x - 60;
                    _loc_3.y = -_loc_3.y - 8;
                }
            }
            else
            {
                _loc_3.x = (-Global.vSize.x) / 2 + 30;
                _loc_3.y = 350 - 80 * param1;
                if (param2 == 1)
                {
                    _loc_3.y = -_loc_3.y;
                }
            }
            var _loc_4:* = new MovieClip();
            if (Global.v169e)
            {
                if (param2 == 0)
                {
                    Global.adjustPos(_loc_4, 0, 1);
                }
                if (param2 == 1)
                {
                    Global.adjustPos(_loc_4, 0, -1);
                }
            }
            else
            {
                Global.adjustPos(_loc_4, -0.5, 0);
            }
            _loc_3.x = _loc_3.x + _loc_4.x;
            _loc_3.y = _loc_3.y + _loc_4.y;
            return _loc_3;
        }// end function

        private function onBoosterAction(event:Event) : void
        {
            var _loc_2:* = event.currentTarget.vTeam;
            var _loc_3:* = this.vGame.vTeams[_loc_2].vBoosters[event.currentTarget.vNum].used;
            var _loc_4:* = event.currentTarget.vType;
            if ((_loc_2 + 1) == this.vGame.vCurTeam && this.vGame.vAction != null && _loc_3 == 0)
            {
                this.askBoosterConfirm(event.currentTarget.vNum);
            }
            return;
        }// end function

        private function askBoosterConfirm(param1:int) : void
        {
            this.vBoosterCur = param1;
            if (Global.vServer == null)
            {
                this.onBoosterConfirm();
                return;
            }
            var _loc_2:* = Global.getText("txtUseBoosterAiming");
            _loc_2 = _loc_2.replace(/#/, Global.vServer.vUser.getCards("BA"));
            new MsgBox(this, _loc_2, this.onBoosterConfirmAnswer, MsgBox.TYPE_YesNo);
            return;
        }// end function

        private function onBoosterConfirmAnswer(param1:Boolean) : void
        {
            if (param1)
            {
                this.onBoosterConfirm();
            }
            else
            {
                this.onBoosterCancel();
            }
            return;
        }// end function

        public function onBoosterCancel(event:Event = null) : void
        {
            if (this.vBoosterBG != null)
            {
                this.vGame.layerInterface.removeChild(this.vBoosterBG);
                this.vBoosterBG = null;
            }
            return;
        }// end function

        private function onBoosterConfirm(event:Event = null) : void
        {
            Global.addLogTrace("onBoosterConfirm vGame.vCurTeam=" + this.vGame.vCurTeam);
            if (this.vGame.vAction == null)
            {
                return;
            }
            this.showBoosterUsed((this.vGame.vCurTeam - 1), this.vBoosterCur);
            var _loc_2:* = this.vGame.vTeams[(this.vGame.vCurTeam - 1)].vBoosters[this.vBoosterCur].type;
            if (Global.vServer != null)
            {
                Global.vServer.consumeBooster(this.afterConsume, _loc_2);
            }
            if (_loc_2 == "BA")
            {
                Global.vAiming = true;
            }
            this.vGame.addOrderExtra("booster:" + (this.vGame.vCurTeam - 1) + ":" + this.vBoosterCur);
            this.onBoosterCancel();
            return;
        }// end function

        public function onBoosterJoining(param1:int, param2:int) : void
        {
            var _loc_3:* = this.vGame.vTeams[param1].vBoosters[param2].type;
            this.showBoosterUsed(param1, param2);
            if (_loc_3 == "BA")
            {
                if (this.vGame.vCurTeam == (param1 + 1))
                {
                    Global.vAiming = true;
                }
            }
            return;
        }// end function

        public function showBoosterUsed(param1:int, param2:int) : void
        {
            if (this.vGame.vTeams[param1].vBoosters[param2].used == 1)
            {
                return;
            }
            this.vGame.vTeams[param1].vBoosters[param2].used = 1;
            if (this.vGame.vCurTeam != (param1 + 1))
            {
                return;
            }
            var _loc_3:* = new bitmapClip(this.vGame.vImages["booster_closed"]);
            if ((this.vGame.vCurTeam - 1) != param1)
            {
                _loc_3.gotoAndStop(2);
            }
            var _loc_4:* = this.getBoosterPos(param2, param1);
            _loc_3.x = _loc_4.x;
            _loc_3.y = _loc_4.y;
            this.vGame.layerInterface.addChild(_loc_3);
            return;
        }// end function

        private function afterConsume(param1:Boolean) : void
        {
            if (!param1)
            {
            }
            return;
        }// end function

        public function disableBoosters() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            Global.addLogTrace("disableBoosters", "GBL_Interface");
            var _loc_4:* = 0;
            while (_loc_4 < this.vAllBoosters.length)
            {
                
                _loc_1 = this.vAllBoosters[_loc_4];
                _loc_3 = this.vGame.vTeams[_loc_1.vTeam].vBoosters[_loc_1.vNum].used;
                if (_loc_3 == 0)
                {
                    if (_loc_1.vTeam == (this.vGame.vCurTeam - 1))
                    {
                        _loc_2 = this.getBoosterPos(_loc_1.vNum, _loc_1.vTeam);
                        TweenMax.to(_loc_1, 0.3, {x:_loc_2.x - 200});
                    }
                }
                _loc_4++;
            }
            TweenMax.to(this.vCharInfoButton, 0.3, {x:this.vCharInfoButtonPos.x - 200});
            return;
        }// end function

        public function enableBoosters() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            Global.addLogTrace("enableBoosters", "GBL_Interface");
            var _loc_4:* = 0;
            while (_loc_4 < this.vAllBoosters.length)
            {
                
                _loc_1 = this.vAllBoosters[_loc_4];
                _loc_3 = this.vGame.vTeams[_loc_1.vTeam].vBoosters[_loc_1.vNum].used;
                if (_loc_3 == 0)
                {
                    if (_loc_1.vTeam == (this.vGame.vCurTeam - 1))
                    {
                        _loc_2 = this.getBoosterPos(_loc_1.vNum, _loc_1.vTeam);
                        TweenMax.to(_loc_1, 0.3, {x:_loc_2.x});
                    }
                }
                _loc_4++;
            }
            TweenMax.to(this.vCharInfoButton, 0.3, {x:this.vCharInfoButtonPos.x});
            return;
        }// end function

        public function showChatMessages() : void
        {
            if (this.vChatBox != null)
            {
                return;
            }
            this.vChatButton = this.addButton(this.vGame.layerInterface, new bitmapClip(this.vGame.vImages["button_chat"]), new Point(Global.vSize.x / 2 - 30, Global.vSize.y / 2 - 30), this.openChatMessage);
            if (Global.v169e)
            {
                Global.adjustPos(this.vChatButton, 0, 1);
            }
            else
            {
                Global.adjustPos(this.vChatButton, 1, 0);
            }
            this.vChatButtonPos = new Point(this.vChatButton.x, this.vChatButton.y);
            return;
        }// end function

        private function openChatMessage(event:Event) : void
        {
            var _loc_2:* = 0;
            if (this.vChatBoxTransition)
            {
                return;
            }
            this.vChatBoxTransition = true;
            this.vChatBox = new ChatMessageWindow();
            this.vChatBox.x = Global.vSize.x / 2;
            this.vChatBox.y = Global.vSize.y / 2 - 60;
            Global.adjustPos(this.vChatBox, 1, 1);
            this.vGame.layerInterface.addChild(this.vChatBox);
            if (this.vMsgs.length > 12)
            {
                this.vMsgs.length = 12;
            }
            var _loc_3:* = 0;
            while (_loc_3 < this.vMsgs.length)
            {
                
                _loc_2 = this.vMsgs[_loc_3];
                this.vChatBox["txt" + (_loc_3 + 1)].htmlText = "<b>" + Global.getText("txtChat_" + _loc_2) + "</b>";
                Global.vLang.checkSans(this.vChatBox["txt" + (_loc_3 + 1)]);
                Toolz.textReduce(this.vChatBox["txt" + (_loc_3 + 1)]);
                _loc_3++;
            }
            if (Capabilities.isDebugger)
            {
                this.vChatBox.bBG.addEventListener(MouseEvent.MOUSE_DOWN, this.closeChatBox);
                _loc_2 = 1;
                while (_loc_2 <= this.vMsgs.length)
                {
                    
                    this.vChatBox["b" + _loc_2].vId = _loc_2;
                    this.vChatBox["b" + _loc_2].addEventListener(MouseEvent.MOUSE_DOWN, this.onChatSelect);
                    _loc_2++;
                }
            }
            else
            {
                this.vChatBox.bBG.addEventListener(TouchEvent.TOUCH_BEGIN, this.closeChatBox);
                _loc_2 = 1;
                while (_loc_2 <= this.vMsgs.length)
                {
                    
                    this.vChatBox["b" + _loc_2].vId = _loc_2;
                    this.vChatBox["b" + _loc_2].addEventListener(TouchEvent.TOUCH_BEGIN, this.onChatSelect);
                    _loc_2++;
                }
            }
            var _loc_4:* = this.vChatBox.y + 530;
            TweenMax.from(this.vChatBox, 0.2, {delay:0, y:_loc_4, onComplete:this.onChatBoxReady});
            return;
        }// end function

        private function onChatBoxReady() : void
        {
            this.vChatBoxTransition = false;
            return;
        }// end function

        private function onChatSelect(event:Event) : void
        {
            Global.addEventTrace("GBL_Interface.onChatSelect");
            if (this.vChatBoxTransition)
            {
                return;
            }
            var _loc_2:* = event.currentTarget.vId;
            this.vChatBox["txt" + _loc_2].textColor = 16711680;
            this.onChatMessage(Global.vServer.vUser.vUserId, _loc_2);
            if (!Global.vServer.vFakeGame)
            {
                Global.vServer.sendChatMessage(_loc_2.toString());
            }
            this.closeChatBox();
            return;
        }// end function

        public function onChatMessage(param1:String, param2:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_10:* = null;
            if (Global.vServer.vFakeGame)
            {
                if (param2 == 1 || param2 == 2)
                {
                    this.fakeHello();
                }
            }
            if (param1 == Global.vServer.vUser.vUserId)
            {
                _loc_3 = this.vGame.vCurTeam;
            }
            else
            {
                _loc_3 = 3 - this.vGame.vCurTeam;
            }
            var _loc_8:* = this.vGame.vTerrain.vGlobs[6].vPos.clone();
            var _loc_9:* = 0;
            while (_loc_9 < this.vGame.vTerrain.vGlobs.length)
            {
                
                _loc_4 = this.vGame.vTerrain.vGlobs[_loc_9];
                if (_loc_4.vTeam == _loc_3)
                {
                    if (!_loc_4.isKilled)
                    {
                        _loc_6 = Point.distance(_loc_8, _loc_4.vPos);
                        if (_loc_5 == null)
                        {
                            _loc_5 = _loc_4;
                            _loc_7 = _loc_6;
                        }
                        else if (_loc_6 > _loc_7)
                        {
                            _loc_5 = _loc_4;
                            _loc_7 = _loc_6;
                        }
                    }
                }
                _loc_9++;
            }
            if (_loc_5 != null)
            {
                _loc_10 = _loc_5.vPos.clone();
            }
            else
            {
                _loc_10 = new Point(0, 440);
                if (_loc_3 == 2)
                {
                    _loc_10.y = -_loc_10.y;
                }
                if (GBL_Main.isReverse)
                {
                    _loc_10.y = -_loc_10.y;
                }
            }
            param2 = this.vMsgs[(param2 - 1)];
            this.showBubble(_loc_10, Global.getText("txtChat_" + param2));
            return;
        }// end function

        public function showBubble(param1:Point, param2:String) : void
        {
            if (GBL_Main.isReverse)
            {
                param1.x = -param1.x;
                param1.y = -param1.y;
            }
            var _loc_3:* = new ChatMessageBubble();
            _loc_3.txt.htmlText = "<b>" + param2 + "</b>";
            Global.vLang.checkSans(_loc_3.txt);
            Toolz.textReduce(_loc_3.txt);
            _loc_3.x = param1.x * GBL_Main.vZoomCoef;
            _loc_3.y = param1.y * GBL_Main.vZoomCoef - 30;
            _loc_3.mouseChildren = false;
            _loc_3.mouseEnabled = false;
            this.vGame.layerInterface.addChild(_loc_3);
            var _loc_4:* = GBL_Main.vZoomCoef;
            _loc_3.scaleY = GBL_Main.vZoomCoef;
            _loc_3.scaleX = _loc_4;
            if (Global.v169e)
            {
                _loc_3.x = _loc_3.x + GBL_Main.vDelta169;
            }
            TweenMax.from(_loc_3, 0.2, {scaleX:0, scaleY:0, ease:Bounce.easeOut});
            TweenMax.to(_loc_3, 0.3, {delay:1.7, alpha:0, onComplete:this.removeBubble, onCompleteParams:[_loc_3]});
            return;
        }// end function

        private function removeBubble(param1:DisplayObject) : void
        {
            if (param1.parent != null)
            {
                param1.parent.removeChild(param1);
            }
            return;
        }// end function

        private function closeChatBox(event:Event = null) : void
        {
            Global.addEventTrace("GBL_Interface.closeChatBox");
            if (this.vChatBoxTransition)
            {
                return;
            }
            this.vChatBoxTransition = true;
            this.vChatBox.bBG.visible = false;
            var _loc_2:* = this.vChatBox.y + 530;
            TweenMax.to(this.vChatBox, 0.2, {y:_loc_2, onComplete:this.onChatBoxClosed});
            return;
        }// end function

        private function onChatBoxClosed() : void
        {
            if (this.vChatBox != null)
            {
                if (this.vGame.layerInterface.contains(this.vChatBox))
                {
                    this.vGame.layerInterface.removeChild(this.vChatBox);
                }
                this.vChatBox = null;
            }
            this.vChatBoxTransition = false;
            return;
        }// end function

        private function initEvents() : void
        {
            if (Capabilities.isDebugger)
            {
                Global.vRoot.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, this.vCaptureEvents, 0, true);
                Global.vRoot.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove, this.vCaptureEvents, 0, true);
                Global.vRoot.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp, this.vCaptureEvents, 0, true);
            }
            else
            {
                Global.vRoot.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, this.vCaptureEvents, 0, true);
                Global.vRoot.addEventListener(TouchEvent.TOUCH_MOVE, this.onTouchMove, this.vCaptureEvents, 0, true);
                Global.vRoot.addEventListener(TouchEvent.TOUCH_END, this.onTouchUp, this.vCaptureEvents, 0, true);
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (Global.vRoot != null)
            {
                if (Capabilities.isDebugger)
                {
                    if (this.vGame != null)
                    {
                        this.vGame.layerInterface.removeEventListener(MouseEvent.MOUSE_DOWN, this.onTrapDown, true);
                    }
                    Global.vRoot.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onTrapUp, true);
                    Global.vRoot.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, this.vCaptureEvents);
                    Global.vRoot.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove, this.vCaptureEvents);
                    Global.vRoot.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp, this.vCaptureEvents);
                }
                else
                {
                    if (this.vGame != null)
                    {
                        this.vGame.layerInterface.removeEventListener(TouchEvent.TOUCH_BEGIN, this.onTrapDown, true);
                    }
                    Global.vRoot.stage.removeEventListener(TouchEvent.TOUCH_END, this.onTrapUp, true);
                    Global.vRoot.removeEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, this.vCaptureEvents);
                    Global.vRoot.removeEventListener(TouchEvent.TOUCH_MOVE, this.onTouchMove, this.vCaptureEvents);
                    Global.vRoot.removeEventListener(TouchEvent.TOUCH_END, this.onTouchUp, this.vCaptureEvents);
                }
            }
            this.vRunning = false;
            this.stopTimer();
            this.removeButtonLaunch();
            return;
        }// end function

        final private function onTouchDown(event:TouchEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onTouchDown");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMDown(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            return;
        }// end function

        final private function onMouseDown(event:MouseEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onMouseDown");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMDown(new MyTouch(_loc_2.x, _loc_2.y, 1));
            return;
        }// end function

        final private function onTouchMove(event:TouchEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onTouchMove");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMMove(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            return;
        }// end function

        final private function onMouseMove(event:MouseEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onMouseMove");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMMove(new MyTouch(_loc_2.x, _loc_2.y, 1));
            return;
        }// end function

        final private function onTouchUp(event:TouchEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onTouchUp");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMUp(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            return;
        }// end function

        final private function onMouseUp(event:MouseEvent) : void
        {
            Global.addEventTrace("GBL_Interface.onMouseUp");
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMUp(new MyTouch(_loc_2.x, _loc_2.y, 1));
            return;
        }// end function

        private function onMDown(param1:MyTouch) : void
        {
            return;
        }// end function

        private function onMMove(param1:MyTouch) : void
        {
            return;
        }// end function

        private function onMUp(param1:MyTouch) : void
        {
            this.hideCharsInfos();
            return;
        }// end function

        public function showCharsInfos(event:Event = null) : void
        {
            if (Global.vDev)
            {
            }
            if (this.vCharsInfos != null)
            {
                this.hideCharsInfos();
                return;
            }
            if (this.vGame.isRunning())
            {
                return;
            }
            this.vCharsInfos = new CharsInfo(this.vGame);
            var _loc_2:* = GBL_Main.vZoomCoef;
            this.vCharsInfos.scaleY = GBL_Main.vZoomCoef;
            this.vCharsInfos.scaleX = _loc_2;
            if (Global.v169e)
            {
                this.vCharsInfos.x = this.vCharsInfos.x + GBL_Main.vDelta169;
            }
            this.vGame.layerInterface.addChild(this.vCharsInfos);
            return;
        }// end function

        public function hideCharsInfos() : void
        {
            if (this.vCharsInfos != null)
            {
                this.vGame.layerInterface.removeChild(this.vCharsInfos);
                this.vCharsInfos = null;
            }
            return;
        }// end function

        public function handSlide(param1:Point, param2:Point, param3:Number = 1) : void
        {
            var _loc_4:* = new HandHelpGraf();
            this.vGame.layerInterface.addChild(_loc_4);
            _loc_4.x = param1.x;
            _loc_4.y = param1.y;
            _loc_4.mouseEnabled = false;
            _loc_4.mouseChildren = false;
            this.vHandSlideLast = _loc_4;
            TweenMax.from(_loc_4, 0.3, {delay:0, alpha:0, onComplete:this.handSlideDo, onCompleteParams:[_loc_4, param1, param2, param3]});
            return;
        }// end function

        public function hideHandSlide() : void
        {
            if (this.vHandSlideLast != null)
            {
                TweenMax.to(this.vHandSlideLast, 0.3, {alpha:0});
            }
            return;
        }// end function

        private function handSlideDo(param1:MovieClip, param2:Point, param3:Point, param4:Number) : void
        {
            TweenMax.to(param1, 0.3, {onComplete:this.handSlideDoAfterTempo, onCompleteParams:[param1, param2, param3, param4]});
            return;
        }// end function

        private function handSlideDoAfterTempo(param1:MovieClip, param2:Point, param3:Point, param4:Number) : void
        {
            var _loc_7:* = null;
            param1.gotoAndStop("press");
            var _loc_5:* = param3.subtract(param2);
            var _loc_6:* = param4 * _loc_5.length / this.vHandSlideSpeed;
            TweenMax.to(param1, _loc_6, {x:param3.x, y:param3.y, onComplete:this.handRelease, onCompleteParams:[param1], ease:Linear.easeNone});
            if (_loc_6 >= 0.2)
            {
                _loc_7 = new HandHelpSwipe();
                _loc_7.scaleX = 0;
                this.vGame.layerInterface.addChildAt(_loc_7, 0);
                _loc_7.x = param1.x;
                _loc_7.y = param1.y;
                _loc_7.rotation = Math.atan2(_loc_5.y, _loc_5.x) * 180 / Math.PI;
                TweenMax.to(_loc_7, _loc_6, {x:param3.x, y:param3.y, ease:Linear.easeNone, onComplete:this.handRemoveClip, onCompleteParams:[_loc_7]});
                TweenMax.to(_loc_7, 0.2, {scaleX:1, ease:Linear.easeIn});
                TweenMax.to(_loc_7, 0.1, {delay:_loc_6 - 0.1, scaleX:0, ease:Linear.easeOut});
            }
            return;
        }// end function

        private function handRemoveClip(param1:DisplayObject) : void
        {
            if (this.vGame.vInterface.contains(param1))
            {
                this.vGame.vInterface.removeChild(param1);
            }
            return;
        }// end function

        private function handRelease(param1:MovieClip) : void
        {
            param1.gotoAndStop("release");
            TweenMax.to(param1, 0.2, {alpha:0, delay:0.4, onComplete:this.handRemoveClip, onCompleteParams:[param1]});
            return;
        }// end function

        public function initFakeChat(param1:Boolean = true) : void
        {
            this.vFakeChat = new Object();
            this.vFakeChat.amount = Math.random() * 0.85;
            if (this.vFakeChat.amount < 0.5)
            {
                this.vFakeChat.amount = 0;
            }
            Global.addLogTrace("BotChatAmount=" + this.vFakeChat.amount, "FakeBot");
            if (param1)
            {
                TweenMax.delayedCall(0.5 + Math.random(), this.fakeHello);
            }
            return;
        }// end function

        public function fakeHello(param1:Boolean = false) : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (this.vFakeChat.helloDone)
            {
                return;
            }
            if (param1)
            {
                if (Math.random() < 0.5)
                {
                    param1 = false;
                }
            }
            if (param1 || Math.random() < this.vFakeChat.amount)
            {
                this.vFakeChat.helloDone = true;
                this.onChatMessage(Global.vServer.vOpponentId, 1 + Math.floor(2 * Math.random()));
            }
            return;
        }// end function

        public function fakeChat() : void
        {
            TweenMax.delayedCall(0.5 + 1.5 * Math.random(), this.fakeChatDo);
            return;
        }// end function

        private function fakeChatDo() : void
        {
            if (!this.vRunning)
            {
                return;
            }
            if (this.vFakeChat.nb == null)
            {
                this.vFakeChat.nb = 0;
            }
            if (Math.random() < this.vFakeChat.amount - this.vFakeChat.nb * 0.1)
            {
                this.vFakeChat.nb = 10 - this.vFakeChat.amount * 8 * Math.random();
                this.onChatMessage(Global.vServer.vOpponentId, 3 + Math.floor(7 * Math.random()));
            }
            var _loc_1:* = this.vFakeChat;
            var _loc_2:* = _loc_1.nb - 1;
            _loc_1.nb = _loc_2;
            if (_loc_1.nb < 0)
            {
                _loc_1.nb = 0;
            }
            return;
        }// end function

    }
}
