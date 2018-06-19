package tools
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import menu.tools.*;

    public class SimpleButton extends Sprite
    {
        private var vButton:GrafSimpleButton;
        private var vCallback:Function;
        private var vArgs:Object;

        public function SimpleButton(param1:DisplayObjectContainer, param2:String, param3:Number, param4:Number, param5:Function, param6 = null, param7:Boolean = false, param8:Number = 1, param9:Boolean = false)
        {
            var _loc_10:* = null;
            var _loc_11:* = null;
            this.vCallback = param5;
            if (param6 != null)
            {
                this.vArgs = param6;
            }
            _loc_10 = new GrafSimpleButton();
            if (param7)
            {
                _loc_10.gotoAndStop(2);
            }
            _loc_10.txtTitle.text = param2;
            this.x = param3;
            this.y = param4;
            param1.addChild(this);
            var _loc_12:* = param8;
            _loc_10.scaleY = param8;
            _loc_10.scaleX = _loc_12;
            if (param9)
            {
                _loc_11 = new ButtonGrafBitmap(_loc_10);
            }
            else
            {
                _loc_11 = new Sprite();
                _loc_11.addChild(_loc_10);
            }
            if (Capabilities.isDebugger)
            {
                _loc_11.addEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            }
            else
            {
                _loc_11.addEventListener(TouchEvent.TOUCH_BEGIN, this.onClick);
            }
            addChild(_loc_11);
            this.vButton = _loc_10;
            return;
        }// end function

        private function onClick(event:Event) : void
        {
            if (this.vArgs == null)
            {
                this.vCallback.call();
            }
            else
            {
                this.vCallback.call(0, this.vArgs);
            }
            return;
        }// end function

    }
}
