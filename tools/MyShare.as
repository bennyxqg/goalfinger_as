package tools
{
    import com.greensock.*;
    import com.milkmangames.nativeextensions.*;
    import com.milkmangames.nativeextensions.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import globz.*;

    public class MyShare extends MovieClip
    {
        private var vType:int;
        private var vBitmapAS3:mcToBitmapAS3;
        private var vGraf:MovieClip;
        private var vURL:String;
        private var vArgs:Object;
        private var vDebug:Boolean = false;
        private var vCallback:Function;
        private static var vInitViralDone:Boolean = false;

        public function MyShare(param1:int, param2, param3:Function = null)
        {
            if (Capabilities.os.indexOf("Windows") >= 0)
            {
                this.vDebug = true;
            }
            if (param3 != null)
            {
                this.vCallback = param3;
            }
            this.myTrace("MyShare:" + param1 + "/" + param2);
            this.vType = param1;
            this.vArgs = param2;
            this.vURL = "http://www.globz.com/games/goalfinger/";
            addEventListener(Event.ADDED_TO_STAGE, this.init);
            Global.vStats.Stats_Event("Share", "ShareDone");
            return;
        }// end function

        private function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            if (Capabilities.isDebugger)
            {
                stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, true, 100, true);
            }
            else
            {
                stage.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, true, 100, true);
            }
            this.vGraf = this.getGraf();
            this.startConversion();
            return;
        }// end function

        private function startConversion() : void
        {
            TweenMax.delayedCall(0.5, this.startConversionDo);
            return;
        }// end function

        private function startConversionDo() : void
        {
            var _loc_1:* = new mcToBitmapQueue();
            this.vBitmapAS3 = new mcToBitmapAS3(this.vGraf, 0, 1, false, null, 0, _loc_1, 0, false, "best", true, true, true);
            _loc_1.startConversion(this.onConversionDone);
            return;
        }// end function

        private function destroy(event:Event) : void
        {
            if (Capabilities.isDebugger)
            {
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, true);
            }
            else
            {
                stage.removeEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, true);
            }
            return;
        }// end function

        private function onMouseDown(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            this.doQuit();
            return;
        }// end function

        private function onTouchDown(event:TouchEvent) : void
        {
            event.stopImmediatePropagation();
            this.doQuit();
            return;
        }// end function

        private function onConversionDone() : void
        {
            var _loc_1:* = null;
            if (this.vCallback != null)
            {
                this.vCallback.call();
            }
            if (this.vDebug)
            {
                _loc_1 = new bitmapClip(this.vBitmapAS3);
                _loc_1.x = 0;
                _loc_1.y = 0;
                Global.vRoot.addChild(_loc_1);
                _loc_1.alpha = 0.3;
                return;
            }
            this.shareGeneric();
            return;
        }// end function

        private function myTrace(param1:String) : void
        {
            Global.addLogTrace(param1, "MyShare");
            return;
        }// end function

        private function getGraf() : MovieClip
        {
            var _loc_1:* = new MovieClip();
            if (this.vType == 2)
            {
                _loc_1.addChild(this.vArgs);
            }
            else
            {
                if (this.vType == 3)
                {
                    return this.vArgs;
                }
                _loc_1.addChild(new Foot2_Under());
            }
            return _loc_1;
        }// end function

        private function initGoViral() : Boolean
        {
            if (GoViral.isSupported())
            {
                if (vInitViralDone)
                {
                    return true;
                }
                this.myTrace("GoViral.isSupported");
                GoViral.create();
                vInitViralDone = true;
                GoViral.goViral.addEventListener(GVShareEvent.GENERIC_MESSAGE_SHARED, this.onShared);
            }
            else
            {
                this.myTrace("GoViral FAIL");
                return false;
            }
            return true;
        }// end function

        private function onSharedCanceled(event:Event) : void
        {
            this.myTrace("onSharedCanceled");
            return;
        }// end function

        private function onSharedFinished(event:Event) : void
        {
            this.myTrace("onSharedFinished");
            return;
        }// end function

        private function onShared(event:Event) : void
        {
            this.myTrace("message was shared with activity view!");
            this.doQuit();
            return;
        }// end function

        private function shareGeneric() : void
        {
            var _loc_1:* = null;
            if (!this.initGoViral())
            {
                this.doQuit();
                return;
            }
            var _loc_2:* = "Goal Finger";
            var _loc_3:* = _loc_2;
            _loc_1 = this.vBitmapAS3.vBDTab[0].vBD;
            this.myTrace("isGenericShareAvailable Start");
            var _loc_4:* = Global.vRoot.stage.fullScreenHeight;
            var _loc_5:* = false;
            if (_loc_4 > 1500)
            {
                _loc_5 = true;
                _loc_4 = _loc_4 / 2;
            }
            var _loc_6:* = Global.vRoot.stage.fullScreenWidth / 2;
            var _loc_7:* = false;
            if (GoViral.goViral.isGenericShareAvailable())
            {
                GoViral.goViral.shareGenericMessageWithImage(_loc_2, _loc_3, false, _loc_1, _loc_6, _loc_4);
                _loc_7 = true;
            }
            if (!_loc_7)
            {
                this.myTrace("isGenericShareAvailable FAIL");
                this.doQuit();
            }
            return;
        }// end function

        private function doQuit() : void
        {
            Global.addLogTrace("doQuit", "MyShare");
            TweenMax.delayedCall(5, this.bitmapDataDispose);
            if (vInitViralDone)
            {
                GoViral.goViral.removeEventListener(GVShareEvent.GENERIC_MESSAGE_SHARED, this.onShared);
                GoViral.goViral.dispose();
                vInitViralDone = false;
            }
            if (parent)
            {
                parent.removeChild(this);
            }
            return;
        }// end function

        private function bitmapDataDispose() : void
        {
            if (this.vBitmapAS3 != null)
            {
                this.vBitmapAS3.destroyAll();
                this.vBitmapAS3 = null;
            }
            return;
        }// end function

    }
}
