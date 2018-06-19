package menu.tools
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import globz.*;
    import menu.screens.*;
    import sparks.*;
    import tools.*;

    public class Countdown extends MovieClip
    {
        private var vCallback:Function;
        private var vTime0:Number;
        private var vTime:Number;
        private var vGraf:CountdownGraf;
        private var vSpeedUp:SpeedUpGraf;
        private var vSpeedUpChar:Sparks_Char;
        private var vPersoForm:PersoForm;
        private var vWaitingCallback:Function;
        private var vAutoStart:Boolean;
        private var vTextOnly:Boolean;
        private var vTextColor:String;
        public var vPanel:SlidePanel;
        private var vTickRotation:int = 0;
        private var vTimerPos:int = 0;
        private var vLastSeconds:int = 0;
        private var vLastText:String = "";
        private var vSpeedUpRunning:Boolean = false;
        public var vFinishButtonDeltaY:int = 15;
        private var vFinishCallbackForced:Function;
        private var vCallbackOnFinished:Function;
        private var vFinishButton:ButtonTextBitmap;

        public function Countdown(param1:Function, param2:Number, param3:Boolean = true, param4:Sparks_Char = null, param5:PersoForm = null, param6:Function = null, param7:Boolean = false, param8:String = "#FFFFFF")
        {
            this.vCallback = param1;
            if (param6 != null)
            {
                this.vWaitingCallback = param6;
            }
            this.vTime = param2;
            if (param4 != null)
            {
                this.vSpeedUpChar = param4;
            }
            if (param5 != null)
            {
                this.vPersoForm = param5;
            }
            this.vAutoStart = param3;
            this.vTextOnly = param7;
            this.vTextColor = param8;
            this.init();
            return;
        }// end function

        private function init() : void
        {
            if (this.vAutoStart)
            {
                this.vTime0 = getTimer();
                addEventListener(Event.ENTER_FRAME, this.onFrame);
                addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            }
            this.vGraf = new CountdownGraf();
            if (this.vTextOnly)
            {
                this.vGraf.gotoAndStop(2);
            }
            addChild(this.vGraf);
            if (this.vSpeedUpChar != null)
            {
                this.vSpeedUp = new SpeedUpGraf();
                this.vGraf.addChild(this.vSpeedUp);
                if (Capabilities.isDebugger)
                {
                    this.vGraf.addEventListener(MouseEvent.CLICK, this.onClickSpeedUp);
                }
                else
                {
                    this.vGraf.addEventListener(TouchEvent.TOUCH_TAP, this.onClickSpeedUp);
                }
            }
            if (this.vAutoStart && !this.vTextOnly)
            {
                this.nextTick();
            }
            this.refreshTime();
            return;
        }// end function

        public function setRefreshIcon() : void
        {
            if (this.vGraf == null)
            {
                return;
            }
            this.vGraf.mcClock.gotoAndStop("Refresh");
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            var _loc_2:* = getTimer() - this.vTime0;
            this.vTime0 = this.vTime0 + _loc_2;
            _loc_2 = _loc_2 / 1000;
            this.vTime = this.vTime - _loc_2;
            if (this.vTime < 0)
            {
                this.vTime = 0;
            }
            this.refreshTime();
            if (this.vTime == 0)
            {
                this.stopTimer();
                if (this.vCallback != null)
                {
                    this.vCallback.call();
                }
            }
            return;
        }// end function

        private function nextTick() : void
        {
            if (this.vGraf.mcClock.mcArrow == null)
            {
                return;
            }
            this.vTickRotation = this.vTickRotation + 90;
            if (this.vTickRotation >= 360)
            {
                this.vTickRotation = this.vTickRotation - 360;
            }
            TweenMax.to(this.vGraf.mcClock.mcArrow, 0.3, {rotation:this.vTickRotation, ease:Bounce.easeOut});
            TweenMax.delayedCall(1, this.nextTick);
            return;
        }// end function

        private function refreshTime() : void
        {
            if (this.vTime <= 0)
            {
                this.onJobFinished();
                return;
            }
            var _loc_1:* = Math.round(this.vTime);
            if (_loc_1 == this.vLastSeconds)
            {
                return;
            }
            this.vLastSeconds = _loc_1;
            var _loc_2:* = Global.formatDuration(_loc_1);
            if (this.vTextOnly)
            {
                _loc_2 = Global.getText("txtPromoPackTimeLeft").replace(/#/, _loc_2);
                _loc_2 = "<font color=\"" + this.vTextColor + "\">" + _loc_2 + "</font>";
            }
            if (this.vLastText == _loc_2)
            {
                return;
            }
            this.vLastText = _loc_2;
            this.vGraf.txtTime.htmlText = _loc_2;
            if (this.vTimerPos == 0)
            {
                this.vTimerPos = this.vGraf.txtTime.y;
            }
            Global.vLang.checkSans(this.vGraf.txtTime);
            Toolz.textReduce(this.vGraf.txtTime);
            this.vGraf.txtTime.y = this.vTimerPos;
            if (this.vSpeedUp != null)
            {
                if (this.vSpeedUpChar.vStatus == "active")
                {
                    this.vSpeedUp.visible = false;
                }
                else if (this.vSpeedUpChar.vStatus == "injury")
                {
                    this.vSpeedUp.gotoAndStop(2);
                }
                else
                {
                    _loc_1 = Math.round(this.vTime);
                    this.vSpeedUp.txtCost.htmlText = "<B>" + Global.vServer.getSpeedUpCost(_loc_1) + "</B>";
                    Global.vLang.checkSans(this.vSpeedUp.txtCost);
                }
            }
            return;
        }// end function

        private function onJobFinished() : void
        {
            if (this.vSpeedUpChar != null)
            {
                this.vSpeedUpChar.finishCurJob();
                if (this.vPersoForm != null)
                {
                    this.vPersoForm.refresh();
                }
            }
            removeEventListener(Event.ENTER_FRAME, this.onFrame);
            if (this.vFinishCallbackForced != null)
            {
                this.showFinishButton();
            }
            if (this.vCallbackOnFinished != null)
            {
                this.vCallbackOnFinished.call();
                return;
            }
            return;
        }// end function

        private function destroy(event:Event) : void
        {
            this.stopTimer();
            return;
        }// end function

        public function stopTimer() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onFrame);
            return;
        }// end function

        private function onClickSpeedUp(event:Event) : void
        {
            if (this.vPanel != null)
            {
                if (this.vPanel.isSlideDone)
                {
                    return;
                }
            }
            Global.vSound.onButton();
            this.askSpeedUp();
            return;
        }// end function

        public function askSpeedUp() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            if (this.vSpeedUpRunning)
            {
                visible = false;
                return;
            }
            if (this.vSpeedUpChar.vStatus == "injury")
            {
                if (Global.vServer.vUser.getCards("BV") > 0)
                {
                    _loc_1 = Global.getText("txtSpeedUpUseCardBV").replace(/#/, Global.vServer.vUser.getCards("BV"));
                    _loc_2 = MsgBox.getPerso(this.vSpeedUpChar.vCharId, Global.vServer.vUser.vCurShirt);
                    _loc_8 = new PersoFormGrafStatus();
                    _loc_8.gotoAndStop("injury");
                    var _loc_9:* = 2.5;
                    _loc_8.scaleY = 2.5;
                    _loc_8.scaleX = _loc_9;
                    new MsgBox(Global.vRoot.vMenu, _loc_1, this.onSpeedUpConfirm, MsgBox.TYPE_AskBeforeBuy, {charId:this.vSpeedUpChar.vCharId, graf:_loc_8});
                }
                else
                {
                    _loc_1 = Global.getText("txtNotEnoughCardBV");
                    new MsgBox(Global.vRoot.vMenu, _loc_1);
                }
            }
            else
            {
                _loc_3 = Global.vServer.getSpeedUpCost(Math.round(this.vTime));
                if (_loc_3 > Global.vServer.vUser.vHardCurrency)
                {
                    _loc_4 = _loc_3 - Global.vServer.vUser.vHardCurrency;
                    _loc_1 = Global.getText("txtNotEnoughGold").replace(/#/, _loc_4.toString());
                    _loc_1 = _loc_1 + "<br><br>" + Global.getText("txtAskGoShop");
                    _loc_5 = new LowBar_Icons();
                    _loc_5.gotoAndStop(1);
                    var _loc_9:* = 2;
                    _loc_5.scaleY = 2;
                    _loc_5.scaleX = _loc_9;
                    new MsgBox(Global.vRoot.vMenu, _loc_1, this.goBuyGold, MsgBox.TYPE_YesNoWithGraf, {graf:_loc_5});
                }
                else
                {
                    _loc_1 = Global.getText("txtSpeedUpConfirm").replace(/#/, _loc_3);
                    if (this.vSpeedUpChar.vStatus == "training")
                    {
                        _loc_6 = 0;
                        _loc_7 = 1;
                        if (this.vSpeedUpChar.vJob.Attribute == "Force")
                        {
                            _loc_6 = this.vSpeedUpChar.getForce();
                            _loc_7 = 1;
                        }
                        else if (this.vSpeedUpChar.vJob.Attribute == "Speed")
                        {
                            _loc_6 = this.vSpeedUpChar.getSpeed();
                            _loc_7 = 2;
                        }
                        else if (this.vSpeedUpChar.vJob.Attribute == "Vitality")
                        {
                            _loc_6 = this.vSpeedUpChar.getVitality();
                            _loc_7 = 3;
                        }
                        _loc_8 = new PersoFormGrafStatus();
                        _loc_8.gotoAndStop(this.vSpeedUpChar.vJob.Attribute);
                        var _loc_9:* = 2.5;
                        _loc_8.scaleY = 2.5;
                        _loc_8.scaleX = _loc_9;
                        new MsgBox(Global.vRoot.vMenu, _loc_1, this.onSpeedUpConfirm, MsgBox.TYPE_AskTraining, {charId:this.vSpeedUpChar.vCharId, graf:_loc_8, valueFrom:_loc_6, frameTextUpgrade:_loc_7});
                    }
                    else if (this.vSpeedUpChar.vStatus == "recruit")
                    {
                        _loc_2 = MsgBox.getPerso(this.vSpeedUpChar.vCharId, Global.vServer.vUser.vCurShirt);
                        new MsgBox(Global.vRoot.vMenu, _loc_1, this.onSpeedUpConfirm, MsgBox.TYPE_AskBeforeBuy, {charId:this.vSpeedUpChar.vCharId, graf:_loc_2, subtext:this.vSpeedUpChar.vName});
                    }
                    else
                    {
                        _loc_2 = MsgBox.getPerso(this.vSpeedUpChar.vCharId, Global.vServer.vUser.vCurShirt);
                        new MsgBox(Global.vRoot.vMenu, _loc_1, this.onSpeedUpConfirm, MsgBox.TYPE_BuyWithGold, {goldPrice:_loc_3, graf:_loc_2});
                    }
                }
            }
            return;
        }// end function

        private function goBuyGold(param1:Boolean, param2:Object = null) : void
        {
            if (param1)
            {
                Shop.vDirectGold = true;
                Global.vRoot.launchMenu(Shop);
            }
            return;
        }// end function

        private function onSpeedUpConfirm(param1:Boolean, param2:Object = null) : void
        {
            if (param1)
            {
                this.vSpeedUpRunning = true;
                if (this.vWaitingCallback != null)
                {
                    this.vWaitingCallback.call();
                }
                Global.vServer.doSpeedUp(this.afterSpeedUp, this.vSpeedUpChar);
            }
            return;
        }// end function

        private function afterSpeedUp(param1:Boolean, param2:Object) : void
        {
            var _loc_3:* = null;
            if (!param1)
            {
                new MsgBox(Global.vRoot.vMenu, Global.getText("txtErrorOccured"));
                return;
            }
            if (param2 != null)
            {
                if (param2.NewBalance != null)
                {
                    Global.vServer.vUser.vHardCurrency = param2.NewBalance;
                    Global.vTopBar.refresh();
                }
                if (param2.NewBVBalance != null)
                {
                    Global.vServer.vUser.setCards("BV", param2.NewBVBalance);
                }
            }
            Global.vSound.onGift();
            this.vSpeedUpChar.vJob.Duration = 0;
            this.vTime = 0;
            this.onJobFinished();
            if (this.vPersoForm != null)
            {
                _loc_3 = new Point(0, 0);
                Global.startParticles(this.vPersoForm, _loc_3, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
            }
            return;
        }// end function

        public function forceFinishCallback(param1:Function) : void
        {
            this.vFinishCallbackForced = param1;
            if (this.vTime <= 0)
            {
                this.refreshTime();
            }
            return;
        }// end function

        public function setCallbackOnFinished(param1:Function) : void
        {
            this.vCallbackOnFinished = param1;
            return;
        }// end function

        private function showFinishButton() : void
        {
            this.stopTimer();
            this.vGraf.visible = false;
            if (this.vSpeedUp != null)
            {
                this.vSpeedUp.visible = false;
            }
            if (this.vFinishButton != null)
            {
                return;
            }
            this.vFinishButton = new ButtonTextBitmap(Menu_TextButtonFinish, Global.getText("txtFinish"));
            this.vFinishButton.y = this.vFinishButtonDeltaY;
            if (this.vPersoForm != null)
            {
                this.vPersoForm.vFinishing = true;
            }
            addChild(this.vFinishButton);
            if (this.vSpeedUpRunning)
            {
                this.vFinishButton.visible = false;
            }
            if (Capabilities.isDebugger)
            {
                this.vFinishButton.addEventListener(MouseEvent.MOUSE_DOWN, this.doFinish);
            }
            else
            {
                this.vFinishButton.addEventListener(TouchEvent.TOUCH_BEGIN, this.doFinish);
            }
            if (this.vSpeedUpChar != null)
            {
                if (this.vSpeedUpChar.vStatus == "active")
                {
                    this.doFinish();
                }
            }
            return;
        }// end function

        private function doFinish(event:Event = null) : void
        {
            if (this.vFinishButton != null)
            {
                removeChild(this.vFinishButton);
                this.vFinishButton = null;
            }
            if (this.vPersoForm != null)
            {
                this.vPersoForm.vFinishing = false;
            }
            if (event != null)
            {
                event.stopImmediatePropagation();
                event.stopPropagation();
            }
            if (this.vSpeedUpChar != null)
            {
                if (this.vSpeedUpChar.vStatus == "active")
                {
                    if (this.vPersoForm != null)
                    {
                        this.vPersoForm.refresh();
                    }
                    return;
                }
            }
            if (this.vFinishCallbackForced != null)
            {
                this.vFinishCallbackForced.call();
                return;
            }
            if (this.vCallbackOnFinished != null)
            {
                this.vCallbackOnFinished.call();
                return;
            }
            return;
        }// end function

    }
}
