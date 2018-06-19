package menu.tools
{
    import com.greensock.*;
    import flash.display.*;
    import globz.*;

    public class LightAnimation extends MovieClip
    {
        private var vGraf:bitmapClip;

        public function LightAnimation()
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            TweenMax.delayedCall(1 + 2 * Math.random(), this.showAnim);
            return;
        }// end function

        private function showAnim() : void
        {
            if (!stage)
            {
                return;
            }
            if (this.vGraf == null)
            {
                this.vGraf = new bitmapClip(Global.vImages["light_anim"]);
                this.vGraf.setFPS(45);
                addChild(this.vGraf);
            }
            this.vGraf.gotoAndPlay("start,end,stop");
            TweenMax.delayedCall(3 + 4 * Math.random(), this.showAnim);
            return;
        }// end function

    }
}
