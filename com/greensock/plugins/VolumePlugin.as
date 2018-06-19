package com.greensock.plugins
{
    import com.greensock.*;
    import flash.media.*;

    public class VolumePlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _st:SoundTransform;
        public static const API:Number = 1;

        public function VolumePlugin()
        {
            this.propName = "volume";
            this.overwriteProps = ["volume"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (isNaN(param2) || param1.hasOwnProperty("volume") || !param1.hasOwnProperty("soundTransform"))
            {
                return false;
            }
            this._target = param1;
            this._st = this._target.soundTransform;
            addTween(this._st, "volume", this._st.volume, param2, "volume");
            return true;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            updateTweens(param1);
            this._target.soundTransform = this._st;
            return;
        }// end function

    }
}
