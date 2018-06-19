package com.greensock.plugins
{
    import com.greensock.*;
    import com.greensock.core.*;

    public class RoundPropsPlugin extends TweenPlugin
    {
        protected var _tween:TweenLite;
        public static const API:Number = 1;

        public function RoundPropsPlugin()
        {
            this.propName = "roundProps";
            this.overwriteProps = ["roundProps"];
            this.round = true;
            this.priority = -1;
            this.onInitAllProps = this._initAllProps;
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            this._tween = param3;
            this.overwriteProps = this.overwriteProps.concat(param2 as Array);
            return true;
        }// end function

        protected function _initAllProps() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_3:* = this._tween.vars.roundProps;
            var _loc_5:* = _loc_3.length;
            while (--_loc_5 > -1)
            {
                
                _loc_1 = _loc_3[_loc_5];
                _loc_4 = this._tween.cachedPT1;
                while (_loc_4)
                {
                    
                    if (_loc_4.name == _loc_1)
                    {
                        if (_loc_4.isPlugin)
                        {
                            _loc_4.target.round = true;
                        }
                        else
                        {
                            this.add(_loc_4.target, _loc_1, _loc_4.start, _loc_4.change);
                            this._removePropTween(_loc_4);
                            this._tween.propTweenLookup[_loc_1] = this._tween.propTweenLookup.roundProps;
                        }
                    }
                    else if (_loc_4.isPlugin && _loc_4.name == "_MULTIPLE_" && !_loc_4.target.round)
                    {
                        _loc_2 = " " + _loc_4.target.overwriteProps.join(" ") + " ";
                        if (_loc_2.indexOf(" " + _loc_1 + " ") != -1)
                        {
                            _loc_4.target.round = true;
                        }
                    }
                    _loc_4 = _loc_4.nextNode;
                }
            }
            return;
        }// end function

        protected function _removePropTween(param1:PropTween) : void
        {
            if (param1.nextNode)
            {
                param1.nextNode.prevNode = param1.prevNode;
            }
            if (param1.prevNode)
            {
                param1.prevNode.nextNode = param1.nextNode;
            }
            else if (this._tween.cachedPT1 == param1)
            {
                this._tween.cachedPT1 = param1.nextNode;
            }
            if (param1.isPlugin && param1.target.onDisable)
            {
                param1.target.onDisable();
            }
            return;
        }// end function

        public function add(param1:Object, param2:String, param3:Number, param4:Number) : void
        {
            addTween(param1, param2, param3, param3 + param4, param2);
            this.overwriteProps[this.overwriteProps.length] = param2;
            return;
        }// end function

    }
}
