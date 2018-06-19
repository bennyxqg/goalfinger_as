package gbl.ergo
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import gbl.*;
    import tools.*;

    public class GBL_Action extends MovieClip
    {
        protected var vGame:GBL_Main;
        public var vActive:Boolean = true;
        public var vName:String = "ErgoXXX";
        private var vLastXY:Point;
        private var vCaptureEvents:Boolean = false;
        private var vAiming:GBL_Aiming;
        public static var vActionId:int = 0;

        public function GBL_Action(param1:GBL_Main = null)
        {
            if (param1 == null)
            {
                return;
            }
            var _loc_3:* = vActionId + 1;
            vActionId = _loc_3;
            this.vGame = param1;
            return;
        }// end function

        public function startListenOrder() : void
        {
            var _loc_1:* = true;
            if (Capabilities.isDebugger)
            {
                Global.vRoot.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, this.vCaptureEvents, 0, _loc_1);
                Global.vRoot.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove, this.vCaptureEvents, 0, _loc_1);
                Global.vRoot.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp, this.vCaptureEvents, 0, _loc_1);
            }
            else
            {
                Global.vRoot.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, this.vCaptureEvents, 0, _loc_1);
                Global.vRoot.addEventListener(TouchEvent.TOUCH_MOVE, this.onTouchMove, this.vCaptureEvents, 0, _loc_1);
                Global.vRoot.addEventListener(TouchEvent.TOUCH_END, this.onTouchUp, this.vCaptureEvents, 0, _loc_1);
            }
            Global.vRoot.addEventListener(Event.ENTER_FRAME, this.onFrame);
            this.onStart();
            return;
        }// end function

        protected function onStart() : void
        {
            return;
        }// end function

        protected function onEnd() : void
        {
            return;
        }// end function

        public function destroy() : void
        {
            if (Global.vRoot != null)
            {
                Global.vRoot.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown, this.vCaptureEvents);
                Global.vRoot.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove, this.vCaptureEvents);
                Global.vRoot.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp, this.vCaptureEvents);
                Global.vRoot.removeEventListener(TouchEvent.TOUCH_BEGIN, this.onTouchDown, this.vCaptureEvents);
                Global.vRoot.removeEventListener(TouchEvent.TOUCH_MOVE, this.onTouchMove, this.vCaptureEvents);
                Global.vRoot.removeEventListener(TouchEvent.TOUCH_END, this.onTouchUp, this.vCaptureEvents);
                Global.vRoot.removeEventListener(Event.ENTER_FRAME, this.onFrame);
            }
            if (this.vAiming != null)
            {
                this.vGame.layerSocle.removeChild(this.vAiming);
                this.vAiming = null;
            }
            var _loc_1:* = 0;
            while (_loc_1 < this.vGame.vTerrain.vGlobs.length)
            {
                
                this.vGame.vTerrain.vGlobs[_loc_1].vPerso.setHighlight(false);
                _loc_1++;
            }
            this.onEnd();
            return;
        }// end function

        final private function onTouchDown(event:TouchEvent) : void
        {
            Global.addEventTrace("GBL_Action.onTouchDown");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMDown(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            this.vLastXY = _loc_2.clone();
            return;
        }// end function

        final private function onMouseDown(event:MouseEvent) : void
        {
            Global.addEventTrace("GBL_Action.onMouseDown");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMDown(new MyTouch(_loc_2.x, _loc_2.y, 1));
            this.vLastXY = _loc_2.clone();
            return;
        }// end function

        final private function onTouchMove(event:TouchEvent) : void
        {
            Global.addEventTrace("GBL_Action.onTouchMove");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMMove(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            this.vLastXY = _loc_2.clone();
            return;
        }// end function

        final private function onMouseMove(event:MouseEvent) : void
        {
            Global.addEventTrace("GBL_Action.onMouseMove");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMMove(new MyTouch(_loc_2.x, _loc_2.y, 1));
            this.vLastXY = _loc_2.clone();
            return;
        }// end function

        final private function onTouchUp(event:TouchEvent) : void
        {
            var _loc_2:* = null;
            Global.addEventTrace("GBL_Action.onTouchUp");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            if (this.vLastXY != null)
            {
                _loc_2 = this.vLastXY.clone();
                this.onMUp(new MyTouch(_loc_2.x, _loc_2.y, event.touchPointID));
            }
            return;
        }// end function

        final private function onMouseUp(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            Global.addEventTrace("GBL_Action.onMouseUp");
            if (!this.vActive)
            {
                return;
            }
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            if (this.vLastXY != null)
            {
                _loc_2 = this.vLastXY.clone();
                this.onMUp(new MyTouch(_loc_2.x, _loc_2.y, 1));
            }
            return;
        }// end function

        protected function onMDown(param1:MyTouch) : void
        {
            return;
        }// end function

        protected function onMMove(param1:MyTouch) : void
        {
            return;
        }// end function

        protected function onMUp(param1:MyTouch) : void
        {
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            Global.addEventTrace("GBL_Action.onMouseDown");
            if (Global.vAiming)
            {
                if (this.vAiming == null)
                {
                    this.vAiming = new GBL_Aiming(this.vGame);
                    this.vGame.layerSocle.addChildAt(this.vAiming, 0);
                }
                this.vAiming.compute();
            }
            return;
        }// end function

    }
}
