package com.greensock.plugins
{
    import com.greensock.*;
    import com.greensock.core.*;
    import flash.display.*;
    import flash.geom.*;

    public class TintPlugin extends TweenPlugin
    {
        protected var _transform:Transform;
        public static const API:Number = 1;
        static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        public function TintPlugin()
        {
            this.propName = "tint";
            this.overwriteProps = ["tint"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param1 is DisplayObject))
            {
                return false;
            }
            var _loc_4:* = new ColorTransform();
            if (param2 != null && param3.vars.removeTint != true)
            {
                _loc_4.color = uint(param2);
            }
            this._transform = DisplayObject(param1).transform;
            var _loc_5:* = this._transform.colorTransform;
            _loc_4.alphaMultiplier = _loc_5.alphaMultiplier;
            _loc_4.alphaOffset = _loc_5.alphaOffset;
            this.init(_loc_5, _loc_4);
            return true;
        }// end function

        public function init(param1:ColorTransform, param2:ColorTransform) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = _props.length;
            var _loc_5:* = _tweens.length;
            while (_loc_3--)
            {
                
                _loc_4 = _props[_loc_3];
                if (param1[_loc_4] != param2[_loc_4])
                {
                    _tweens[++_loc_5] = new PropTween(param1, _loc_4, param1[_loc_4], param2[_loc_4] - param1[_loc_4], "tint", false);
                }
            }
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            if (this._transform)
            {
                _loc_2 = this._transform.colorTransform;
                _loc_4 = _tweens.length;
                while (--_loc_4 > -1)
                {
                    
                    _loc_3 = _tweens[_loc_4];
                    _loc_2[_loc_3.property] = _loc_3.start + _loc_3.change * param1;
                }
                this._transform.colorTransform = _loc_2;
            }
            return;
        }// end function

    }
}
