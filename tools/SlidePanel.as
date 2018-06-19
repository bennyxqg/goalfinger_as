package tools
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class SlidePanel extends Sprite
    {
        public var vContent:Sprite;
        private var vContentWidth:int;
        private var vContentHeight:int;
        private var vContentX0:int;
        private var vContentY0:int;
        private var vSize:Point;
        private var vPos0:Point;
        public var isSlideDone:Boolean = false;
        private var vSlideDone:Number = 0;
        private var vBorder:Sprite;
        public var vPause:Boolean = false;
        private var vForce:Point;
        private var vForceX:Boolean = false;
        private var vForceY:Boolean = false;
        private var vBorderLines:Object;
        private var vCanScrollX:Boolean = true;
        private var vCanScrollY:Boolean = true;
        public var vSmoothPostLast:Point;
        public var vSmoothTimeLast:int;
        public var vSmoothSpeed:Point;

        public function SlidePanel(param1:DisplayObject = null, param2:Point = null)
        {
            this.vForce = new Point(0, 0);
            this.vSmoothPostLast = new Point(0, 0);
            this.vSmoothSpeed = new Point(0, 0);
            if (param1 != null)
            {
                this.init(param1, param2);
            }
            return;
        }// end function

        public function init(param1:DisplayObject, param2:Point) : void
        {
            this.vSize = param2;
            this.setContent(param1);
            this.checkBounds();
            if (stage)
            {
                this.initEvents();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.initEvents);
            }
            return;
        }// end function

        public function destroy() : void
        {
            while (numChildren > 0)
            {
                
                this.removeChildAt(0);
            }
            return;
        }// end function

        public function forceX(param1:Number) : void
        {
            this.vForceX = true;
            this.vForce.x = param1;
            this.checkBounds();
            return;
        }// end function

        public function forceY(param1:Number) : void
        {
            this.vForceY = true;
            this.vForce.y = param1;
            this.checkBounds();
            return;
        }// end function

        public function setContent(param1:DisplayObject) : void
        {
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            if (this.vSize == null)
            {
                return;
            }
            var _loc_2:* = new Sprite();
            this.vContent = new Sprite();
            this.vContent.addChild(param1);
            _loc_2.addChild(this.vContent);
            addChild(_loc_2);
            _loc_2.scrollRect = new Rectangle(0, 0, this.vSize.x, this.vSize.y);
            var _loc_3:* = this.vContent.getBounds(this);
            this.vContentX0 = _loc_3.left;
            this.vContentY0 = _loc_3.top;
            this.vContentWidth = _loc_3.width;
            this.vContentHeight = _loc_3.height;
            this.vContent.x = -this.vContentX0;
            this.vContent.y = -this.vContentY0;
            _loc_2.x = _loc_2.x - this.vSize.x / 2;
            _loc_2.y = _loc_2.y - this.vSize.y / 2;
            this.vBorder = new Sprite();
            addChild(this.vBorder);
            this.vBorderLines = new Object();
            _loc_2 = new SlidePanelBorder();
            _loc_2.width = this.vSize.x;
            _loc_2.y = (-this.vSize.y) / 2;
            this.vBorder.addChild(_loc_2);
            this.vBorderLines["top"] = _loc_2;
            _loc_2 = new SlidePanelBorder();
            _loc_2.width = this.vSize.x;
            _loc_2.y = this.vSize.y / 2;
            this.vBorder.addChild(_loc_2);
            this.vBorderLines["bot"] = _loc_2;
            _loc_2 = new SlidePanelBorder();
            _loc_2.width = this.vSize.y;
            _loc_2.rotation = 90;
            _loc_2.x = (-this.vSize.x) / 2;
            this.vBorder.addChild(_loc_2);
            this.vBorderLines["left"] = _loc_2;
            _loc_2 = new SlidePanelBorder();
            _loc_2.width = this.vSize.y;
            _loc_2.rotation = 90;
            _loc_2.x = this.vSize.x / 2;
            this.vBorder.addChild(_loc_2);
            this.vBorderLines["right"] = _loc_2;
            return;
        }// end function

        private function initEvents(event:Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.initEvents);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeEvents);
            addEventListener(Event.ENTER_FRAME, this.checkBounds);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMDown);
            return;
        }// end function

        private function removeEvents(event:Event = null) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.removeEvents);
            removeEventListener(Event.ENTER_FRAME, this.checkBounds);
            if (stage)
            {
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMDown);
            }
            this.onMUp();
            return;
        }// end function

        public function hideBorder() : void
        {
            this.vBorder.visible = false;
            return;
        }// end function

        private function onMDown(event:MouseEvent) : void
        {
            Global.addEventTrace("SlidePanel.onMDown");
            if (this.vPause)
            {
                return;
            }
            this.initSmooth(this.mouseX, this.mouseY);
            if (this.mouseX < (-this.vSize.x) / 2)
            {
                return;
            }
            if (this.mouseY < (-this.vSize.y) / 2)
            {
                return;
            }
            if (this.mouseX > this.vSize.x / 2)
            {
                return;
            }
            if (this.mouseY > this.vSize.y / 2)
            {
                return;
            }
            this.vPos0 = new Point(this.mouseX, this.mouseY);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onMUp);
            this.isSlideDone = false;
            this.vSlideDone = 0;
            return;
        }// end function

        private function onMMove(event:MouseEvent) : void
        {
            if (this.vPause)
            {
                return;
            }
            this.vContent.x = this.vContent.x + (this.mouseX - this.vPos0.x);
            this.vContent.y = this.vContent.y + (this.mouseY - this.vPos0.y);
            this.vSlideDone = this.vSlideDone + (Math.abs(this.mouseX - this.vPos0.x) + Math.abs(this.mouseY - this.vPos0.y));
            if (this.vSlideDone > 20)
            {
                this.isSlideDone = true;
            }
            this.vPos0 = new Point(this.mouseX, this.mouseY);
            this.updateSmooth(this.mouseX, this.mouseY);
            this.checkBounds();
            return;
        }// end function

        private function onMUp(event:MouseEvent = null) : void
        {
            if (this.vPause)
            {
                return;
            }
            this.launchSmooth();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMUp);
            this.checkBounds();
            TweenMax.delayedCall(0.2, this.slideIsDone);
            return;
        }// end function

        private function slideIsDone() : void
        {
            this.isSlideDone = false;
            return;
        }// end function

        private function checkBounds(event:Event = null) : void
        {
            var _loc_4:* = NaN;
            Global.addEventTrace("SlidePanel.checkBounds");
            var _loc_2:* = 3;
            if (this.vContentWidth < this.vSize.x)
            {
                this.vCanScrollX = false;
                this.vContent.x = (-(this.vContentWidth - this.vSize.x) - this.vContentX0 - this.vContentX0) / 2;
            }
            else if (this.vContent.x > -this.vContentX0)
            {
                this.vCanScrollX = true;
                this.vContent.x = (_loc_2 * this.vContent.x - this.vContentX0) / (_loc_2 + 1);
            }
            else if (this.vContent.x < -(this.vContentWidth - this.vSize.x) - this.vContentX0)
            {
                this.vCanScrollX = true;
                this.vContent.x = (_loc_2 * this.vContent.x - (this.vContentWidth - this.vSize.x) - this.vContentX0) / (_loc_2 + 1);
            }
            if (this.vContentHeight < this.vSize.y)
            {
                this.vCanScrollY = false;
                this.vContent.y = (-(this.vContentHeight - this.vSize.y) - this.vContentY0 - this.vContentY0) / 2;
            }
            else if (this.vContent.y > -this.vContentY0)
            {
                this.vCanScrollY = true;
                this.vContent.y = (_loc_2 * this.vContent.y - this.vContentY0) / (_loc_2 + 1);
            }
            else if (this.vContent.y < -(this.vContentHeight - this.vSize.y) - this.vContentY0)
            {
                this.vCanScrollY = true;
                this.vContent.y = (_loc_2 * this.vContent.y - (this.vContentHeight - this.vSize.y) - this.vContentY0) / (_loc_2 + 1);
            }
            if (this.vForceX)
            {
                this.vContent.x = this.vForce.x;
            }
            if (this.vForceY)
            {
                this.vContent.y = this.vForce.y;
            }
            var _loc_3:* = 30;
            _loc_4 = this.vContent.y + this.vContentY0;
            if (_loc_4 < -_loc_3)
            {
                _loc_4 = -_loc_3;
            }
            else if (_loc_4 > 0)
            {
                _loc_4 = 0;
            }
            this.vBorderLines["top"].alpha = (-_loc_4) / _loc_3;
            _loc_4 = this.vContent.y + (this.vContentHeight - this.vSize.y) + this.vContentY0;
            if (_loc_4 > _loc_3)
            {
                _loc_4 = _loc_3;
            }
            else if (_loc_4 < 0)
            {
                _loc_4 = 0;
            }
            this.vBorderLines["bot"].alpha = _loc_4 / _loc_3;
            this.vBorderLines["left"].alpha = 0;
            this.vBorderLines["right"].alpha = 0;
            return;
        }// end function

        private function initSmooth(param1:Number, param2:Number) : void
        {
            this.endSmooth();
            this.vSmoothPostLast.x = param1;
            this.vSmoothPostLast.y = param2;
            this.vSmoothTimeLast = getTimer();
            this.vSmoothSpeed.x = 0;
            this.vSmoothSpeed.y = 0;
            return;
        }// end function

        private function updateSmooth(param1:Number, param2:Number) : void
        {
            var _loc_3:* = getTimer() - this.vSmoothTimeLast;
            if (_loc_3 == 0)
            {
                return;
            }
            var _loc_4:* = new Point((param1 - this.vSmoothPostLast.x) / _loc_3, (param2 - this.vSmoothPostLast.y) / _loc_3);
            this.vSmoothPostLast.x = param1;
            this.vSmoothPostLast.y = param2;
            this.vSmoothTimeLast = getTimer();
            this.vSmoothSpeed.x = (this.vSmoothSpeed.x + _loc_4.x) / 2;
            this.vSmoothSpeed.y = (this.vSmoothSpeed.y + _loc_4.y) / 2;
            if (!this.vCanScrollX)
            {
                this.vSmoothSpeed.x = 0;
            }
            if (!this.vCanScrollY)
            {
                this.vSmoothSpeed.y = 0;
            }
            this.checkBounds();
            return;
        }// end function

        private function launchSmooth() : void
        {
            addEventListener(Event.ENTER_FRAME, this.onFrameSmooth);
            return;
        }// end function

        private function onFrameSmooth(event:Event) : void
        {
            Global.addEventTrace("SlidePanel.onFrameSmooth");
            if (this.vPause)
            {
                return;
            }
            var _loc_2:* = getTimer() - this.vSmoothTimeLast;
            var _loc_3:* = 0.9;
            this.vSmoothTimeLast = this.vSmoothTimeLast + _loc_2;
            if (this.vCanScrollX)
            {
                this.vContent.x = this.vContent.x + this.vSmoothSpeed.x * _loc_2;
                this.vSmoothSpeed.x = this.vSmoothSpeed.x * _loc_3;
            }
            if (this.vCanScrollY)
            {
                this.vContent.y = this.vContent.y + this.vSmoothSpeed.y * _loc_2;
                this.vSmoothSpeed.y = this.vSmoothSpeed.y * _loc_3;
            }
            if (this.vSmoothSpeed.length < 0.1)
            {
                this.endSmooth();
            }
            this.checkBounds();
            return;
        }// end function

        private function endSmooth() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onFrameSmooth);
            return;
        }// end function

    }
}
