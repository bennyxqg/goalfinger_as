package com.greensock.plugins
{
    import com.greensock.*;

    public class BezierPlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _orientData:Array;
        protected var _orient:Boolean;
        protected var _future:Object;
        protected var _beziers:Object;
        public static const API:Number = 1;
        static const _RAD2DEG:Number = 57.2958;

        public function BezierPlugin()
        {
            this._future = {};
            this.propName = "bezier";
            this.overwriteProps = [];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param2 is Array))
            {
                return false;
            }
            this.init(param3, param2 as Array, false);
            return true;
        }// end function

        protected function init(param1:TweenLite, param2:Array, param3:Boolean) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            this._target = param1.target;
            var _loc_4:* = param1.vars.isTV == true ? (param1.vars.exposedVars) : (param1.vars);
            if ((_loc_4).orientToBezier == true)
            {
                this._orientData = [["x", "y", "rotation", 0, 0.01]];
                this._orient = true;
            }
            else if (_loc_4.orientToBezier is Array)
            {
                this._orientData = _loc_4.orientToBezier;
                this._orient = true;
            }
            var _loc_5:* = {};
            _loc_6 = 0;
            while (_loc_6 < param2.length)
            {
                
                for (_loc_7 in param2[_loc_6])
                {
                    
                    if (_loc_5[_loc_7] == undefined)
                    {
                        _loc_5[_loc_7] = [param1.target[_loc_7]];
                    }
                    if (typeof(_loc_10[_loc_7]) == "number")
                    {
                        _loc_5[_loc_7].push(_loc_10[_loc_7]);
                        continue;
                    }
                    _loc_5[_loc_7].push(param1.target[_loc_7] + Number(_loc_10[_loc_7]));
                }
                _loc_6 = _loc_6 + 1;
            }
            for (_loc_7 in _loc_5)
            {
                
                this.overwriteProps[this.overwriteProps.length] = _loc_7;
                if (_loc_4[_loc_7] != undefined)
                {
                    if (typeof(_loc_4[_loc_7]) == "number")
                    {
                        _loc_5[_loc_7].push(_loc_4[_loc_7]);
                    }
                    else
                    {
                        _loc_5[_loc_7].push(param1.target[_loc_7] + Number(_loc_4[_loc_7]));
                    }
                    _loc_8 = {};
                    _loc_8[_loc_7] = true;
                    param1.killVars(_loc_8, false);
                    delete _loc_4[_loc_7];
                }
            }
            this._beziers = parseBeziers(_loc_5, param3);
            return;
        }// end function

        override public function killProps(param1:Object) : void
        {
            var _loc_2:* = null;
            for (_loc_2 in this._beziers)
            {
                
                if (_loc_2 in param1)
                {
                    delete _loc_4[_loc_2];
                }
            }
            super.killProps(param1);
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = null;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = null;
            var _loc_12:* = NaN;
            var _loc_13:* = null;
            var _loc_14:* = false;
            _changeFactor = param1;
            if (param1 == 1)
            {
                for (_loc_3 in this._beziers)
                {
                    
                    _loc_2 = _loc_16[_loc_3].length - 1;
                    this._target[_loc_3] = _loc_16[_loc_3][_loc_2][2];
                }
            }
            else
            {
                for (_loc_3 in this._beziers)
                {
                    
                    _loc_6 = _loc_16[_loc_3].length;
                    if (param1 < 0)
                    {
                        _loc_2 = 0;
                    }
                    else if (param1 >= 1)
                    {
                        _loc_2 = _loc_6 - 1;
                    }
                    else
                    {
                        _loc_2 = _loc_6 * param1 >> 0;
                    }
                    _loc_5 = (param1 - _loc_2 * (1 / _loc_6)) * _loc_6;
                    _loc_4 = _loc_16[_loc_3][_loc_2];
                    if (this.round)
                    {
                        _loc_7 = _loc_4[0] + _loc_5 * (2 * (1 - _loc_5) * (_loc_4[1] - _loc_4[0]) + _loc_5 * (_loc_4[2] - _loc_4[0]));
                        if (_loc_7 > 0)
                        {
                            this._target[_loc_3] = _loc_7 + 0.5 >> 0;
                        }
                        else
                        {
                            this._target[_loc_3] = _loc_7 - 0.5 >> 0;
                        }
                        continue;
                    }
                    this._target[_loc_3] = _loc_4[0] + _loc_5 * (2 * (1 - _loc_5) * (_loc_4[1] - _loc_4[0]) + _loc_5 * (_loc_4[2] - _loc_4[0]));
                }
            }
            if (this._orient)
            {
                _loc_2 = this._orientData.length;
                _loc_8 = {};
                while (_loc_2--)
                {
                    
                    _loc_11 = this._orientData[_loc_2];
                    _loc_8[_loc_11[0]] = this._target[_loc_11[0]];
                    _loc_8[_loc_11[1]] = this._target[_loc_11[1]];
                }
                _loc_13 = this._target;
                _loc_14 = this.round;
                this._target = this._future;
                this.round = false;
                this._orient = false;
                _loc_2 = this._orientData.length;
                while (_loc_2--)
                {
                    
                    _loc_11 = this._orientData[_loc_2];
                    this.changeFactor = param1 + (_loc_11[4] || 0.01);
                    _loc_12 = _loc_11[3] || 0;
                    _loc_9 = this._future[_loc_11[0]] - _loc_8[_loc_11[0]];
                    _loc_10 = this._future[_loc_11[1]] - _loc_8[_loc_11[1]];
                    _loc_13[_loc_11[2]] = Math.atan2(_loc_10, _loc_9) * _RAD2DEG + _loc_12;
                }
                this._target = _loc_13;
                this.round = _loc_14;
                this._orient = true;
            }
            return;
        }// end function

        public static function parseBeziers(param1:Object, param2:Boolean = false) : Object
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = {};
            if (param2)
            {
                for (_loc_6 in param1)
                {
                    
                    _loc_4 = _loc_9[_loc_6];
                    var _loc_10:* = [];
                    _loc_5 = [];
                    _loc_7[_loc_6] = _loc_10;
                    if (_loc_4.length > 2)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1] - (_loc_4[2] - _loc_4[0]) / 4, _loc_4[1]];
                        _loc_3 = 1;
                        while (_loc_3 < (_loc_4.length - 1))
                        {
                            
                            _loc_5[_loc_5.length] = [_loc_4[_loc_3], _loc_4[_loc_3] + (_loc_4[_loc_3] - _loc_5[(_loc_3 - 1)][1]), _loc_4[(_loc_3 + 1)]];
                            _loc_3 = _loc_3 + 1;
                        }
                        continue;
                    }
                    _loc_5[_loc_5.length] = [_loc_4[0], (_loc_4[0] + _loc_4[1]) / 2, _loc_4[1]];
                }
            }
            else
            {
                for (_loc_6 in param1)
                {
                    
                    _loc_4 = _loc_9[_loc_6];
                    var _loc_10:* = [];
                    _loc_5 = [];
                    _loc_7[_loc_6] = _loc_10;
                    if (_loc_4.length > 3)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1], (_loc_4[1] + _loc_4[2]) / 2];
                        _loc_3 = 2;
                        while (_loc_3 < _loc_4.length - 2)
                        {
                            
                            _loc_5[_loc_5.length] = [_loc_5[_loc_3 - 2][2], _loc_4[_loc_3], (_loc_4[_loc_3] + _loc_4[(_loc_3 + 1)]) / 2];
                            _loc_3 = _loc_3 + 1;
                        }
                        _loc_5[_loc_5.length] = [_loc_5[(_loc_5.length - 1)][2], _loc_4[_loc_4.length - 2], _loc_4[(_loc_4.length - 1)]];
                        continue;
                    }
                    if (_loc_4.length == 3)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], _loc_4[1], _loc_4[2]];
                        continue;
                    }
                    if (_loc_4.length == 2)
                    {
                        _loc_5[_loc_5.length] = [_loc_4[0], (_loc_4[0] + _loc_4[1]) / 2, _loc_4[1]];
                    }
                }
            }
            return _loc_7;
        }// end function

    }
}
