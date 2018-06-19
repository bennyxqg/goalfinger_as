package menu.tools
{
    import flash.display.*;

    public class Shirt extends Sprite
    {

        public function Shirt(param1:String, param2:Boolean = true)
        {
            var _loc_5:* = null;
            var _loc_3:* = new PersoGrafMain();
            _loc_3.init();
            var _loc_4:* = Global.vServer.vUser.getCharAtPosition(1).vCharId;
            _loc_3.setGraf(_loc_4, param1, false, Global.vSWFImages, Global.vSWFLoader);
            var _loc_6:* = 1.8;
            _loc_3.scaleY = 1.8;
            _loc_3.scaleX = _loc_6;
            _loc_3.setOrientation(0);
            if (param2)
            {
                _loc_5 = new ButtonGrafBitmap(_loc_3);
                addChild(_loc_5);
            }
            else
            {
                addChild(_loc_3);
            }
            return;
        }// end function

    }
}
