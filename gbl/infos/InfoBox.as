package gbl.infos
{
    import com.greensock.*;
    import flash.display.*;
    import gbl.*;
    import globz.*;

    public class InfoBox extends Object
    {
        private var vGame:GBL_Main;
        private var vGraf:bitmapClip;
        private var vImage:mcToBitmapAS3;
        private var vRemoved:Boolean = false;

        public function InfoBox(param1:GBL_Main, param2:String, param3:int = 1)
        {
            this.vGame = param1;
            var _loc_4:* = new GameInfobox();
            _loc_4.gotoAndStop(param3);
            _loc_4.txtTitle.htmlText = "<b>" + param2 + "</b>";
            Global.vLang.checkSans(_loc_4.txtTitle);
            Toolz.textReduce(_loc_4.txtTitle);
            var _loc_5:* = new mcToBitmapQueue();
            var _loc_6:* = new MovieClip();
            _loc_6.addChild(_loc_4);
            this.vImage = new mcToBitmapAS3(_loc_6, 0, Global.vResolution, true, null, 0, _loc_5);
            _loc_5.startConversion(this.onGrafReady);
            return;
        }// end function

        private function onGrafReady() : void
        {
            if (this.vRemoved)
            {
                return;
            }
            if (this.vGraf != null)
            {
                if (this.vGraf.parent != null)
                {
                    this.vGraf.parent.removeChild(this.vGraf);
                    this.vGraf = null;
                }
            }
            this.vGraf = new bitmapClip(this.vImage);
            this.vGame.layerInterface.addChild(this.vGraf);
            this.vGraf.y = (-Global.vSize.y) / 2;
            Global.adjustPos(this.vGraf, 0, -1);
            TweenMax.from(this.vGraf, 0.3, {delay:1.5, y:this.vGraf.y - 200});
            return;
        }// end function

        public function remove() : void
        {
            this.vRemoved = true;
            if (this.vGraf == null)
            {
                return;
            }
            TweenMax.to(this.vGraf, 0.3, {y:this.vGraf.y - 100});
            TweenMax.delayedCall(0.3, this.destroy);
            return;
        }// end function

        private function destroy() : void
        {
            if (this.vGame.layerInterface.contains(this.vGraf))
            {
                this.vGame.layerInterface.removeChild(this.vGraf);
            }
            if (this.vImage != null)
            {
                this.vImage.destroyAll();
                this.vImage = null;
            }
            return;
        }// end function

    }
}
