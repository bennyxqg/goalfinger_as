package menu.tools
{
    import flash.display.*;
    import flash.events.*;
    import globz.*;

    public class ButtonGrafBitmap extends Sprite
    {
        private var vImages:Object;

        public function ButtonGrafBitmap(param1:DisplayObject)
        {
            this.vImages = new Object();
            var _loc_2:* = new mcToBitmapQueue();
            var _loc_3:* = new MovieClip();
            _loc_3.addChild(param1);
            var _loc_4:* = Global.vResolution;
            if (Global.vResolutionForced)
            {
                _loc_4 = _loc_4 / 10;
            }
            this.vImages["button"] = new mcToBitmapAS3(_loc_3, 0, _loc_4, true, null, 0, _loc_2);
            _loc_2.startConversion(this.onGrafDone);
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
