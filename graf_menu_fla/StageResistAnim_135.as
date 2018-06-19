package graf_menu_fla
{
    import flash.display.*;

    dynamic public class StageResistAnim_135 extends MovieClip
    {

        public function StageResistAnim_135()
        {
            addFrameScript(51, this.frame52);
            return;
        }// end function

        function frame52()
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
