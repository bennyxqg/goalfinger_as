package graf_menu_fla
{
    import flash.display.*;

    dynamic public class StageForceAnim_133 extends MovieClip
    {

        public function StageForceAnim_133()
        {
            addFrameScript(104, this.frame105);
            return;
        }// end function

        function frame105()
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
