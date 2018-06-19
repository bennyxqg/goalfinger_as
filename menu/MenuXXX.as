package menu
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.screens.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class MenuXXX extends MovieClip
    {
        public var vImages:Object;
        public var vTag:String = "";
        public var layerMenu:Sprite;
        private var vCaptureEvents:Boolean = false;
        private var vNotEnoughCardsCallback:Function;
        private var vReconnectingGraf:Sprite;
        private var vWaitingGraf:Waiting;

        public function MenuXXX()
        {
            if (stage)
            {
                this.onStageAdded();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.onStageAdded, false, 0, true);
            }
            return;
        }// end function

        public function onStageAdded(event:Event = null) : void
        {
            Global.addEventTrace("MenuXXX.onStageAdded");
            removeEventListener(Event.ADDED_TO_STAGE, this.onStageAdded);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemovedXXX);
            this.initXXX();
            return;
        }// end function

        private function initXXX() : void
        {
            var _loc_1:* = new mcToBitmapQueue();
            this.vImages = new Object();
            this.rasterizeImages(_loc_1);
            _loc_1.startConversion(this.init);
            return;
        }// end function

        protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        protected function init() : void
        {
            return;
        }// end function

        public function onStageRemovedXXX(event:Event = null) : void
        {
            this.destroyImages();
            this.onStageRemoved();
            return;
        }// end function

        private function destroyImages() : void
        {
            var _loc_1:* = undefined;
            if (this.vImages != null)
            {
                for (_loc_1 in this.vImages)
                {
                    
                    _loc_3[_loc_1].destroyAll();
                    delete _loc_3[_loc_1];
                }
                this.vImages = null;
            }
            return;
        }// end function

        protected function onStageRemoved() : void
        {
            return;
        }// end function

        public function onDeactivate(event:Event) : void
        {
            return;
        }// end function

        public function onReactivate(event:Event) : void
        {
            return;
        }// end function

        public function onDisconnected() : void
        {
            return;
        }// end function

        public function addButton(param1:DisplayObjectContainer, param2:DisplayObject, param3:Point, param4:Function, param5:Number = 1, param6 = null, param7:Boolean = true) : MovieClip
        {
            var _loc_8:* = new MovieClip();
            if (param1 == null)
            {
                return _loc_8;
            }
            _loc_8.addChild(param2);
            _loc_8.x = param3.x;
            _loc_8.y = param3.y;
            if (param6 != null)
            {
                _loc_8.vArgs = param6;
            }
            var _loc_9:* = param5;
            param2.scaleY = param5;
            param2.scaleX = _loc_9;
            param1.addChild(_loc_8);
            if (Capabilities.isDebugger)
            {
                if (param7)
                {
                    _loc_8.addEventListener(MouseEvent.MOUSE_DOWN, param4);
                }
                else
                {
                    _loc_8.addEventListener(MouseEvent.CLICK, param4);
                }
            }
            else if (param7)
            {
                _loc_8.addEventListener(TouchEvent.TOUCH_BEGIN, param4);
            }
            else
            {
                _loc_8.addEventListener(TouchEvent.TOUCH_TAP, param4);
            }
            return _loc_8;
        }// end function

        public function initMenu() : void
        {
            this.layerMenu = new Sprite();
            this.layerMenu.x = Global.vSize.x / 2;
            this.layerMenu.y = Global.vSize.y / 2;
            addChild(this.layerMenu);
            this.startTouchEvents();
            return;
        }// end function

        protected function cleanMenu() : void
        {
            while (this.layerMenu.numChildren > 0)
            {
                
                this.layerMenu.removeChildAt(0);
            }
            if (this.vWaitingGraf != null)
            {
                this.vWaitingGraf = null;
            }
            return;
        }// end function

        public function startTouchEvents() : void
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
            Global.vRoot.addEventListener(Event.ENTER_FRAME, this.onFrame);
            addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            return;
        }// end function

        public function destroy(event:Event = null) : void
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
            return;
        }// end function

        final private function onTouchDown(event:TouchEvent) : void
        {
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
            Global.addEventTrace("MenuXXX.onMouseDown");
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
            if (this.vCaptureEvents)
            {
                event.stopImmediatePropagation();
            }
            var _loc_2:* = Global.getCoord(event.stageX, event.stageY);
            this.onMUp(new MyTouch(_loc_2.x, _loc_2.y, 1));
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

        protected function onFrame(event:Event) : void
        {
            return;
        }// end function

        protected function goBackSplash(event:Event) : void
        {
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        protected function addMarge(param1:DisplayObjectContainer, param2:Number, param3:Number) : int
        {
            var _loc_4:* = new MargeGraf();
            _loc_4.x = param2;
            _loc_4.y = param3;
            _loc_4.alpha = 0;
            param1.addChildAt(_loc_4, 0);
            return _loc_4.width;
        }// end function

        public function showNotEnoughCards(param1:int, param2:Function = null) : void
        {
            var _loc_3:* = null;
            if (param1 == 1)
            {
                _loc_3 = Global.getText("txtNotEnoughCard1");
            }
            else
            {
                _loc_3 = Global.getText("txtNotEnoughCardN").replace(/#/, param1);
            }
            _loc_3 = _loc_3 + ("<BR>" + Global.getText("txtAskGoShop"));
            this.vNotEnoughCardsCallback = param2;
            new MsgBox(this, _loc_3, this.onNotEnoughCardsAnswer, MsgBox.TYPE_YesNo);
            return;
        }// end function

        private function onNotEnoughCardsAnswer(param1:Boolean) : void
        {
            if (param1)
            {
                Global.vRoot.launchMenu(Shop);
            }
            else if (this.vNotEnoughCardsCallback != null)
            {
                this.vNotEnoughCardsCallback.call();
            }
            return;
        }// end function

        public function onNotify(param1:Sparks_Char, param2:String) : void
        {
            return;
        }// end function

        public function showReconnection(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (param1)
            {
                if (this.vReconnectingGraf == null)
                {
                    _loc_2 = new bitmapClip(Global.vImages["reconnecting"]);
                    _loc_2.x = Global.vSize.x / 2;
                    _loc_2.y = 50;
                    addChild(_loc_2);
                    Global.adjustPos(_loc_2, 0, -1);
                    this.vReconnectingGraf = _loc_2;
                    TweenMax.from(this.vReconnectingGraf, 0.2, {alpha:0});
                    Toolz.doPulseHeartBeat(this.vReconnectingGraf);
                }
            }
            else if (this.vReconnectingGraf != null)
            {
                removeChild(this.vReconnectingGraf);
                this.vReconnectingGraf = null;
                return;
            }
            return;
        }// end function

        public function showLoading() : void
        {
            this.vWaitingGraf = new Waiting();
            this.layerMenu.addChild(this.vWaitingGraf);
            return;
        }// end function

    }
}
