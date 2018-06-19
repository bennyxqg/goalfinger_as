package menu.tools
{
    import flash.display.*;
    import flash.events.*;
    import globz.*;

    public class ButtonTextBitmap extends Sprite
    {
        private var vImages:Object;

        public function ButtonTextBitmap(param1:Class, param2:String, param3:Number = 1, param4:Boolean = false)
        {
            var _loc_5:* = new param1;
            _loc_5.txtLabel.htmlText = param2;
            Global.vLang.checkSans(_loc_5.txtLabel);
            Toolz.textReduce(_loc_5.txtLabel);
            if (param4)
            {
                _loc_5.txtLabel.y = _loc_5.txtLabel.y - _loc_5.txtLabel.textHeight / 2;
            }
            this.vImages = new Object();
            var _loc_6:* = new mcToBitmapQueue();
            var _loc_7:* = new MovieClip();
            var _loc_9:* = param3;
            _loc_5.scaleY = param3;
            _loc_5.scaleX = _loc_9;
            _loc_7.addChild(_loc_5);
            var _loc_8:* = Global.vResolution;
            if (Global.vResolutionForced)
            {
                _loc_8 = _loc_8 / 10;
            }
            this.vImages["button"] = new mcToBitmapAS3(_loc_7, 0, _loc_8, true, null, 0, _loc_6);
            _loc_6.startConversion(this.onGrafDone);
            addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            return;
        }// end function

        private function onGrafDone() : void
        {
            if (this.vImages == null)
            {
                return;
            }
            var _loc_1:* = new bitmapClip(this.vImages["button"]);
            addChild(_loc_1);
            return;
        }// end function

        private function destroy(event:Event) : void
        {
            var _loc_2:* = undefined;
            if (this.vImages != null)
            {
                for (_loc_2 in this.vImages)
                {
                    
                    _loc_4[_loc_2].destroyAll();
                    _loc_4[_loc_2] = null;
                }
            }
            this.vImages = null;
            return;
        }// end function

    }
}
