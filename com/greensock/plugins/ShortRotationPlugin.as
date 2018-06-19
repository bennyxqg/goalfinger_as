package com.greensock.plugins
{
    import com.greensock.*;

    public class ShortRotationPlugin extends TweenPlugin
    {
        public static const API:Number = 1;

        public function ShortRotationPlugin()
        {
            this.propName = "shortRotation";
            this.overwriteProps = [];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            var _loc_5:* = null;
            if (typeof(param2) == "number")
            {
                return false;
            }
            var _loc_4:* = Boolean(param2.useRadians == true);
            for (_loc_5 in param2)
            {
                
                if (_loc_5 != "useRadians")
                {
                    this.initRotation(param1, _loc_5, param1[_loc_5], typeof(_loc_7[_loc_5]) == "number" ? (Number(_loc_7[_loc_5])) : (param1[_loc_5] + Number(_loc_7[_loc_5])), _loc_4);
                }
            }
            return true;
        }// end function

        public function initRotation(param1:Object, param2:String, param3:Number, param4:Number, param5:Boolean = false) : void
        {
            var _loc_6:* = param5 ? (Math.PI * 2) : (360);
            var _loc_7:* = (param4 - param3) % _loc_6;
            if ((param4 - param3) % _loc_6 != (param4 - param3) % _loc_6 % (_loc_6 / 2))
            {
                _loc_7 = _loc_7 < 0 ? (_loc_7 + _loc_6) : (_loc_7 - _loc_6);
            }
            addTween(param1, param2, param3, param3 + _loc_7, param2);
            this.overwriteProps[this.overwriteProps.length] = param2;
            return;
        }// end function

    }
}
