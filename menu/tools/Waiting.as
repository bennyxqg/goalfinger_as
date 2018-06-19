package menu.tools
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class Waiting extends Sprite
    {
        private var vGraf:MovieClip;

        public function Waiting(param1:Number = 0, param2:Number = 0)
        {
            var _loc_3:* = null;
            _loc_3 = new MargeGraf();
            _loc_3.alpha = 0;
            var _loc_4:* = 30;
            _loc_3.scaleY = 30;
            _loc_3.scaleX = _loc_4;
            _loc_3.x = _loc_3.x - _loc_3.width / 2;
            _loc_3.y = _loc_3.y - _loc_3.height / 2;
            addChild(_loc_3);
            this.vGraf = new WaitingGraf();
            this.vGraf.x = param1;
            this.vGraf.y = param2;
            addChild(this.vGraf);
            if (Capabilities.isDebugger)
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            }
            else
            {
                this.addEventListener(TouchEvent.TOUCH_BEGIN, this.onDown);
            }
            return;
        }// end function

        private function onDown(event:Event) : void
        {
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function nextRotate() : void
        {
            if (parent == null)
            {
                return;
            }
            TweenMax.to(this.vGraf, 0.3, {rotation:this.vGraf.rotation + 180});
            TweenMax.delayedCall(1, this.nextRotate);
            return;
        }// end function

    }
}
