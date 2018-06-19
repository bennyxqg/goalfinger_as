package com.greensock.plugins
{
    import com.greensock.*;

    public class AutoAlphaPlugin extends TweenPlugin
    {
        protected var _target:Object;
        protected var _ignoreVisible:Boolean;
        public static const API:Number = 1;

        public function AutoAlphaPlugin()
        {
            this.propName = "autoAlpha";
            this.overwriteProps = ["alpha", "visible"];
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            this._target = param1;
            addTween(param1, "alpha", param1.alpha, param2, "alpha");
            return true;
        }// end function

        override public function killProps(param1:Object) : void
        {
            super.killProps(param1);
            this._ignoreVisible = Boolean("visible" in param1);
            return;
        }// end function

        override public function set changeFactor(param1:Number) : void
        {
            updateTweens(param1);
            if (!this._ignoreVisible)
            {
                this._target.visible = Boolean(this._target.alpha != 0);
            }
            return;
        }// end function

    }
}
