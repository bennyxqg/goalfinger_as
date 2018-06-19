package gbl.perso
{
    import com.greensock.*;
    import flash.display.*;
    import gbl.*;

    public class GBL_Perso extends MovieClip
    {
        protected var vGame:GBL_Main;
        public var v3D:Boolean = false;
        public var vName:String = "";
        public var vOrientation:int = 0;

        public function GBL_Perso(param1:GBL_Main = null, param2:Boolean = false)
        {
            this.v3D = param2;
            if (param1 != null)
            {
                this.vGame = param1;
            }
            return;
        }// end function

        public function init(param1:GBL_Glob) : void
        {
            return;
        }// end function

        public function destroy() : void
        {
            return;
        }// end function

        public function setVisible(param1:Boolean) : void
        {
            this.visible = param1;
            if (param1)
            {
                TweenMax.killTweensOf(this);
                this.alpha = 1;
                this.unCompress();
            }
            return;
        }// end function

        public function getSocle() : DisplayObject
        {
            return new Sprite();
        }// end function

        public function setGlow(param1:Boolean) : void
        {
            return;
        }// end function

        public function setInMenu() : void
        {
            return;
        }// end function

        public function rotationInside(param1:Number) : void
        {
            return;
        }// end function

        public function setOrientation(param1:Number, param2:Number) : void
        {
            this.vOrientation = param1;
            return;
        }// end function

        public function setHighlight(param1:Boolean = true) : void
        {
            return;
        }// end function

        public function onRefreshPos() : void
        {
            return;
        }// end function

        public function compress(param1:Number, param2:Number) : void
        {
            scaleX = param2;
            var _loc_3:* = 1 / param2;
            if (_loc_3 > 1.5)
            {
                _loc_3 = 1.5;
            }
            scaleY = _loc_3;
            rotation = param1;
            this.rotationInside(-param1);
            return;
        }// end function

        public function unCompress() : void
        {
            var _loc_1:* = 1;
            scaleY = 1;
            scaleX = _loc_1;
            rotation = 0;
            this.rotationInside(0);
            return;
        }// end function

        public function doKill(param1:Boolean = false) : void
        {
            if (param1)
            {
                alpha = 0;
            }
            else
            {
                TweenMax.to(this, 0.3, {alpha:0});
            }
            return;
        }// end function

        public function onPosInit() : void
        {
            return;
        }// end function

        public function showHitPoints(param1:int, param2:int) : void
        {
            return;
        }// end function

        public function cleanHitPoints() : void
        {
            return;
        }// end function

    }
}
