package tools
{
    import flash.display.*;
    import flash.events.*;
    import globz.*;

    public class SphereMap extends Sprite
    {
        private var v3DSphere:BitmapSphere;
        private var vSpeed:Number;
        private var vAngle:Number;

        public function SphereMap(param1:MovieClip, param2:DisplayObject, param3:Number, param4:MovieClip = null, param5:Number = 0.5)
        {
            this.vSpeed = param5;
            this.vAngle = 0;
            this.v3DSphere = new BitmapSphere(param1, param3, 10, 0, 0, 0, 0, 0, param4);
            this.addChild(this.v3DSphere);
            if (param2 != null)
            {
                var _loc_6:* = param3;
                param2.scaleY = param3;
                param2.scaleX = _loc_6;
                this.addChild(param2);
            }
            this.addEventListener(Event.ENTER_FRAME, this.loop);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            return;
        }// end function

        private function loop(event:Event) : void
        {
            var _loc_2:* = this.vAngle + this.vSpeed;
            this.vAngle = this.vAngle + this.vSpeed;
            this.v3DSphere.AbsRotateSphere(0, _loc_2, 0);
            this.vAngle = (this.vAngle + this.vSpeed) % 360;
            return;
        }// end function

        public function destroy(event:Event = null) : void
        {
            if (this.v3DSphere != null)
            {
                this.v3DSphere.destroy();
                this.v3DSphere = null;
            }
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            return;
        }// end function

    }
}
