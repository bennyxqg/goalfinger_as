package com.greensock.plugins
{
    import com.greensock.core.*;
    import flash.filters.*;

    public class FilterPlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _type:Class;
        protected var _filter:BitmapFilter;
        protected var _index:int;
        protected var _remove:Boolean;
        public static const VERSION:Number = 2.03;
        public static const API:Number = 1;

        public function FilterPlugin()
        {
            return;
        }// end function

        protected function initFilter(param1:Object, param2:BitmapFilter, param3:Array) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_4:* = this._target.filters;
            var _loc_8:* = param1 is BitmapFilter ? ({}) : (param1);
            this._index = -1;
            if (_loc_8.index != null)
            {
                this._index = _loc_8.index;
            }
            else
            {
                _loc_6 = _loc_4.length;
                while (_loc_6--)
                {
                    
                    if (_loc_4[_loc_6] is this._type)
                    {
                        this._index = _loc_6;
                        break;
                    }
                }
            }
            if (this._index == -1 || _loc_4[this._index] == null || _loc_8.addFilter == true)
            {
                this._index = _loc_8.index != null ? (_loc_8.index) : (_loc_4.length);
                _loc_4[this._index] = param2;
                this._target.filters = _loc_4;
            }
            this._filter = _loc_4[this._index];
            if (_loc_8.remove == true)
            {
                this._remove = true;
                this.onComplete = this.onCompleteTween;
            }
            _loc_6 = param3.length;
            while (_loc_6--)
            {
                
                _loc_5 = param3[_loc_6];
                if (_loc_5 in param1 && this._filter[_loc_5] != param1[_loc_5])
                {
                    if (_loc_5 == "color" || _loc_5 == "highlightColor" || _loc_5 == "shadowColor")
                    {
                        _loc_7 = new HexColorsPlugin();
                        _loc_7.initColor(this._filter, _loc_5, this._filter[_loc_5], param1[_loc_5]);
                        _tweens[_tweens.length] = new PropTween(_loc_7, "changeFactor", 0, 1, _loc_5, false);
                        continue;
                    }
                    if (_loc_5 == "quality" || _loc_5 == "inner" || _loc_5 == "knockout" || _loc_5 == "hideObject")
                    {
                        this._filter[_loc_5] = param1[_loc_5];
                        continue;
                    }
                    addTween(this._filter, _loc_5, this._filter[_loc_5], param1[_loc_5], _loc_5);
                }
            }
            return;
        }// end function

        public function onCompleteTween() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            if (this._remove)
            {
                _loc_1 = this._target.filters;
                if (!(_loc_1[this._index] is this._type))
                {
                    _loc_2 = _loc_1.length;
                    while (_loc_2--)
                    {
                        
                        if (_loc_1[_loc_2] is this._type)
                        {
                            _loc_1.splice(_loc_2, 1);
                            break;
                        }
                    }
                }
                else
                {
                    _loc_1.splice(this._index, 1);
                }
                this._target.filters = _loc_1;
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = _tweens.length;
            var _loc_4:* = this._target.filters;
            while (_loc_2--)
            {
                
                _loc_3 = _tweens[_loc_2];
                _loc_3.target[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
            }
            if (!(_loc_4[this._index] is this._type))
            {
                var _loc_5:* = _loc_4.length;
                this._index = _loc_4.length;
                _loc_2 = _loc_5;
                while (_loc_2--)
                {
                    
                    if (_loc_4[_loc_2] is this._type)
                    {
                        this._index = _loc_2;
                        break;
                    }
                }
            }
            _loc_4[this._index] = this._filter;
            this._target.filters = _loc_4;
            return;
        }// end function

    }
}
