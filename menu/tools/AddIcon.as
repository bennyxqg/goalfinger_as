package menu.tools
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.geom.*;
    import globz.*;

    public class AddIcon extends Sprite
    {
        private var vParent:DisplayObjectContainer;
        private var vCallback:Function;
        private var vFrom:Point;
        private var vDest:Point;
        private var vIcon:bitmapClip;
        private var vIconImage:String;
        private var vScale:Number;
        public var vDelay:Number = 0;
        public static var vGlobalDelay:Number = 0;
        public static var vLastIcon:String = "";
        public static var vScaleStart:Number = 0;
        public static var vRandomStartCoef:Number = 0;
        public static var vSpeedCoef:Number = 1;

        public function AddIcon(param1:DisplayObjectContainer, param2:String, param3:Point, param4:Point, param5:Function, param6:Number = 0.6, param7:Number = 1, param8:Number = 0, param9:Number = 1, param10:Boolean = false, param11:Number = 0)
        {
            this.vParent = param1;
            this.vCallback = param5;
            this.vIconImage = param2;
            this.vScale = param6;
            vScaleStart = param8;
            vRandomStartCoef = param7;
            vSpeedCoef = param9;
            if (vSpeedCoef < 0.01)
            {
                vSpeedCoef = 0.01;
            }
            if (param11 == 0)
            {
                this.vParent.addChild(this);
            }
            else
            {
                this.vParent.addChildAt(this, 0);
            }
            this.vFrom = param3.clone();
            this.vFrom.x = this.vFrom.x + vRandomStartCoef * 150 * (Math.random() - 0.5);
            this.vFrom.y = this.vFrom.y + vRandomStartCoef * 150 * (Math.random() - 0.5);
            this.vDest = param4;
            var _loc_12:* = vRandomStartCoef * 0.5 * Math.random();
            _loc_12 = vRandomStartCoef * 0.5 * Math.random() + param11;
            if (vLastIcon != param2)
            {
                vLastIcon = param2;
                if (!param10)
                {
                    _loc_12 = _loc_12 + 3;
                }
            }
            this.vDelay = _loc_12;
            vGlobalDelay = vGlobalDelay + this.vDelay / 4;
            TweenMax.delayedCall(vGlobalDelay, this.showIcon);
            return;
        }// end function

        private function showIcon() : void
        {
            vGlobalDelay = vGlobalDelay - this.vDelay / 4;
            if (vGlobalDelay < 0)
            {
                vGlobalDelay = 0;
            }
            this.vIcon = new bitmapClip(Global.vImages[this.vIconImage]);
            var _loc_2:* = this.vScale;
            this.vIcon.scaleY = this.vScale;
            this.vIcon.scaleX = _loc_2;
            addChild(this.vIcon);
            x = this.vFrom.x;
            y = this.vFrom.y;
            TweenMax.to(this, 0.9 / vSpeedCoef, {delay:0.3 / vSpeedCoef, x:this.vDest.x, y:this.vDest.y, ease:Expo.easeIn, onComplete:this.finish});
            TweenMax.from(this, 0.5 / vSpeedCoef, {scaleX:vScaleStart, scaleY:vScaleStart, ease:Quad.easeOut});
            var _loc_1:* = new Point(0, 0);
            _loc_1.x = vRandomStartCoef * 150 * (Math.random() - 0.5);
            _loc_1.y = vRandomStartCoef * 150 * (Math.random() - 0.5);
            TweenMax.to(this.vIcon, 0.2, {x:_loc_1.x, y:_loc_1.y, ease:Expo.easeOut});
            TweenMax.to(this.vIcon, 1.1, {delay:0.2, x:0, y:0, ease:Expo.easeIn});
            return;
        }// end function

        private function finish() : void
        {
            if (this.vParent.contains(this))
            {
                this.vParent.removeChild(this);
            }
            this.vCallback.call();
            return;
        }// end function

    }
}
