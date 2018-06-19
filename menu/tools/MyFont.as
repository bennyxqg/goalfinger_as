package menu.tools
{
    import flash.display.*;
    import flash.geom.*;
    import globz.*;

    public class MyFont extends Sprite
    {

        public function MyFont(param1:DisplayObjectContainer, param2:String, param3:String, param4:Number, param5:Number, param6:Boolean = false, param7:Number = 1)
        {
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = new Point(0, 0);
            var _loc_11:* = true;
            var _loc_12:* = new Sprite();
            addChild(_loc_12);
            var _loc_13:* = 0;
            while (_loc_13 < param3.length)
            {
                
                _loc_8 = param3.substring(_loc_13, (_loc_13 + 1));
                _loc_9 = new bitmapClip(Global.vImages[param2 + "_" + _loc_8]);
                if (_loc_9 != null)
                {
                    if (_loc_11)
                    {
                        _loc_10.x = param7 * _loc_9.width / 2;
                        _loc_11 = false;
                    }
                    if (_loc_8 == "/")
                    {
                        _loc_10.x = _loc_10.x - param7 * 4;
                    }
                    else if (_loc_8 == "1")
                    {
                        _loc_10.x = _loc_10.x - param7 * 2;
                    }
                    else if (_loc_8 == "4")
                    {
                        _loc_10.x = _loc_10.x - param7 * 1;
                    }
                    _loc_9.x = _loc_10.x;
                    _loc_9.y = _loc_10.y;
                    if (_loc_8 == "/")
                    {
                        _loc_10.x = _loc_10.x + param7 * 14;
                    }
                    else if (_loc_8 == "1")
                    {
                        _loc_10.x = _loc_10.x + param7 * 14;
                    }
                    else
                    {
                        _loc_10.x = _loc_10.x + param7 * 16;
                    }
                    _loc_12.addChild(_loc_9);
                }
                _loc_13++;
            }
            if (param6)
            {
                _loc_12.x = _loc_12.x - _loc_12.width / 2;
            }
            this.x = param4;
            this.y = param5;
            param1.addChild(this);
            return;
        }// end function

    }
}
