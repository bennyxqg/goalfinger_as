package graf_menu_fla
{
    import flash.display.*;

    dynamic public class StageSpeedAnim_134 extends MovieClip
    {

        public function StageSpeedAnim_134()
        {
            addFrameScript(76, this.frame77);
            return;
        }// end function

        function frame77()
        {
            if (this.stage)
            {
                gotoAndPlay("anim");
            }
            else
            {
                stop();
            }
            return;
        }// end function

    }
}
