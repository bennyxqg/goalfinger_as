package menu.tools
{
    import com.greensock.*;
    import flash.display.*;
    import globz.*;

    public class SparkleAnimation extends MovieClip
    {
        private var vGraf:bitmapClip;
        private var vType:int;

        public function SparkleAnimation(param1:int = 1)
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.vType = param1;
            TweenMax.delayedCall(0.3, this.showAnim);
            return;
        }// end function

        private function showAnim() : void
        {
            if (this.vType == 1 || this.vType == 3)
            {
                TweenMax.delayedCall(0.5 + 1 * Math.random(), this.showAnimDo);
            }
            else if (this.vType == 2)
            {
                TweenMax.delayedCall(1 + 5 * Math.random(), this.showAnimDo);
            }
            return;
        }// end function

        private function showAnimDo() : void
        {
            if (!stage)
            {
                return;
            }
            if (this.vType == 1)
            {
                if (this.vGraf == null)
                {
                    this.vGraf = new bitmapClip(Global.vImages["sparkle"]);
                    this.vGraf.setFPS(45);
                    addChild(this.vGraf);
                }
                this.vGraf.gotoAndPlay("start,end,stop", this.showAnim);
            }
            else if (this.vType == 2)
            {
                if (this.vGraf == null)
                {
                    this.vGraf = new bitmapClip(Global.vImages["sparkle"]);
                    this.vGraf.setFPS(45);
                    addChild(this.vGraf);
                }
                this.vGraf.gotoAndPlay("start,end,stop", this.showAnim);
            }
            else if (this.vType == 3)
            {
                if (this.vGraf == null)
                {
                    this.vGraf = new bitmapClip(Global.vImages["sparkle_alt"]);
                    this.vGraf.setFPS(45);
                    addChild(this.vGraf);
                }
                this.vGraf.gotoAndPlay("start,end,stop", this.showAnim);
            }
            return;
        }// end function

    }
}
