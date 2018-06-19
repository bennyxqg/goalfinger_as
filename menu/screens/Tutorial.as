package menu.screens
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;
    import menu.*;
    import menu.tools.*;
    import tools.*;

    public class Tutorial extends MenuXXX
    {
        private var vLastSkipAction:int = 0;
        private var vGame:GBL_Main;
        private var vStep:int = -1;
        private var vStepInside:int = 0;
        private var vWelcome:MovieClip;
        private var vButtonLaunchDone:Boolean = false;
        private var vBot:GBL_Bot;
        private var vBotRetry:int = 0;
        private var vPlayerOrders:String;
        private var vCanShowHelp:Boolean = false;
        public static var vFunnelTimer:int = 0;

        public function Tutorial()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            Global.vRoot.removeLoading();
            Global.vSound.aroundGame();
            this.initGame();
            var _loc_1:* = addButton(this.vGame.layerInterface, new ButtonTextBitmap(Menu_TextButton, "Skip"), new Point(100 - Global.vSize.x / 2, Global.vSize.y / 2 - 40), this.onSkipTutorial, 0.3);
            _loc_1.alpha = 0;
            return;
        }// end function

        private function onSkipTutorial(event:Event) : void
        {
            if (getTimer() - this.vLastSkipAction < 300)
            {
                this.endTutorial();
            }
            else
            {
                this.vLastSkipAction = getTimer();
            }
            return;
        }// end function

        private function initGame() : void
        {
            this.vGame = new GBL_Main();
            addChild(this.vGame);
            Global.vPseudo = "Tutorial";
            this.vGame.activateDemoSolo();
            this.vGame.setCurTeam(1);
            this.vGame.init(this.onGameReady);
            return;
        }// end function

        private function onGameReady() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = "{\"shirt\":\"SA_001\",\"player1\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Roberto\",\"code\":\"PA_001\",\"vitality\":0},\"player3\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Sergio\",\"code\":\"PA_002\",\"vitality\":0},\"player2\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Carlo\",\"code\":\"PA_003\",\"vitality\":0}}";
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(1, _loc_2);
            this.vGame.addTeam(1, _loc_1);
            var _loc_3:* = "{\"shirt\":\"SA_004\",\"player1\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Paulo\",\"code\":\"PA_005\",\"vitality\":0},\"player3\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Alberto\",\"code\":\"PA_006\",\"vitality\":0},\"player2\":{\"speed\":0,\"force\":0,\"category\":\"A\",\"name\":\"Antonio\",\"code\":\"PA_003\",\"vitality\":0}}";
            _loc_1 = new GBL_Team();
            _loc_1.parseTeam(2, _loc_3);
            this.vGame.addTeam(2, _loc_1);
            this.vGame.prepareTeams(this.onTeamsReady);
            return;
        }// end function

        private function onTeamsReady() : void
        {
            this.vGame.showGameBG();
            this.vGame.showTeams(false);
            this.vGame.vInterface.setChallengeMode();
            this.vGame.vInterface.hideCharInfoButton();
            this.vStep = this.loadStep();
            if (Global.vDev)
            {
            }
            TweenMax.delayedCall(0.3, this.nextStep);
            return;
        }// end function

        private function nextStep() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = this;
            var _loc_4:* = this.vStep + 1;
            _loc_3.vStep = _loc_4;
            this.saveStep();
            Global.vStats.Stats_PageView("Tutorial " + this.vStep);
            if (this.vStep == 0)
            {
                vFunnelTimer = getTimer();
            }
            this.vGame.setOrderHandler(null);
            if (this.vStep == 0)
            {
                _loc_1 = new WelcomeScreen();
                _loc_1.txtWelcome.htmlText = "<b>" + Global.getText("txtTutorial_0") + "</b>";
                Global.vLang.checkSans(_loc_1.txtWelcome);
                _loc_2 = new Button_Go();
                _loc_2.mcGo.txLabel.htmlText = "<B>" + Global.getText("txtButtonGo") + "<B>";
                Global.vLang.checkSans(_loc_2.mcGo.txLabel);
                _loc_2.x = _loc_1.mcGo.x;
                _loc_2.y = _loc_1.mcGo.y;
                _loc_1.addChild(_loc_2);
                this.vWelcome = addButton(this, new ButtonGrafBitmap(_loc_1), new Point(Global.vSize.x / 2, Global.vSize.y / 2), this.afterWelcome);
            }
            else if (this.vStep == 1)
            {
                this.vGame.initChallenge();
                this.vGame.vChallenge.setChallengeGlob(1, 1, 0, -100, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(3, 0, 0, -250, 0, 0);
                this.vCanShowHelp = true;
                this.vButtonLaunchDone = false;
                this.vGame.setOrderHandler(this.onSingleOrder);
                new MsgBox(this, this.getStepInvite(1), this.launchChallenge);
                Global.vStats.Stats_Event("Tuto", "Step_1", "Start");
            }
            else if (this.vStep == 2)
            {
                this.vGame.initChallenge();
                this.vGame.vChallenge.setChallengeGlob(1, 1, 0, -100, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(3, 0, 0, -250, 0, 0);
                this.vButtonLaunchDone = false;
                this.vGame.setOrderHandler(this.onSingleOrder);
                this.vCanShowHelp = true;
                new MsgBox(this, Global.getText("txtTutorial_1b"), this.launchChallenge);
                Global.vStats.Stats_Event("Tuto", "Step_1b", "Start");
            }
            else if (this.vStep == 3)
            {
                this.vGame.initChallenge();
                this.vGame.vChallenge.setChallengeGlob(2, 1, -80, -290, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(1, 1, -150, -150, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(2, 2, 80, -290, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(1, 2, 150, -150, 0, 0);
                this.vGame.vChallenge.setChallengeGlob(3, 0, 0, -200, 0, 0);
                Global.vAiming = false;
                this.showHelpArrow(this.vGame.getGlob(1, 1).vPos.clone(), new Point(30, -60));
                this.showHelpArrow(this.vGame.getGlob(1, 2).vPos.clone(), new Point(-30, -60));
                this.vGame.deactivateBall();
                this.vGame.vTerrain.resetRoundSpecific(this.noFun, true);
                this.vButtonLaunchDone = false;
                this.vGame.setOrderHandler(this.onSingleOrder);
                this.vStepInside = 0;
                this.vCanShowHelp = true;
                new MsgBox(this, this.getStepInvite(3), this.launchChallenge);
                Global.vStats.Stats_Event("Tuto", "Step_3", "Start");
            }
            else if (this.vStep == 4)
            {
                Global.vHitPoints = false;
                this.vGame.vTerrain.initDimensions();
                new MsgBox(this, this.getStepInvite(4), this.nextStep);
                this.vGame.stopChallenge();
                this.vGame.reactivateBall();
                this.restartRound(false);
                this.vGame.hideAllGlobs();
                this.prepareBot();
                Global.vStats.Stats_Event("Tuto", "Step_4", "Start");
            }
            else if (this.vStep == 5)
            {
                new MsgBox(this, Global.getText("txtTutorial_4b"), this.nextRound);
            }
            else if (this.vStep == 6)
            {
                new MsgBox(this, Global.getText("txtTutorial_End"), this.endTutorial);
                Global.vStats.Stats_Event("Tuto", "Step_End", "Start");
            }
            return;
        }// end function

        private function noFun() : void
        {
            return;
        }// end function

        private function onSingleOrder() : void
        {
            if (!this.vButtonLaunchDone)
            {
                if (this.vStep == 3)
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.vStepInside + 1;
                    _loc_1.vStepInside = _loc_2;
                    this.vGame.vInterface.hideHandSlide();
                    if (this.vStepInside < 2)
                    {
                        return;
                    }
                    this.vCanShowHelp = false;
                }
                this.vButtonLaunchDone = true;
                this.vGame.vInterface.vButtonLaunch.vGraf.alpha = 1;
                this.bumpButtonLaunch();
            }
            this.vGame.vInterface.hideHandSlide();
            return;
        }// end function

        private function bumpButtonLaunch() : void
        {
            if (this.vStep != 1)
            {
                return;
            }
            this.vGame.vInterface.bumpButtonLaunch();
            TweenMax.delayedCall(1.2, this.bumpButtonLaunch);
            return;
        }// end function

        private function saveStep(param1:int = -2) : void
        {
            var _loc_3:* = 0;
            if (param1 == -2)
            {
                param1 = this.vStep;
            }
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            if (param1 == 5)
            {
                param1 = 4;
            }
            if (_loc_2.data.tuto_step != (param1 - 1))
            {
                _loc_3 = Math.round((getTimer() - vFunnelTimer) / 1000);
                vFunnelTimer = getTimer();
                Global.vStats.Stats_Event("Funnel", "Tuto Step " + param1, "Timer", _loc_3);
            }
            _loc_2.data.tuto_step = param1 - 1;
            _loc_2.flush();
            return;
        }// end function

        private function loadStep() : int
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.tuto_step == null)
            {
                return -1;
            }
            return _loc_1.data.tuto_step;
        }// end function

        private function showHelpArrow(param1:Point, param2:Point) : void
        {
            var _loc_3:* = new MovieClip();
            this.vGame.layerPlayers.addChildAt(_loc_3, 0);
            var _loc_4:* = new bitmapClip(this.vGame.vImages["arrow_line"]);
            _loc_4.gotoAndStop("Dotted");
            _loc_3.addChild(_loc_4);
            var _loc_5:* = new bitmapClip(this.vGame.vImages["arrow_end"]);
            _loc_5.gotoAndStop("Dotted");
            _loc_3.addChild(_loc_5);
            _loc_3.x = param1.x;
            _loc_3.y = param1.y;
            _loc_3.rotation = 0;
            _loc_4.width = param2.length;
            _loc_5.x = _loc_4.width - 2;
            _loc_3.rotation = Math.atan2(param2.y, param2.x) * 180 / Math.PI;
            _loc_3.alpha = 0.5;
            this.vGame.vChallenge.vArrowHelp.push(_loc_3);
            TweenMax.from(_loc_3, 0.2, {delay:0.5, alpha:0});
            return;
        }// end function

        private function afterWelcome(event:Event) : void
        {
            TweenMax.to(this.vWelcome, 0.3, {alpha:0, onComplete:this.afterWelcomeDone});
            return;
        }// end function

        private function afterWelcomeDone() : void
        {
            if (this.vWelcome != null)
            {
                removeChild(this.vWelcome);
                this.vWelcome = null;
            }
            TweenMax.delayedCall(0.5, this.nextStep);
            return;
        }// end function

        private function getStepInvite(param1:int) : String
        {
            var _loc_2:* = param1;
            if (param1 >= 3)
            {
                _loc_2 = _loc_2 - 1;
            }
            var _loc_3:* = Global.getText("txtTutorial_Step").replace(/#/, _loc_2.toString());
            _loc_3 = _loc_3 + "<br><br>";
            _loc_3 = _loc_3 + Global.getText("txtTutorial_" + param1);
            return _loc_3;
        }// end function

        private function launchChallenge() : void
        {
            this.showHandHelp();
            this.vGame.startChallenge(this.onChallengeResult);
            if (this.vGame.vInterface.vButtonLaunch != null)
            {
                this.vGame.vInterface.vButtonLaunch.vGraf.alpha = 0;
            }
            return;
        }// end function

        private function showHandHelp() : void
        {
            if (!stage)
            {
                return;
            }
            if (!this.vCanShowHelp)
            {
                return;
            }
            if (this.vStep == 1)
            {
                if (!this.vButtonLaunchDone)
                {
                    this.vGame.vInterface.handSlide(new Point(0, -90), new Point(0, -250));
                    TweenMax.delayedCall(2, this.showHandHelp);
                }
            }
            else if (this.vStep == 2)
            {
                if (!this.vButtonLaunchDone)
                {
                    this.vGame.vInterface.handSlide(new Point(100, 10), new Point(100, -150));
                    TweenMax.delayedCall(2, this.showHandHelp);
                }
            }
            else if (this.vStep == 3)
            {
                if (this.vStepInside == 0)
                {
                    this.vGame.vInterface.handSlide(new Point(-50, -40), new Point(20, -240));
                    TweenMax.delayedCall(2, this.showHandHelp);
                }
                else if (this.vStepInside == 1)
                {
                    this.vGame.vInterface.handSlide(new Point(50, -40), new Point(-20, -240));
                    TweenMax.delayedCall(2, this.showHandHelp);
                }
            }
            return;
        }// end function

        private function onChallengeResult(param1:int) : void
        {
            this.vCanShowHelp = false;
            var _loc_2:* = false;
            if (this.vStep == 1 || this.vStep == 2 || this.vStep == 3)
            {
                if (param1 == 1)
                {
                    _loc_2 = true;
                }
            }
            if (!_loc_2)
            {
                this.onFailStep();
            }
            else
            {
                this.onSuccessStep();
            }
            return;
        }// end function

        private function onFailStep() : void
        {
            Global.vStats.Stats_Event("Tuto", "Step_" + this.vStep, "Fail");
            TweenMax.delayedCall(0.5, this.showFailMsg);
            var _loc_1:* = Global.ConvertPoint(0, (-(Global.vSize.y + Global.vScreenDelta.y * 0.5)) * 0.6, this.vGame.layerInterface, this);
            Global.startParticles(this, new Rectangle(_loc_1.x - Global.vSize.x * 0.4, _loc_1.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_smoke"], 8, 0, 120, 90, 0.5, true, 1.5, 0.5, 0.1, 4, -4, 5, -2, 0.98, "normal", true, true);
            return;
        }// end function

        private function showFailMsg() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this.vStep - 1;
            _loc_1.vStep = _loc_2;
            TweenMax.delayedCall(2, this.nextStep);
            return;
        }// end function

        private function onSuccessStep() : void
        {
            Global.vStats.Stats_Event("Tuto", "Step_" + this.vStep, "Success");
            TweenMax.delayedCall(0.5, this.showSuccessMsg);
            return;
        }// end function

        private function showSuccessMsg() : void
        {
            var _loc_1:* = Global.ConvertPoint(0, (-Global.vSize.y) * 0.6 - Global.vScreenDelta.y / Global.vResolution, this.vGame.layerInterface, this);
            Global.startParticles(this, new Rectangle(_loc_1.x - Global.vSize.x * 0.4, _loc_1.y, Global.vSize.x * 0.8, 32), Global.vImages["particle_confetti"], 8, 0, 240, 90, 0.5, true, 1, 0.1, 0.25, 4, -4, 5, -2, 0.98, "normal", true, true);
            TweenMax.delayedCall(2, this.nextStep);
            return;
        }// end function

        private function endTutorial() : void
        {
            Global.vGame = null;
            this.vGame.stopRunning();
            this.saveStep();
            Login.onTutorialDone();
            Global.vRoot.initServerLoading();
            return;
        }// end function

        private function prepareBot() : void
        {
            this.vBot = new GBL_Bot(GBL_Bot.TYPE_TUTORIAL);
            this.vBot.vFirstShootCoef = 0.7 - 0.1 * this.vBotRetry;
            var _loc_1:* = this;
            var _loc_2:* = this.vBotRetry + 1;
            _loc_1.vBotRetry = _loc_2;
            if (this.vBot.vFirstShootCoef < 0.3)
            {
                this.vBot.vFirstShootCoef = 0.3;
            }
            this.vGame.activateDemoSolo(false);
            this.vGame.vInterface.initInfos();
            this.vGame.vInterface.hideCharInfoButton();
            this.vGame.activateGlobs();
            this.vGame.initPseudos("", "");
            this.vGame.vInterface.vScore1 = 0;
            this.vGame.vInterface.vScore2 = 0;
            this.vGame.vInterface.refreshScore();
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

        private function nextRound() : void
        {
            if (this.vStep == 5 && this.vGame.vNbRound == 10)
            {
                this.nextStep();
                Global.vStats.Stats_Event("Funnel", "Tuto Bot Aborted");
                return;
            }
            this.vGame.nextRound(this.askOrders);
            return;
        }// end function

        private function askOrders(param1:int = 0) : void
        {
            this.vPlayerOrders = "";
            this.vCanShowHelp = true;
            this.vGame.askOrders(this.onOrdersPlayed);
            return;
        }// end function

        private function onOrdersPlayed(param1:String) : void
        {
            this.vPlayerOrders = param1;
            this.vPlayerOrders = this.vPlayerOrders + ("_" + this.vBot.getOrders(this.vGame));
            this.vCanShowHelp = false;
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
                TweenMax.delayedCall(0.5, this.afterGoal);
            }
            else if (param1 == 3 - this.vGame.vCurTeam)
            {
                TweenMax.delayedCall(0.5, this.afterGoal);
            }
            else if (param1 == 3)
            {
                new MsgBox(this, Global.getText("MsgGameScoreTie"), this.afterGoal);
            }
            else
            {
                this.nextRound();
            }
            return;
        }// end function

        private function afterGoal() : void
        {
            if (this.vGame.vInterface.vScore1 > 0)
            {
                Global.vStats.Stats_Event("Tuto", "Step_" + this.vStep, "Success");
                this.nextStep();
                return;
            }
            if (this.vGame.vInterface.vScore2 == 1)
            {
                var _loc_1:* = this;
                var _loc_2:* = this.vStep - 1;
                _loc_1.vStep = _loc_2;
                this.onFailStep();
                return;
            }
            this.restartRound();
            return;
        }// end function

    }
}
