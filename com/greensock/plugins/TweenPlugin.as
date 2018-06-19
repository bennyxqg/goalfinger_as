package com.greensock.plugins
{
    import com.greensock.*;
    import com.greensock.core.*;

    public class TweenPlugin extends Object
    {
        public var propName:String;
        public var overwriteProps:Array;
        public var round:Boolean;
        public var priority:int = 0;
        public var activeDisable:Boolean;
        public var onInitAllProps:Function;
        public var onComplete:Function;
        public var onEnable:Function;
        public var onDisable:Function;
        protected var _tweens:Array;
        protected var _changeFactor:Number = 0;
        public static const VERSION:Number = 1.4;
        public static const API:Number = 1;

        public function TweenPlugin()
        {
            this._tweens = [];
            return;
        }// end function

        public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            this.addTween(param1, this.propName, param1[this.propName], param2, this.propName);
            return true;
        }// end function

        protected function addTween(param1:Object, param2:String, param3:Number, param4, param5:String = null) : void
        {
            var _loc_6:* = NaN;
            if (param4 != null)
            {
                _loc_6 = typeof(param4) == "number" ? (Number(param4) - param3) : (Number(param4));
                if (_loc_6 != 0)
                {
                    this._tweens[this._tweens.length] = new PropTween(param1, param2, param3, _loc_6, param5 || param2, false);
                }
            }
            return;
        }// end function

        protected function updateTweens(param1:Number) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_2:* = this._tweens.length;
            if (this.round)
            {
                while (--_loc_2 > -1)
                {
                    
                    _loc_3 = this._tweens[_loc_2];
                    _loc_4 = _loc_3.start + _loc_3.change * param1;
                    if (_loc_4 > 0)
                    {
                        _loc_3.target[_loc_3.property] = _loc_4 + 0.5 >> 0;
                        continue;
                    }
                    _loc_3.target[_loc_3.property] = _loc_4 - 0.5 >> 0;
                }
            }
            else
            {
                while (--_loc_2 > -1)
                {
                    
                    _loc_3 = this._tweens[--_loc_2];
                    _loc_3.target[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
                }
            }
            return;
        }// end function

        public function get changeFactor() : Number
        {
            return this._changeFactor;
        }// end function

        public function set changeFactor(param1:Number) : void
        {
            this.updateTweens(param1);
            this._changeFactor = param1;
            return;
        }// end function

        public function killProps(param1:Object) : void
        {
            var _loc_2:* = this.overwriteProps.length;
            while (--_loc_2 > -1)
            {
                
                if (this.overwriteProps[_loc_2] in param1)
                {
                    this.overwriteProps.splice(_loc_2, 1);
                }
            }
            --_loc_2 = this._tweens.length;
            while (--_loc_2 > -1)
            {
                
                if (PropTween(this._tweens[--_loc_2]).name in param1)
                {
                    this._tweens.splice(_loc_2, 1);
                }
            }
            return;
        }// end function

        private static function onTweenEvent(param1:String, param2:TweenLite) : Boolean
        {
            var _loc_4:* = false;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_3:* = param2.cachedPT1;
            if (param1 == "onInitAllProps")
            {
                _loc_5 = [];
                _loc_6 = 0;
                while (_loc_3)
                {
                    
                    _loc_5[++_loc_6] = _loc_3;
                    _loc_3 = _loc_3.nextNode;
                }
                _loc_5.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
                while (--_loc_6 > -1)
                {
                    
                    PropTween(_loc_5[_loc_6]).nextNode = _loc_5[(_loc_6 + 1)];
                    PropTween(_loc_5[_loc_6]).prevNode = _loc_5[(_loc_6 - 1)];
                }
                var _loc_7:* = _loc_5[0];
                param2.cachedPT1 = _loc_5[0];
                _loc_3 = _loc_7;
            }
            while (_loc_3)
            {
                
                if (_loc_3.isPlugin && _loc_3.target[param1])
                {
                    if (_loc_3.target.activeDisable)
                    {
                        _loc_4 = true;
                    }
                    var _loc_7:* = _loc_3.target;
                    _loc_7[param1]();
                }
                _loc_3 = _loc_3.nextNode;
            }
            return _loc_4;
        }// end function

        public static function activate(param1:Array) : Boolean
        {
            var _loc_3:* = null;
            TweenLite.onPluginEvent = TweenPlugin.onTweenEvent;
            var _loc_2:* = param1.length;
            while (_loc_2--)
            {
                
                if (param1[_loc_2].hasOwnProperty("API"))
                {
                    _loc_3 = new (param1[_loc_2] as Class)();
                    TweenLite.plugins[_loc_3.propName] = param1[_loc_2];
                }
            }
            return true;
        }// end function

    }
}
