package tools
{
    import flash.display.*;
    import flash.geom.*;

    final public class AutoResize extends MovieClip
    {

        public function AutoResize() : void
        {
            return;
        }// end function

        public static function doResize(param1:Stage, param2:DisplayObject, param3:int = 640, param4:int = 960, param5:Boolean = false, param6:Function = null) : Object
        {
            var _loc_7:* = new Object();
            _loc_7.fw = param3;
            _loc_7.fh = param4;
            _loc_7.landscape = param5;
            _loc_7.callback = param6;
            var _loc_8:* = Global.vRoot.getStageSize();
            var _loc_9:* = _loc_8.x;
            var _loc_10:* = _loc_8.y;
            if (_loc_7.landscape && _loc_10 > _loc_9)
            {
                _loc_9 = _loc_8.y;
                _loc_10 = _loc_8.x;
            }
            var _loc_11:* = _loc_9;
            var _loc_12:* = _loc_9 * _loc_7.fh / _loc_7.fw;
            if (_loc_9 * _loc_7.fh / _loc_7.fw > _loc_10)
            {
                _loc_11 = _loc_10 * _loc_7.fw / _loc_7.fh;
                _loc_12 = _loc_10;
            }
            _loc_7.newW = _loc_11;
            _loc_7.newH = _loc_12;
            _loc_7.screenW = _loc_9;
            _loc_7.screenH = _loc_10;
            _loc_7.x = (_loc_9 - _loc_11) / 2;
            _loc_7.y = (_loc_10 - _loc_12) / 2;
            _loc_7.scaleX = _loc_11 / _loc_7.fw;
            _loc_7.scaleY = _loc_12 / _loc_7.fh;
            param2.x = _loc_7.x;
            param2.y = _loc_7.y;
            param2.scaleX = _loc_7.scaleX;
            param2.scaleY = _loc_7.scaleY;
            var _loc_13:* = new Object();
            _loc_7.deltaX = param2.x;
            _loc_13.deltaY = param2.y;
            _loc_13.scaleX = param2.scaleX;
            _loc_13.scaleY = param2.scaleY;
            _loc_13.screenW = _loc_9;
            _loc_13.screenH = _loc_10;
            return _loc_13;
        }// end function

    }
}
