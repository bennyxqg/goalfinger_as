package gbl.infos
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;

    public class GBL_ButtonLaunch extends Object
    {
        private var vGame:GBL_Main;
        public var vGraf:bitmapClip;
        private var vTimer:int;
        private var vTimerSpent:Number;
        private var vCallback:Function;
        private var vArgs:Object;
        private var vTime0:int;
        private var vRunning:Boolean;
        private var vTickTimed:Array;
        private var vTickTimedIndex:int = -2;

        public function GBL_ButtonLaunch(param1:GBL_Main, param2:Number, param3:Function, param4:Number = 0)
        {
            this.vTickTimed = [0, 0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6];
            this.vGame = param1;
            this.vTimer = param2;
            if (this.vTimer < 0)
            {
                this.vTimer = 0;
            }
            this.vTimerSpent = param4;
            this.vCallback = param3;
            if (Global.vDev)
            {
            }
            this.vGraf = new bitmapClip(this.vGame.vImages["button_gauge"]);
            this.vGraf.x = Global.vSize.x / 2;
            this.vGraf.y = 0;
            this.vGame.layerInterface.addChild(this.vGraf);
            this.vGraf.mouseChildren = true;
            this.vGraf.mouseEnabled = true;
            this.launchButton();
            return;
        }// end function

        public function remove(event:Event = null) : void
        {
            if (this.vGraf == null)
            {
                return;
            }
            var _loc_2:* = 0.3;
            TweenMax.to(this.vGraf, _loc_2, {x:this.vGraf.x + 120});
            TweenMax.delayedCall(_loc_2, this.destroy);
            return;
        }// end function

        public function destroy(event:Event = null) : void
        {
            var _loc_2:* = null;
            Global.addEventTrace("GBL_ButtonLaunch.destroy");
            if (this.vGraf != null)
            {
                if (this.vGame != null)
                {
                    if (this.vGame.layerInterface != null)
                    {
                        if (this.vGame.layerInterface.contains(this.vGraf))
                        {
                            _loc_2 = this.vGraf;
                            this.vGraf = null;
                            this.vGame.layerInterface.removeChild(_loc_2);
                        }
                    }
                }
            }
            this.destroyListeners();
            return;
        }// end function

        public function setUnlimited() : void
        {
            this.vGraf.gotoAndStop(13);
            this.vGraf.removeEventListener(Event.ENTER_FRAME, this.onFrame);
            return;
        }// end function

        public function getTimeLeft() : Number
        {
            return this.vTimer - (getTimer() - this.vTime0) / 1000;
        }// end function

        private function launchButton() : void
        {
            if (Capabilities.isDebugger)
            {
                this.vGraf.addEventListener(MouseEvent.CLICK, this.onAction);
            }
            else
            {
                this.vGraf.addEventListener(TouchEvent.TOUCH_TAP, this.onAction);
            }
            this.vGraf.addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            this.vTime0 = getTimer() - this.vTimerSpent * 1000;
            this.vRunning = true;
            this.vGraf.addEventListener(Event.ENTER_FRAME, this.onFrame);
            TweenMax.from(this.vGraf, 0.3, {x:this.vGraf.x + 120});
            return;
        }// end function

        private function destroyListeners() : void
        {
            if (this.vGraf != null)
            {
                this.vGraf.removeEventListener(MouseEvent.CLICK, this.onAction);
                this.vGraf.removeEventListener(TouchEvent.TOUCH_TAP, this.onAction);
                this.vGraf.removeEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
                this.vGraf.removeEventListener(Event.ENTER_FRAME, this.onFrame);
            }
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            var _loc_3:* = NaN;
            Global.addEventTrace("GBL_ButtonLaunch.onFrame");
            if (this.vGraf == null)
            {
                return;
            }
            var _loc_2:* = Math.ceil(getTimer() - this.vTime0) / 1000;
            if (_loc_2 >= this.vTimer)
            {
                _loc_2 = this.vTimer;
                if (!Global.vAutoLaunch || Global.vDev)
                {
                    return;
                }
                this.onAction();
                return;
            }
            if (this.vTickTimedIndex == -2)
            {
                this.vTickTimedIndex = this.vTickTimed.length - 1;
            }
            if (this.vTickTimedIndex >= 0)
            {
                _loc_3 = this.vTimer - (getTimer() - this.vTime0) / 1000;
                if (_loc_3 <= this.vTickTimed[this.vTickTimedIndex])
                {
                    Global.vSound.onTimerTick();
                    var _loc_4:* = this;
                    var _loc_5:* = this.vTickTimedIndex - 1;
                    _loc_4.vTickTimedIndex = _loc_5;
                }
            }
            this.vGraf.gotoAndStop(_loc_2 + 2);
            return;
        }// end function

        private function onAction(event:Event = null) : void
        {
            Global.addEventTrace("GBL_ButtonLaunch.onAction");
            if (this.vRunning)
            {
                Global.vSound.onButton();
                this.vRunning = false;
                this.vCallback.call();
                this.destroyListeners();
            }
            return;
        }// end function

        public function doBump() : void
        {
            var _loc_1:* = new Array();
            var _loc_2:* = 0;
            while (_loc_2 < this.vGraf.numChildren)
            {
                
                _loc_1.push(this.vGraf.getChildAt(_loc_2));
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                this.vGraf.setChildIndex(_loc_1[_loc_2], (this.vGraf.numChildren - 1));
                TweenMax.to(_loc_1[(_loc_1.length - 1) - _loc_2], 0.2, {delay:_loc_2 * 0.03, scaleX:1.3, scaleY:1.3, ease:Quad.easeOut, onComplete:this.onBumpStepDone, onCompleteParams:[_loc_1[(_loc_1.length - 1) - _loc_2]]});
                _loc_2++;
            }
            return;
        }// end function

        private function onBumpStepDone(param1:DisplayObject) : void
        {
            TweenMax.to(param1, 0.2, {scaleX:1, scaleY:1, ease:Quad.easeIn});
            return;
        }// end function

    }
}
