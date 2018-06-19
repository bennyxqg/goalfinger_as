package com.greensock.plugins
{
    import com.greensock.*;

    public class EndArrayPlugin extends TweenPlugin
    {
        protected var _a:Array;
        protected var _info:Array;
        public static const API:Number = 1;

        public function EndArrayPlugin()
        {
            this._info = [];
            this.propName = "endArray";
            this.overwriteProps = ["endArray"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param1 is Array) || !(param2 is Array))
            {
                return false;
            }
            this.init(param1 as Array, param2);
            return true;
        }// end function

        public function init(param1:Array, param2:Array) : void
        {
            this._a = param1;
            var _loc_3:* = param2.length;
            while (_loc_3--)
            {
                
                if (param1[_loc_3] != param2[_loc_3] && param1[_loc_3] != null)
                {
                    this._info[this._info.length] = new ArrayTweenInfo(_loc_3, this._a[_loc_3], param2[_loc_3] - this._a[_loc_3]);
                }
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_2:* = this._info.length;
            if (this.round)
            {
                while (_loc_2--)
                {
                    
                    _loc_3 = this._info[_loc_2];
                    _loc_4 = _loc_3.start + _loc_3.change * param1;
                    if (_loc_4 > 0)
                    {
                        this._a[_loc_3.index] = _loc_4 + 0.5 >> 0;
                        continue;
                    }
                    this._a[_loc_3.index] = _loc_4 - 0.5 >> 0;
                }
            }
            else
            {
                while (_loc_2--)
                {
                    
                    _loc_3 = this._info[_loc_2];
                    this._a[_loc_3.index] = _loc_3.start + _loc_3.change * param1;
                }
            }
            return;
        }// end function

    }
}

import com.greensock.*;

class ArrayTweenInfo extends Object
{
    public var index:uint;
    public var start:Number;
    public var change:Number;

    function ArrayTweenInfo(param1:uint, param2:Number, param3:Number)
    {
        this.index = param1;
        this.start = param2;
        this.change = param3;
        return;
    }// end function

}

