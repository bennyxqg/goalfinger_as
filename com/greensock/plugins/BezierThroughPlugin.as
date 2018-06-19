package com.greensock.plugins
{
    import com.greensock.*;

    public class BezierThroughPlugin extends BezierPlugin
    {
        public static const API:Number = 1;

        public function BezierThroughPlugin()
        {
            this.propName = "bezierThrough";
            return;
        }// end function

        override public function onInitTween(param1:Object, param2, param3:TweenLite) : Boolean
        {
            if (!(param2 is Array))
            {
                return false;
            }
            init(param3, param2 as Array, true);
            return true;
        }// end function

    }
}
